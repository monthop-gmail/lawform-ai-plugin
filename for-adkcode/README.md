# lawform-ai-plugin — for adkcode

Plugin สำหรับ [adkcode](https://github.com/monthop-gmail/server-coding-agent) — Go-based multi-agent coding assistant ที่ใช้ Google ADK

## โครงสร้าง Plugin

```
for-adkcode/
  .claude-plugin/
    plugin.json          — metadata
  .mcp.json              — เชื่อมต่อ lawform MCP server
  skills/
    lawform-lawyer/
      SKILL.md           — AI ทนาย (auto-injected เมื่อ trigger)
    lawform-review/
      SKILL.md           — AI ผู้ตรวจ (auto-injected เมื่อ trigger)
  commands/
    lawyer.md            — /lawyer command
    review.md            — /review command
```

## ติดตั้ง

Copy plugin directory ไปยัง adkcode plugins folder:

```bash
cp -r lawform-ai-plugin/for-adkcode <adkcode-dir>/plugins/lawform
```

หรือถ้ารัน adkcode ด้วย Docker ให้ mount volume:

```yaml
volumes:
  - ./lawform-ai-plugin/for-adkcode:/app/plugins/lawform
```

จากนั้น copy agent docs ไปยัง workspace:

```bash
cp lawform-ai-plugin/agents/LAWYER.md <workspace>/agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md <workspace>/agent-REVIEW.md
```

## ใช้งาน

```
/lawyer [เรื่องราวคดีโดยย่อ]    — เปิดโหมด AI ทนาย
/review <case_id หรือชื่อคดี>   — ตรวจสำนวนคดี
```

หรือบอก AI ตรงๆ:
- "ทำหน้าที่ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [ชื่อคดี]"

## MCP

Plugin เชื่อมต่อ Odoo ผ่าน MCP server อัตโนมัติ (ตาม `.mcp.json`)

ตรวจสอบว่า MCP server ทำงานที่ `http://localhost:8000/mcp/`
