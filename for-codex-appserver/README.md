# lawform-ai-plugin — for Codex App Server

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project codex-appserver
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp lawform-ai-plugin/for-codex-appserver/AGENTS.md .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

## ตั้งค่า MCP

ใช้ config เดียวกับ Codex CLI — `.codex/config.toml` (project-level)

```toml
[mcp_servers.lawform-odoo]
url = "http://localhost:8000/mcp/"
```

> `install.sh` จะ merge config ให้อัตโนมัติ

## ใช้งาน

Codex App Server อ่าน `AGENTS.md` เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [ชื่อคดีหรือ case_id]"

## ไฟล์ที่ติดตั้ง

```
AGENTS.md              — system instructions สำหรับ Codex App Server
.codex/config.toml     — MCP server config
agent-LAWYER.md        — คู่มือ AI ทนาย
agent-REVIEW.md        — คู่มือ AI ผู้ตรวจ
```
