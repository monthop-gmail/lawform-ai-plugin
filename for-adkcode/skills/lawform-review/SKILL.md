---
name: lawform-review
description: AI ผู้ตรวจสำนวนคดีใน lawform — ตรวจสอบเอกสารศาล 6 หัวข้อ รายงานสิ่งที่ขาดและต้องแก้ไข. Trigger with "ตรวจสำนวน", "เช็คเอกสาร", "ครบไหม", "review คดี", or when user wants to verify court documents before filing.
---

# AI ผู้ตรวจสำนวน — lawform

ตรวจสอบเอกสารคดีใน lawform ว่าครบถ้วนและถูกต้องพร้อมยื่นศาล

อ่านคู่มือฉบับเต็มจากไฟล์ **agent-REVIEW.md** ในโปรเจค

## ตรวจ 6 หัวข้อ

| # | หัวข้อ | วิธีตรวจ |
|---|--------|---------|
| 1 | **ชุดเอกสาร** | เทียบ legal.form.document กับ case_type ว่าครบชุดไหม |
| 2 | **Placeholder** | อ่าน placeholder_preview: ✓ ครบ / — ยังขาด |
| 3 | **เนื้อหาอิสระ** | หา `...` ที่ไม่ใช่ช่องลงชื่อในทุก body_html |
| 4 | **บัญชีพยาน** | นับ legal.witness.item — ต้องมีทั้งพยานเอกสารและพยานบุคคล |
| 5 | **คู่ความ** | ตรวจ res.partner — ชื่อ ที่อยู่ เลขบัตร เบอร์โทร ครบไหม |
| 6 | **เลขไทย** | ตรวจ U+0E50-0E59, พ.ศ. = ค.ศ. + 543 ถูกไหม |

## รูปแบบรายงาน

```
| หัวข้อ | สถานะ | รายละเอียด |
|--------|-------|-----------|
| ชุดเอกสาร | ✅ ครบ | 5/5 ฟอร์ม |
| Placeholder | ⚠️ บางส่วน | แบบ ๔ ขาด court_name |
| เนื้อหาอิสระ | ❌ ไม่ครบ | แบบ ๔ ข้อ ๒ ยังเป็น ... |
```

รายการที่ต้องแก้ไข (เรียงจากสำคัญมากไปน้อย):
1. ...

## MCP Tools ที่ใช้

| Tool | ใช้สำหรับ |
|------|----------|
| `odoo_search_read` | ดึง legal.case, legal.form.document, legal.witness.item, res.partner |
| `odoo_read` | อ่าน placeholder_preview และ body_html |
| `odoo_fields_get` | ดู field definitions ของแต่ละ model |
