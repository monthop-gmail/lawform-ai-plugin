"""
lawform Agent — AI ทนายความและผู้ตรวจสำนวน
ใช้ Google ADK + MCP tools เชื่อมต่อ lawform (Odoo)
"""

import os
from google.adk.agents import Agent
from google.adk.tools.mcp_tool.mcp_toolset import McpToolset
from google.adk.tools.mcp_tool.mcp_session_manager import StreamableHTTPConnectionParams

MCP_URL = os.getenv("LAWFORM_MCP_URL", "http://localhost:8000/mcp/")

LAWYER_INSTRUCTION = """
คุณคือ AI ทนายความที่ใช้ระบบ lawform บน Odoo เพื่อจัดเตรียมเอกสารศาลให้ลูกความ

เมื่อลูกความเล่าปัญหาให้ฟัง คุณต้อง:
1. วิเคราะห์ประเภทคดี (civil, criminal, consumer, labor)
2. สร้างข้อมูลคู่ความใน Odoo (odoo_create → res.partner)
3. สร้างคดี (odoo_create → legal.case)
4. สร้างเอกสารครบชุดตามประเภทคดี (odoo_create → legal.form.document)
5. ร่างเนื้อหา: คำฟ้อง คำให้การ บัญชีพยาน
6. ตรวจสอบ placeholder_preview และ apply merge fields

ชุดเอกสารมาตรฐาน:
- คดีแพ่ง: แบบ ๙, แบบ ๑, แบบ ๔, แบบ ๕, แบบ ๑๕
- คดีอาญา: แบบ ๙, แบบ ๔, แบบ ๖, แบบ ๑๕
- ประกันตัว (ถ้ามี): แบบ ๕๗, แบบ ๕๘
- อุทธรณ์ (ถ้ามี): แบบ ๓๒, แบบ ๓๓

กฎสำคัญ:
- ห้ามปล่อยช่อง "..." ว่าง ต้องร่างเนื้อหาให้ครบ
- จำนวนเงินระบุทั้งตัวเลขและตัวอักษร เช่น 500,000 บาท (ห้าแสนบาทถ้วน)
- ใช้ภาษากฎหมายที่ถูกต้อง: "โจทก์", "จำเลย", ไม่ใช่ "ฝ่ายเรา"
- หลังสร้างเอกสารครบ ให้ execute action_apply_merge_fields
""".strip()

REVIEW_INSTRUCTION = """
คุณคือ AI ผู้ตรวจสำนวนคดี ตรวจสอบเอกสารใน lawform ว่าครบถ้วนพร้อมยื่นศาล

ตรวจ 6 หัวข้อ:
1. ชุดเอกสารครบไหม (เทียบกับ case_type)
2. Placeholder ครบไหม (อ่านจาก placeholder_preview ✓/—)
3. เนื้อหาอิสระร่างครบไหม (ไม่มี "..." ที่ไม่ใช่ช่องลงชื่อ)
4. บัญชีพยานครบไหม (legal.witness.item — มีทั้งพยานเอกสารและพยานบุคคล)
5. ข้อมูลคู่ความถูกต้องไหม (res.partner — ชื่อ ที่อยู่ เลขบัตร เบอร์โทร)
6. เลขไทยถูกไหม (U+0E50-0E59 เท่านั้น, พ.ศ. = ค.ศ. + 543)

รายงานผลเป็นตาราง พร้อมรายการที่ต้องแก้ไขเรียงจากสำคัญมากไปน้อย
""".strip()

# ─── Toolset: MCP → Odoo ─────────────────────────────────────────────────────

def create_odoo_toolset() -> McpToolset:
    """สร้าง McpToolset ที่เชื่อมต่อ lawform MCP server"""
    return McpToolset(
        connection_params=StreamableHTTPConnectionParams(url=MCP_URL),
    )

# ─── Agents ──────────────────────────────────────────────────────────────────

lawyer_agent = Agent(
    name="lawform_lawyer",
    model=os.getenv("LAWFORM_MODEL", "gemini-2.5-flash"),
    description="AI ทนายความ — รับเรื่องลูกความ สร้างคดีและเอกสารศาลครบชุดใน Odoo",
    instruction=LAWYER_INSTRUCTION,
    tools=[create_odoo_toolset()],
)

review_agent = Agent(
    name="lawform_review",
    model=os.getenv("LAWFORM_MODEL", "gemini-2.5-flash"),
    description="AI ผู้ตรวจสำนวน — ตรวจสอบเอกสารคดี 6 หัวข้อ รายงานสิ่งที่ขาดและต้องแก้ไข",
    instruction=REVIEW_INSTRUCTION,
    tools=[create_odoo_toolset()],
)

# ─── Root Agent (orchestrator) ────────────────────────────────────────────────

root_agent = Agent(
    name="lawform",
    model=os.getenv("LAWFORM_MODEL", "gemini-2.5-flash"),
    description="lawform AI — ระบบช่วยเหลือทางกฎหมาย สร้างเอกสารศาลและตรวจสำนวนคดี",
    instruction="""
คุณคือ lawform AI ผู้ช่วยด้านกฎหมายสำหรับระบบ lawform (Odoo Thai court forms)

รับงาน 2 ประเภท:
- ถ้าผู้ใช้ต้องการเตรียมเอกสารคดี หรือเล่าเรื่องราวคดีให้ฟัง → โอนให้ lawform_lawyer
- ถ้าผู้ใช้ต้องการตรวจสำนวนคดี หรือเช็คว่าเอกสารครบไหม → โอนให้ lawform_review
    """.strip(),
    sub_agents=[lawyer_agent, review_agent],
)
