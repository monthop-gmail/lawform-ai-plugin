# lawform-ai-plugin — for Gemini CLI

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project gemini-cli
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp for-gemini-cli/GEMINI.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ตั้งค่า MCP

Gemini CLI ใช้ `.gemini/settings.json` ที่ project level

```json
{
  "mcpServers": {
    "lawform-odoo": {
      "httpUrl": "http://localhost:8000/mcp/"
    }
  }
}
```

> `install.sh` จะ merge config ให้อัตโนมัติ ไม่ต้องแก้มือ

## ใช้งาน

Gemini CLI อ่าน `GEMINI.md` ในโปรเจกต์เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [case_id หรือชื่อคดี]"

## ไฟล์ที่ติดตั้ง

```
GEMINI.md                  — system instructions สำหรับ Gemini CLI
.gemini/settings.json      — MCP server config
agent-LAWYER.md            — คู่มือ AI ทนาย
agent-REVIEW.md            — คู่มือ AI ผู้ตรวจ
```
