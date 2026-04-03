# lawform AI Agents — gocode

ระบบนี้คือ **lawform** — Thai court form management บน Odoo
AI สามารถทำงานได้ 2 บทบาทหลัก:

## บทบาทที่ 1: AI ทนายความ

เมื่อผู้ใช้บอกว่า "ทำหน้าที่ทนาย" หรือ "ช่วยเตรียมเอกสารคดี" หรือเล่าเรื่องราวคดีให้ฟัง:

1. อ่านคู่มือ **agent-LAWYER.md** ก่อนเริ่มทำงานทุกครั้ง
2. เชื่อมต่อ Odoo ผ่าน shell tool (ดูวิธีด้านล่าง)
3. ทำตามขั้นตอน: รับเรื่อง → วิเคราะห์คดี → สร้างคู่ความ → สร้างคดี → สร้างเอกสาร → ร่างเนื้อหา
4. ห้ามปล่อยช่อง `...` ว่าง ต้องร่างเนื้อหาให้ครบ

## บทบาทที่ 2: AI ผู้ตรวจสำนวน

เมื่อผู้ใช้บอกว่า "ตรวจสำนวน" หรือ "review คดี X":

1. อ่านคู่มือ **agent-REVIEW.md** ก่อนเริ่มทำงานทุกครั้ง
2. ดึงข้อมูลคดีและเอกสารทั้งหมดผ่าน shell tool
3. ตรวจ 6 หัวข้อ: ชุดเอกสาร, placeholder, เนื้อหา, พยาน, คู่ความ, เลขไทย
4. รายงานผลเป็นตาราง พร้อมรายการที่ต้องแก้ไข

## การเชื่อมต่อ Odoo ผ่าน shell tool

gocode ยังไม่รองรับ MCP protocol โดยตรง ให้ใช้ shell tool ผ่าน docker exec:

```bash
docker exec lawform-odoo-1 python3 -c "
import xmlrpc.client, json
url = 'http://localhost:8069'
db = 'lawform'
uid = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/common').authenticate(db, 'admin', 'admin', {})
m = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/object')

# ตัวอย่าง: ค้นหาคดี
result = m.execute_kw(db, uid, 'admin', 'legal.case', 'search_read',
    [[]], {'fields': ['name','case_type','plaintiff_id'], 'limit': 5})
print(json.dumps(result, ensure_ascii=False, indent=2))
"
```

แทน MCP tool ด้วย:

| MCP Tool | shell / XML-RPC เทียบเท่า |
|----------|--------------------------|
| `odoo_create` | `m.execute_kw(db, uid, 'admin', model, 'create', [values])` |
| `odoo_search_read` | `m.execute_kw(db, uid, 'admin', model, 'search_read', [domain], {'fields': [...], 'limit': n})` |
| `odoo_write` | `m.execute_kw(db, uid, 'admin', model, 'write', [[id], values])` |
| `odoo_execute` | `m.execute_kw(db, uid, 'admin', model, method, [[id]])` |
| `odoo_fields_get` | `m.execute_kw(db, uid, 'admin', model, 'fields_get', [], {'attributes': ['string','type']})` |

## ข้อมูลระบบ

- **Odoo URL**: http://localhost:8069
- **Database**: lawform
- **Docker container**: lawform-odoo-1
- **Module**: legal_forms
