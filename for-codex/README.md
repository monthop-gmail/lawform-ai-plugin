# lawform-ai-plugin — for Codex / OpenAI Codex CLI

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project codex
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp for-codex/AGENTS.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ตั้งค่า MCP

Codex ใช้ `.codex/config.toml` (project-level) หรือ `~/.codex/config.toml` (global)

```toml
[mcp_servers.lawform-odoo]
url = "http://localhost:8000/mcp/"
```

> `install.sh` จะ merge config ให้อัตโนมัติ ไม่ต้องแก้มือ
> หรือใช้คำสั่ง `codex mcp` เพื่อเพิ่ม server ผ่าน CLI ได้เช่นกัน

**หมายเหตุ**: project-scoped config ต้องอยู่ใน trusted project เท่านั้น

## ใช้งาน

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [case_id หรือชื่อคดี]"

## ไฟล์ที่ติดตั้ง

```
AGENTS.md              — system instructions สำหรับ Codex
.codex/config.toml     — MCP server config
agent-LAWYER.md        — คู่มือ AI ทนาย
agent-REVIEW.md        — คู่มือ AI ผู้ตรวจ
```
