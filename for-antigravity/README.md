# lawform-ai-plugin — for Google Antigravity

## ติดตั้ง

```bash
cd /path/to/your-odoo-project
cp for-antigravity/GEMINI.md .
cp -r for-antigravity/.agent .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

Antigravity จะตรวจจับ skills โดยอัตโนมัติจาก `.agent/skills/`

| Skill | เรียกใช้เมื่อ |
|-------|------------|
| `lawform-lawyer` | บอกว่า "ทำหน้าที่ทนาย" หรือเล่าเรื่องคดี |
| `lawform-review` | บอกว่า "ตรวจสำนวนคดี X" |

## ตั้งค่า MCP

Antigravity รองรับ MCP ผ่าน settings — ตั้งค่า Odoo MCP server:

```
MCP Endpoint: http://localhost:8000/mcp/
```

## โครงสร้างที่ติดตั้ง

```
GEMINI.md                              — project rules (trigger: always_on)
.agent/
  skills/
    lawform-lawyer/SKILL.md            — AI ทนาย skill
    lawform-review/SKILL.md            — AI ผู้ตรวจ skill
agent-LAWYER.md                        — คู่มือ AI ทนาย
agent-REVIEW.md                        — คู่มือ AI ผู้ตรวจ
```
