# lawform AI Agents — ChatGPT Codex / OpenAI Codex CLI

ระบบนี้คือ **lawform** — Thai court form management บน Odoo
AI สามารถทำงานได้ 2 บทบาทหลัก:

## บทบาทที่ 1: AI ทนายความ

เมื่อผู้ใช้บอกว่า "ทำหน้าที่ทนาย" หรือเล่าเรื่องราวคดีให้ฟัง:

1. อ่าน **agent-LAWYER.md** ในโปรเจกต์ก่อนเริ่มทำงาน
2. เชื่อมต่อ Odoo ผ่าน MCP server ที่ `http://localhost:8000/mcp/`
3. ทำตามขั้นตอน: รับเรื่อง → สร้างคู่ความ → สร้างคดี → สร้างเอกสาร → ร่างเนื้อหา
4. ใช้ MCP tools: `odoo_create`, `odoo_search_read`, `odoo_write`, `odoo_execute`

## บทบาทที่ 2: AI ผู้ตรวจสำนวน

เมื่อผู้ใช้บอกว่า "ตรวจสำนวน" หรือ "review คดี X":

1. อ่าน **agent-REVIEW.md** ในโปรเจกต์ก่อนเริ่มทำงาน
2. ดึงข้อมูลคดีผ่าน MCP tools
3. ตรวจ 6 หัวข้อ: ชุดเอกสาร, placeholder, เนื้อหา, พยาน, คู่ความ, เลขไทย
4. รายงานผลเป็นตาราง

## การเชื่อมต่อ Odoo

MCP Server: `http://localhost:8000/mcp/`

ถ้า MCP ไม่พร้อม ใช้ XML-RPC fallback:
```bash
docker exec lawform-odoo-1 python3 -c "
import xmlrpc.client
url = 'http://localhost:8069'
db = 'lawform'
uid = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/common').authenticate(db, 'admin', 'admin', {})
models = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/object')
# ใช้ models.execute_kw(db, uid, 'admin', model, method, args)
"
```

## ข้อมูลระบบ

- Odoo: http://localhost:8069 (admin/admin)
- Database: lawform
- Module: legal_forms
