# lawform-ai-plugin — for OpenCode

## ติดตั้ง

```bash
cd /path/to/your-odoo-project
cp for-opencode/opencode.json .
cp for-opencode/AGENTS.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

OpenCode ใช้ AGENTS.md เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [case_id หรือชื่อคดี]"

## ตั้งค่า MCP

แก้ `opencode.json` ให้ชี้ไปที่ MCP server ของคุณ:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "odoo": {
      "type": "http",
      "url": "http://localhost:8000/mcp/"
    }
  }
}
```

## ไฟล์ที่ติดตั้ง

```
opencode.json   — OpenCode config + MCP server
AGENTS.md       — system instructions สำหรับ OpenCode
agent-LAWYER.md — คู่มือ AI ทนาย
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ
```
