# lawform-ai-plugin — for gocode

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project gocode
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp lawform-ai-plugin/for-gocode/AGENTS.md .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

gocode อ่าน `AGENTS.md` ในโปรเจกต์เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [ชื่อคดีหรือ case_id]"

## หมายเหตุ MCP

gocode ยังไม่รองรับ MCP โดยตรง — ใช้ shell tool ผ่าน `docker exec` แทน
(ดูตัวอย่างใน `AGENTS.md`)

เมื่อ gocode รองรับ MCP จะสามารถเชื่อม `http://localhost:8000/mcp/` ได้โดยตรง

## ไฟล์ที่ติดตั้ง

```
AGENTS.md       — system instructions สำหรับ gocode
agent-LAWYER.md — คู่มือ AI ทนาย
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ
```
