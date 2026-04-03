# lawform-ai-plugin — for GitHub Copilot CLI

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project copilot-cli
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp for-copilot-cli/AGENTS.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ตั้งค่า MCP

Copilot CLI ใช้ `~/.copilot/mcp-config.json` (global)

```json
{
  "mcpServers": {
    "lawform-odoo": {
      "type": "http",
      "url": "http://localhost:8000/mcp/"
    }
  }
}
```

> `install.sh` จะ merge config ให้อัตโนมัติ ไม่ต้องแก้มือ
> หรือใช้คำสั่ง `/mcp add` ใน Copilot CLI ได้เช่นกัน

## ใช้งาน

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [case_id หรือชื่อคดี]"

## ไฟล์ที่ติดตั้ง

```
AGENTS.md                        — system instructions
agent-LAWYER.md                  — คู่มือ AI ทนาย
agent-REVIEW.md                  — คู่มือ AI ผู้ตรวจ

~/.copilot/mcp-config.json       — MCP server config (global)
```
