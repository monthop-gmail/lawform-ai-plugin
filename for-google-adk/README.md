# lawform-ai-plugin — for Google ADK

Python agent สำหรับ Google Agent Development Kit (ADK)
ใช้ MCP tools เชื่อมต่อ lawform (Odoo) โดยตรง

## โครงสร้าง

```
for-google-adk/
  lawform_agent/
    __init__.py
    agent.py        — root_agent + lawyer_agent + review_agent
    .env.example    — environment variables
  pyproject.toml    — dependencies
  README.md
```

## Agents

```
root_agent (lawform)
  ├── lawyer_agent (lawform_lawyer)   — สร้างคดี + เอกสารครบชุด
  └── review_agent (lawform_review)  — ตรวจสำนวน 6 หัวข้อ
```

`root_agent` รับเรื่องและโอนงานให้ sub-agent ที่เหมาะสมอัตโนมัติ

## ติดตั้ง

```bash
cd for-google-adk

# สร้าง virtual environment
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

# ติดตั้ง dependencies
pip install -e .

# ตั้งค่า environment
cp lawform_agent/.env.example lawform_agent/.env
# แก้ไข .env ใส่ GOOGLE_API_KEY
```

## ใช้งาน

```bash
# Dev UI (browser)
adk web

# Terminal
adk run lawform_agent

# API server
adk api_server
```

## ตั้งค่า

| Variable | Default | คำอธิบาย |
|----------|---------|---------|
| `GOOGLE_API_KEY` | — | Gemini API key (required) |
| `LAWFORM_MCP_URL` | `http://localhost:8000/mcp/` | lawform MCP server URL |
| `LAWFORM_MODEL` | `gemini-2.5-flash` | Gemini model ที่ใช้ |

## MCP Tools (จาก odoo-mcp-claude)

root_agent และ sub-agents ใช้ tools ทั้งหมดจาก MCP server โดยตรง:
`odoo_create`, `odoo_search_read`, `odoo_write`, `odoo_execute`, `odoo_fields_get`

## ความต้องการ

- Python >= 3.11
- Google ADK >= 1.0.0
- Gemini API key (https://aistudio.google.com/apikey)
- lawform MCP server ทำงานที่ `http://localhost:8000/mcp/`
- Odoo 19.0 พร้อมติดตั้ง module `legal_forms`
