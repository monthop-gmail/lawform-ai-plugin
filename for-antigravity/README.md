# lawform-ai-plugin — for Google Antigravity

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project antigravity
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp for-antigravity/GEMINI.md .
cp -r for-antigravity/.agent .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ตั้งค่า MCP

Antigravity ใช้ config ที่ `~/.gemini/antigravity/mcp_config.json` (global)

เพิ่ม lawform-odoo server:

```bash
mkdir -p ~/.gemini/antigravity
```

แก้ไข `~/.gemini/antigravity/mcp_config.json`:

```json
{
  "mcpServers": {
    "lawform-odoo": {
      "serverUrl": "http://localhost:8000/mcp/"
    }
  }
}
```

> `install.sh` จะ merge config ให้อัตโนมัติ ไม่ต้องแก้มือ

## ใช้งาน

Antigravity จะตรวจจับ skills โดยอัตโนมัติจาก `.agent/skills/`

| Skill | เรียกใช้เมื่อ |
|-------|------------|
| `lawform-lawyer` | บอกว่า "ทำหน้าที่ทนาย" หรือเล่าเรื่องคดี |
| `lawform-review` | บอกว่า "ตรวจสำนวนคดี X" |

## โครงสร้างที่ติดตั้ง

```
GEMINI.md                              — project rules (trigger: always_on)
.agent/
  skills/
    lawform-lawyer/SKILL.md            — AI ทนาย skill
    lawform-review/SKILL.md            — AI ผู้ตรวจ skill
agent-LAWYER.md                        — คู่มือ AI ทนาย
agent-REVIEW.md                        — คู่มือ AI ผู้ตรวจ

~/.gemini/antigravity/mcp_config.json  — MCP server config (global)
```
