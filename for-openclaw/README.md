# lawform-ai-plugin — for OpenClaw

TypeScript plugin สำหรับ OpenClaw ให้ AI ทำงานในระบบ lawform ได้โดยตรง

## ติดตั้ง

```bash
# ติดตั้งผ่าน ClawHub (เมื่อ publish แล้ว)
openclaw plugins install @lawform/openclaw-plugin

# หรือ local install
openclaw plugins install /path/to/lawform-ai-plugin/for-openclaw
```

## ตั้งค่า

หลังติดตั้ง ตั้งค่า MCP URL ใน OpenClaw config:

```bash
openclaw config set lawform-legal.mcpUrl http://localhost:8000/mcp/
openclaw config set lawform-legal.odooUrl http://localhost:8069
openclaw config set lawform-legal.database lawform
```

## Tools ที่ลงทะเบียน

| Tool | ใช้สำหรับ |
|------|----------|
| `lawform_start_lawyer_mode` | เริ่มโหมด AI ทนาย |
| `lawform_search_cases` | ค้นหาคดีในระบบ |
| `lawform_get_case` | ดูรายละเอียดคดี + เอกสาร |
| `lawform_create_case` | สร้างคดีใหม่ |
| `lawform_create_document` | สร้างเอกสารศาลจาก template |
| `lawform_apply_merge` | เติมข้อมูลลงเอกสาร |
| `lawform_review_case` | ตรวจสำนวน 6 หัวข้อ |

## ใช้งาน

บอก OpenClaw:
- "ทำหน้าที่ทนายความ ลูกความมีเรื่องกู้ยืมเงิน 500,000 บาท..."
- "ตรวจสำนวนคดี ID 42"

## ความต้องการ

- OpenClaw >= 2026.3.24-beta.2
- lawform MCP server ทำงานที่ `http://localhost:8000/mcp/`
- Odoo 19.0 พร้อมติดตั้ง module `legal_forms`
