# lawform-ai-plugin — for ChatGPT Codex / OpenAI Codex CLI

## ติดตั้ง

```bash
cd /path/to/your-odoo-project
cp for-chatgpt-codex/AGENTS.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

OpenAI Codex CLI อ่าน `AGENTS.md` ในโปรเจกต์เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [ชื่อคดีหรือ case_id]"

## ตั้งค่า MCP (ถ้า Codex รองรับ)

ถ้า Codex version ที่ใช้รองรับ MCP เพิ่ม config:

```json
{
  "mcp_servers": {
    "odoo": {
      "url": "http://localhost:8000/mcp/"
    }
  }
}
```

## ไฟล์ที่ติดตั้ง

```
AGENTS.md       — system instructions สำหรับ OpenAI Codex
agent-LAWYER.md — คู่มือ AI ทนาย
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ
```

## หมายเหตุ

ChatGPT web interface และ API ใช้ `AGENTS.md` เป็น custom instructions ได้เช่นกัน
โดยคัดลอกเนื้อหาใส่ใน System Prompt หรือ Custom Instructions
