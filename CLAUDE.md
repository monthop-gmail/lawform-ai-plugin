# CLAUDE.md — lawform-ai-plugin

## Project Overview

AI plugin สำหรับระบบ **lawform** (Odoo Thai court forms)
แยกออกจาก `lawform-odoo` เพื่อรองรับหลาย AI tools

- **Odoo module**: https://github.com/monthop-gmail/lawform-odoo
- **MCP server**: `/opt/docker-test/odoo-mcp-claude/` (http://localhost:8000/mcp/)

## โครงสร้าง

```
lawform-ai-plugin/
  agents/
    LAWYER.md          — คู่มือ AI ทนาย (tool-agnostic core knowledge)
    REVIEW.md          — คู่มือ AI ผู้ตรวจ (tool-agnostic core knowledge)
  for-claude-code/
    .claude/commands/
      lawyer.md        — /lawyer skill
      review.md        — /review skill
    .mcp.json          — MCP config template
  for-opencode/
    AGENTS.md          — system instructions
    opencode.json      — MCP config
  for-chatgpt-codex/
    AGENTS.md          — system instructions
  for-gemini-cli/
    GEMINI.md          — project instructions
  for-antigravity/
    GEMINI.md          — rules (trigger: always_on)
    .agent/skills/
      lawform-lawyer/SKILL.md
      lawform-review/SKILL.md
  for-openclaw/
    index.ts           — TypeScript plugin (definePluginEntry)
    openclaw.plugin.json
    package.json       — @lawform/openclaw-plugin
  for-google-adk/
    lawform_agent/
      agent.py         — root_agent + lawyer_agent + review_agent (Python)
    pyproject.toml
  install.sh           — one-command installer
```

## ติดตั้งให้ project

```bash
# Claude Code (default)
./install.sh /path/to/project

# ระบุ tool
./install.sh /path/to/project opencode
./install.sh /path/to/project gemini-cli
./install.sh /path/to/project antigravity

# OpenClaw (npm plugin — ติดตั้งต่างออกไป)
./install.sh . openclaw
```

## Core Agents

### AI ทนายความ (`agents/LAWYER.md`)

- รับเรื่องลูกความ → วิเคราะห์คดี → สร้างคู่ความ + คดี + เอกสารครบชุด
- ร่างเนื้อหา: คำฟ้อง คำให้การ บัญชีพยาน
- เชื่อมต่อ Odoo ผ่าน MCP tools (`odoo_create`, `odoo_search_read` ฯลฯ)
- รองรับ: คดีแพ่ง, อาญา, ประกันตัว, อุทธรณ์

### AI ผู้ตรวจสำนวน (`agents/REVIEW.md`)

- ตรวจ 6 หัวข้อ: ชุดเอกสาร, placeholder, เนื้อหา, พยาน, คู่ความ, เลขไทย
- รายงานผลเป็นตาราง พร้อมรายการที่ต้องแก้ไข

## MCP Tools (Odoo)

| Tool | ใช้สำหรับ |
|------|----------|
| `odoo_create` | สร้าง record |
| `odoo_search_read` | ค้นหาและดึงข้อมูล |
| `odoo_write` | แก้ไข record |
| `odoo_execute` | เรียก method (เช่น `action_apply_merge_fields`) |
| `odoo_fields_get` | ดู field definitions |

## Key Odoo Models

| Model | คืออะไร |
|-------|--------|
| `legal.case` | คดีความ |
| `legal.form.document` | เอกสารศาล (มี `placeholder_preview`) |
| `legal.form.template` | template 92 ฟอร์ม (code: `แบบ ๔` ฯลฯ) |
| `legal.witness.item` | บัญชีพยาน |
| `legal.continuous.text` | ข้อความต่อเนื่อง (เนื้อหายาว) |
| `res.partner` | คู่ความ + ทนายความ |

## การแก้ไข Plugin

### อัปเดต core agent docs
แก้ไขที่ `agents/LAWYER.md` หรือ `agents/REVIEW.md` แล้วรัน install.sh ใหม่

### เพิ่ม tool ใหม่ใน OpenClaw
แก้ไข `for-openclaw/index.ts` เพิ่ม `api.registerTool({...})`

### เพิ่ม skill ใหม่ใน Antigravity
สร้าง `for-antigravity/.agent/skills/<skill-name>/SKILL.md`

## Commit Convention

```
<verb> <what>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```
