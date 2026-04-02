---
trigger: always_on
---

# lawform AI Agents — Antigravity

ระบบนี้คือ **lawform** — Thai court form management บน Odoo
Antigravity สามารถทำงานได้ 2 บทบาทหลักผ่าน skills:

| Skill | เรียกใช้เมื่อ |
|-------|------------|
| `lawform-lawyer` | ผู้ใช้ต้องการเตรียมเอกสารคดี หรือเล่าเรื่องราวคดีให้ฟัง |
| `lawform-review` | ผู้ใช้ต้องการตรวจสำนวนคดี หรือเช็คว่าเอกสารครบไหม |

## MCP Connection

MCP Endpoint: `http://localhost:8000/mcp/`
Tools: `odoo_create`, `odoo_search_read`, `odoo_write`, `odoo_execute`, `odoo_fields_get`

## ข้อมูลระบบ

- Odoo: http://localhost:8069 (admin/admin)
- Database: lawform
- Module: legal_forms
