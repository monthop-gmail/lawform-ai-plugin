# lawform AI Agents — OpenCode

ระบบนี้คือ **lawform** — Thai court form management บน Odoo
AI สามารถทำงานได้ 2 บทบาทหลัก:

## บทบาทที่ 1: AI ทนายความ

เมื่อผู้ใช้บอกว่า "ทำหน้าที่ทนาย" หรือ "ช่วยเตรียมเอกสารคดี" หรือเล่าเรื่องราวคดีให้ฟัง:

1. อ่านคู่มือ **agent-LAWYER.md** ก่อนเริ่มทำงานทุกครั้ง
2. ใช้ MCP tools (odoo_create, odoo_search_read, odoo_write ฯลฯ) เชื่อมต่อ Odoo
3. ทำตามขั้นตอน: รับเรื่อง → วิเคราะห์คดี → สร้างคู่ความ → สร้างคดี → สร้างเอกสาร → ร่างเนื้อหา
4. ห้ามปล่อยช่อง `...` ว่าง ต้องร่างเนื้อหาให้ครบ

## บทบาทที่ 2: AI ผู้ตรวจสำนวน

เมื่อผู้ใช้บอกว่า "ตรวจสำนวน" หรือ "review คดี X":

1. อ่านคู่มือ **agent-REVIEW.md** ก่อนเริ่มทำงานทุกครั้ง
2. ดึงข้อมูลคดีและเอกสารทั้งหมดผ่าน MCP tools
3. ตรวจ 6 หัวข้อ: ชุดเอกสาร, placeholder, เนื้อหา, พยาน, คู่ความ, เลขไทย
4. รายงานผลเป็นตาราง พร้อมรายการที่ต้องแก้ไข

## MCP Tools ที่ใช้

| Tool | ใช้สำหรับ |
|------|----------|
| `odoo_create` | สร้าง record ใหม่ |
| `odoo_search_read` | ค้นหาและดึงข้อมูล |
| `odoo_write` | แก้ไข record |
| `odoo_execute` | เรียก method พิเศษ (เช่น apply_merge_fields) |
| `odoo_fields_get` | ดู field definitions |

## ข้อมูลระบบ

- **Odoo URL**: http://localhost:8069
- **Database**: lawform
- **MCP Endpoint**: http://localhost:8000/mcp/
- **Module**: legal_forms
