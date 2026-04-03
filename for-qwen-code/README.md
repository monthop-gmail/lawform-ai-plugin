# lawform-ai-plugin — for Qwen Code

## ติดตั้ง

```bash
./install.sh /path/to/your-odoo-project qwen-code
```

หรือ copy manual:

```bash
cd /path/to/your-odoo-project
cp lawform-ai-plugin/for-qwen-code/AGENTS.md .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

## ใช้งาน

Qwen Code อ่าน `AGENTS.md` ในโปรเจกต์เป็น system instructions โดยอัตโนมัติ

บอก AI ในแต่ละ session:
- "ทำหน้าที่ AI ทนาย รับเรื่อง [รายละเอียดคดี]"
- "ตรวจสำนวนคดี [ชื่อคดีหรือ case_id]"

## ไฟล์ที่ติดตั้ง

```
AGENTS.md       — system instructions สำหรับ Qwen Code
agent-LAWYER.md — คู่มือ AI ทนาย
agent-REVIEW.md — คู่มือ AI ผู้ตรวจ
```
