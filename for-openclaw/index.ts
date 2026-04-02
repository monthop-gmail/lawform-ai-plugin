import { definePluginEntry } from "openclaw/plugin-sdk/plugin-entry";
import { Type } from "@sinclair/typebox";

const LAWYER_INSTRUCTIONS = `
คุณคือ AI ทนายความที่ใช้ระบบ lawform บน Odoo เพื่อจัดเตรียมเอกสารศาลให้ครบชุด
ใช้ tools ที่ขึ้นต้นด้วย lawform_ เพื่อทำงานกับระบบ
ขั้นตอน: รับเรื่อง → วิเคราะห์คดี → สร้างคู่ความ → สร้างคดี → สร้างเอกสาร → ร่างเนื้อหา
ห้ามปล่อยช่องว่างในเอกสาร ต้องร่างเนื้อหาให้ครบทุกฟอร์ม
`.trim();

const REVIEW_INSTRUCTIONS = `
คุณคือ AI ผู้ตรวจสำนวนคดี ตรวจสอบเอกสารใน lawform ว่าครบถ้วนพร้อมยื่นศาล
ตรวจ 6 หัวข้อ: ชุดเอกสาร, placeholder, เนื้อหา, พยาน, ข้อมูลคู่ความ, เลขไทย
รายงานผลเป็นตาราง พร้อมรายการที่ต้องแก้ไข
`.trim();

export default definePluginEntry({
  id: "lawform-legal",
  name: "Lawform Legal",
  description:
    "Thai court document assistant — AI lawyer and case reviewer via lawform (Odoo)",

  register(api) {
    const config = api.config as {
      mcpUrl?: string;
      odooUrl?: string;
      database?: string;
    };

    const mcpUrl = config.mcpUrl ?? "http://localhost:8000/mcp/";

    // ─── Helper: call odoo MCP server ────────────────────────────────────
    async function callMcp(
      tool: string,
      args: Record<string, unknown>
    ): Promise<unknown> {
      const res = await fetch(mcpUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          jsonrpc: "2.0",
          id: 1,
          method: "tools/call",
          params: { name: tool, arguments: args },
        }),
      });
      if (!res.ok) throw new Error(`MCP error: ${res.status}`);
      const data = (await res.json()) as {
        result?: { content?: Array<{ text?: string }> };
        error?: { message: string };
      };
      if (data.error) throw new Error(data.error.message);
      return data.result?.content?.[0]?.text ?? data.result;
    }

    // ─── Tool: ค้นหาคดี ────────────────────────────────────────────────
    api.registerTool({
      name: "lawform_search_cases",
      description:
        "ค้นหาคดีใน lawform — ระบุชื่อหรือ keyword เพื่อดูรายการคดีทั้งหมด",
      parameters: Type.Object({
        keyword: Type.String({ description: "ชื่อคดีหรือ keyword" }),
        limit: Type.Optional(
          Type.Number({ description: "จำนวนสูงสุด (default 10)" })
        ),
      }),
      async execute(_id, params) {
        const result = await callMcp("odoo_search_read", {
          model: "legal.case",
          domain: [["name", "ilike", params.keyword]],
          fields: [
            "id",
            "name",
            "case_type",
            "court_name",
            "plaintiff_id",
            "defendant_id",
          ],
          limit: params.limit ?? 10,
        });
        return {
          content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
        };
      },
    });

    // ─── Tool: ดูรายละเอียดคดี ────────────────────────────────────────
    api.registerTool({
      name: "lawform_get_case",
      description: "ดูรายละเอียดคดีและเอกสารทั้งหมด จาก case_id",
      parameters: Type.Object({
        case_id: Type.Number({ description: "ID ของคดี" }),
      }),
      async execute(_id, params) {
        const [caseData, documents] = await Promise.all([
          callMcp("odoo_search_read", {
            model: "legal.case",
            domain: [["id", "=", params.case_id]],
            fields: [
              "name",
              "case_type",
              "case_category",
              "court_name",
              "plaintiff_id",
              "defendant_id",
              "lawyer_id",
              "charge",
              "claim_amount",
              "black_case_no",
              "red_case_no",
            ],
          }),
          callMcp("odoo_search_read", {
            model: "legal.form.document",
            domain: [["case_id", "=", params.case_id]],
            fields: [
              "id",
              "name",
              "state",
              "placeholder_preview",
              "template_id",
            ],
          }),
        ]);
        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({ case: caseData, documents }, null, 2),
            },
          ],
        };
      },
    });

    // ─── Tool: สร้างคดีใหม่ ───────────────────────────────────────────
    api.registerTool({
      name: "lawform_create_case",
      description:
        "สร้างคดีใหม่ใน lawform พร้อมข้อมูลคู่ความ — AI ทนายใช้เมื่อรับเรื่องลูกความ",
      parameters: Type.Object({
        name: Type.String({ description: "ชื่อ/เลขคดี เช่น ผบ.1234/2569" }),
        case_type: Type.String({
          description: "civil | criminal | consumer | labor | bankruptcy | admin",
        }),
        case_category: Type.String({
          description: "แพ่ง | อาญา | ผู้บริโภค | แรงงาน",
        }),
        court_name: Type.String({ description: "ชื่อศาล" }),
        plaintiff_id: Type.Number({ description: "ID โจทก์ (res.partner)" }),
        defendant_id: Type.Number({ description: "ID จำเลย (res.partner)" }),
        lawyer_id: Type.Optional(
          Type.Number({ description: "ID ทนายความ (res.partner)" })
        ),
        charge: Type.Optional(Type.String({ description: "ข้อหา/ข้อพิพาท" })),
        claim_amount: Type.Optional(
          Type.Number({ description: "ทุนทรัพย์ (บาท)" })
        ),
      }),
      async execute(_id, params) {
        const result = await callMcp("odoo_create", {
          model: "legal.case",
          values: {
            ...params,
            plaintiff_ids: [[6, 0, [params.plaintiff_id]]],
            defendant_ids: [[6, 0, [params.defendant_id]]],
          },
        });
        return {
          content: [{ type: "text", text: `สร้างคดีสำเร็จ: case_id = ${result}` }],
        };
      },
    });

    // ─── Tool: สร้างเอกสาร ────────────────────────────────────────────
    api.registerTool({
      name: "lawform_create_document",
      description:
        "สร้างเอกสารศาล (legal.form.document) จาก template — ระบุ template code เช่น 'แบบ ๔'",
      parameters: Type.Object({
        case_id: Type.Number({ description: "ID ของคดี" }),
        template_code: Type.String({
          description: "รหัส template เช่น 'แบบ ๔', 'แบบ ๙'",
        }),
        document_name: Type.String({
          description: "ชื่อเอกสาร เช่น 'คำฟ้อง - ผบ.1234/2569'",
        }),
      }),
      async execute(_id, params) {
        const templates = (await callMcp("odoo_search_read", {
          model: "legal.form.template",
          domain: [["code", "=", params.template_code]],
          fields: ["id", "name"],
          limit: 1,
        })) as Array<{ id: number; name: string }>;

        if (!templates?.length) {
          return {
            content: [
              {
                type: "text",
                text: `ไม่พบ template: ${params.template_code}`,
              },
            ],
          };
        }

        const docId = await callMcp("odoo_create", {
          model: "legal.form.document",
          values: {
            name: params.document_name,
            template_id: templates[0].id,
            case_id: params.case_id,
          },
        });

        return {
          content: [
            {
              type: "text",
              text: `สร้างเอกสาร '${params.document_name}' สำเร็จ: doc_id = ${docId}`,
            },
          ],
        };
      },
    });

    // ─── Tool: เติม placeholder ───────────────────────────────────────
    api.registerTool({
      name: "lawform_apply_merge",
      description:
        "เติมข้อมูลลงเอกสาร (apply merge fields) — เรียกหลังจากสร้างเอกสารและตรวจสอบ placeholder ครบแล้ว",
      parameters: Type.Object({
        doc_id: Type.Number({ description: "ID ของเอกสาร" }),
      }),
      async execute(_id, params) {
        await callMcp("odoo_execute", {
          model: "legal.form.document",
          method: "action_apply_merge_fields",
          args: [[params.doc_id]],
        });
        return {
          content: [
            {
              type: "text",
              text: `เติมข้อมูลลงเอกสาร doc_id=${params.doc_id} สำเร็จ`,
            },
          ],
        };
      },
    });

    // ─── Tool: ตรวจสำนวน ──────────────────────────────────────────────
    api.registerTool({
      name: "lawform_review_case",
      description:
        "ตรวจสำนวนคดี 6 หัวข้อ: ชุดเอกสาร, placeholder, เนื้อหา, พยาน, คู่ความ, เลขไทย",
      parameters: Type.Object({
        case_id: Type.Number({ description: "ID ของคดีที่ต้องการตรวจ" }),
      }),
      async execute(_id, params) {
        const [caseData, documents, witnesses] = await Promise.all([
          callMcp("odoo_search_read", {
            model: "legal.case",
            domain: [["id", "=", params.case_id]],
            fields: [
              "name",
              "case_type",
              "plaintiff_id",
              "defendant_id",
              "lawyer_id",
            ],
          }),
          callMcp("odoo_search_read", {
            model: "legal.form.document",
            domain: [["case_id", "=", params.case_id]],
            fields: ["id", "name", "placeholder_preview", "template_id"],
          }),
          callMcp("odoo_search_read", {
            model: "legal.witness.item",
            domain: [["document_id.case_id", "=", params.case_id]],
            fields: ["name", "witness_type", "facts_to_prove", "document_id"],
          }),
        ]);

        const reviewData = {
          instructions: REVIEW_INSTRUCTIONS,
          case: caseData,
          documents,
          witnesses,
        };

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(reviewData, null, 2),
            },
          ],
        };
      },
    });

    // ─── Tool: เริ่มโหมดทนายความ ──────────────────────────────────────
    api.registerTool({
      name: "lawform_start_lawyer_mode",
      description:
        "เริ่มโหมด AI ทนายความ — ส่งคืน instructions สำหรับ AI เพื่อรับเรื่องลูกความและเตรียมเอกสารคดี",
      parameters: Type.Object({
        case_description: Type.Optional(
          Type.String({ description: "รายละเอียดคดีเบื้องต้น (ถ้ามี)" })
        ),
      }),
      async execute(_id, params) {
        return {
          content: [
            {
              type: "text",
              text: [
                LAWYER_INSTRUCTIONS,
                "",
                "MCP tools พร้อมใช้: lawform_search_cases, lawform_get_case,",
                "lawform_create_case, lawform_create_document, lawform_apply_merge",
                "",
                params.case_description
                  ? `รายละเอียดคดีเบื้องต้น: ${params.case_description}`
                  : "รอรับเรื่องจากลูกความ",
              ].join("\n"),
            },
          ],
        };
      },
    });
  },
});
