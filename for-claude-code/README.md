# lawform-ai-plugin — for Claude Code

## ติดตั้ง

```bash
cd /path/to/your-odoo-project
cp -r for-claude-code/.claude .
cp for-claude-code/.mcp.json .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

| คำสั่ง | ทำอะไร |
|--------|--------|
| `/lawyer <รายละเอียดคดี>` | AI ทนายรับเรื่อง สร้างคดี + เอกสารครบชุด |
| `/review <case_id หรือชื่อคดี>` | AI ตรวจสำนวน 6 หัวข้อ รายงานผล |

## ตั้งค่า MCP

แก้ `.mcp.json` ให้ชี้ไปที่ MCP server ของคุณ:

```json
{
  "mcpServers": {
    "odoo": {
      "type": "http",
      "url": "http://localhost:8000/mcp/"
    }
  }
}
```

## ไฟล์ที่ติดตั้ง

```
.claude/commands/
  lawyer.md     — /lawyer skill
  review.md     — /review skill
.mcp.json       — MCP server config
agent-LAWYER.md — คู่มือ AI ทนาย (อ้างอิงโดย lawyer.md)
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ (อ้างอิงโดย review.md)
```
