# lawform-ai-plugin — for GitHub Copilot CLI

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project copilot-cli
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp lawform-ai-plugin/for-copilot-cli/AGENTS.md .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

GitHub Copilot CLI อ่าน `AGENTS.md` เป็น system instructions

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [ชื่อคดีหรือ case_id]"

## ไฟล์ที่ติดตั้ง

```
AGENTS.md       — system instructions สำหรับ GitHub Copilot CLI
agent-LAWYER.md — คู่มือ AI ทนาย
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ
```
