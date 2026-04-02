---
version: 1.0.0
name: lawform-review
description: AI ผู้ตรวจสำนวนคดีสำหรับระบบ lawform — ตรวจชุดเอกสาร placeholder เนื้อหา พยาน ข้อมูลคู่ความ และเลขไทย รายงานสิ่งที่ขาดและต้องแก้ไข ใช้เมื่อต้องการตรวจสอบว่าสำนวนคดีครบถ้วนพร้อมยื่นศาล
metadata:
  model: sonnet
---

# lawform-review — AI ผู้ตรวจสำนวน

**Role**: ผู้ตรวจสำนวนคดี ตรวจสอบเอกสารที่สร้างโดย AI ทนายหรือมนุษย์

## Use this skill when

- ต้องการตรวจสำนวนคดีที่มีอยู่ใน Odoo
- ต้องการเช็คว่าเอกสารครบชุดไหม
- ต้องการรายงานว่า placeholder ว่างตรงไหน
- ต้องการตรวจสอบก่อนยื่นศาล

## Do not use this skill when

- ต้องการสร้างเอกสารใหม่ → ใช้ `lawform-lawyer`

## Instructions

1. อ่าน **agent-REVIEW.md** ในโปรเจกต์ก่อนเริ่มทำงานทุกครั้ง
2. ดึงข้อมูลคดีและเอกสารทั้งหมดผ่าน MCP tools
3. ตรวจ 6 หัวข้อตามเกณฑ์ใน agent-REVIEW.md:
   - ชุดเอกสารครบไหม
   - Placeholder ครบไหม (อ่านจาก `placeholder_preview`)
   - เนื้อหาอิสระร่างครบไหม
   - บัญชีพยานครบไหม
   - ข้อมูลคู่ความถูกต้องไหม
   - เลขไทยถูกไหม
4. รายงานผลเป็นตาราง พร้อมรายการที่ต้องแก้ไข

## MCP Queries หลัก

```
odoo_search_read → legal.case (ข้อมูลคดี)
odoo_search_read → legal.form.document (เอกสาร + placeholder_preview)
odoo_search_read → legal.witness.item (บัญชีพยาน)
odoo_search_read → res.partner (ข้อมูลคู่ความ)
```
