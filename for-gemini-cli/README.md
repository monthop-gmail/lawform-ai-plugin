# lawform-ai-plugin — for Gemini CLI

## ติดตั้ง

```bash
cd /path/to/your-odoo-project
cp for-gemini-cli/GEMINI.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

Gemini CLI อ่าน `GEMINI.md` ในโปรเจกต์เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [case_id หรือชื่อคดี]"

## ตั้งค่า MCP (Gemini CLI 1.x+)

ถ้า Gemini CLI version ที่ใช้รองรับ MCP เพิ่มใน `.gemini/settings.json`:

```json
{
  "mcpServers": {
    "odoo": {
      "httpUrl": "http://localhost:8000/mcp/"
    }
  }
}
```

## ไฟล์ที่ติดตั้ง

```
GEMINI.md       — system instructions สำหรับ Gemini CLI
agent-LAWYER.md — คู่มือ AI ทนาย
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ
```
