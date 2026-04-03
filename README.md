# lawform-ai-plugin

AI plugin สำหรับระบบ **lawform** (Odoo Thai court forms)
รองรับหลาย AI tools ด้วย installer เดียว

---

## ภาพรวม

Plugin นี้ให้ AI ทำงานในระบบ lawform ได้ 2 บทบาท:

| บทบาท | คำอธิบาย |
|-------|---------|
| **AI ทนาย** (`/lawyer`) | รับเรื่องลูกความ → สร้างคดี → เตรียมเอกสารศาลครบชุด |
| **AI ผู้ตรวจ** (`/review`) | ตรวจสำนวนคดี 6 หัวข้อ → รายงานสิ่งที่ขาด/ต้องแก้ |

การสื่อสารกับ Odoo ผ่าน **MCP server** (`odoo-mcp-claude`) โดยตรง

---

## AI Tools ที่รองรับ

| Tool | โฟลเดอร์ | ประเภทไฟล์ |
|------|---------|-----------|
| Claude Code | `for-claude-code/` | `.claude/commands/` + `.mcp.json` |
| OpenCode | `for-opencode/` | `AGENTS.md` + `opencode.json` |
| ChatGPT Codex | `for-chatgpt-codex/` | `AGENTS.md` |
| Codex App Server | `for-codex-appserver/` | `AGENTS.md` |
| Gemini CLI | `for-gemini-cli/` | `GEMINI.md` |
| Google Antigravity | `for-antigravity/` | `GEMINI.md` + skills |
| Google ADK | `for-google-adk/` | Python agent (`agent.py`) |
| gocode | `for-gocode/` | `AGENTS.md` |
| adkcode | `for-adkcode/` | plugin (skills + commands + `.mcp.json`) |
| GitHub Copilot CLI | `for-copilot-cli/` | `AGENTS.md` |
| Qwen Code | `for-qwen-code/` | `AGENTS.md` |
| OpenClaw | `for-openclaw/` | TypeScript npm plugin |

---

## ติดตั้ง MCP Server

ก่อนใช้ plugin ต้องมี MCP server ทำงานอยู่:

```bash
git clone https://github.com/monthop-gmail/odoo-mcp-claude.git
cd odoo-mcp-claude
cp env.example .env
# แก้ไข .env ใส่ข้อมูล Odoo
./start-mcp.sh
# MCP endpoint: http://localhost:8000/mcp/
```

---

## วิธีติดตั้ง

### วิธีที่ 1: ใช้ install.sh (แนะนำ)

```bash
# Claude Code (default)
./install.sh /path/to/your-odoo-project

# ระบุ tool
./install.sh /path/to/project opencode
./install.sh /path/to/project chatgpt-codex
./install.sh /path/to/project codex-appserver
./install.sh /path/to/project gemini-cli
./install.sh /path/to/project antigravity
./install.sh /path/to/project gocode
./install.sh /path/to/project copilot-cli
./install.sh /path/to/project qwen-code

# ติดตั้งต่างออกไป
./install.sh . openclaw      # npm plugin
./install.sh . google-adk    # Python package
./install.sh . adkcode       # copy plugin directory
```

### วิธีที่ 2: Copy manual

ดูคำแนะนำใน README ของแต่ละโฟลเดอร์ (`for-xxx/README.md`)

---

## โครงสร้าง

```
lawform-ai-plugin/
  agents/
    LAWYER.md          — คู่มือ AI ทนาย (tool-agnostic)
    REVIEW.md          — คู่มือ AI ผู้ตรวจ (tool-agnostic)
  for-claude-code/     — Claude Code
  for-opencode/        — OpenCode
  for-chatgpt-codex/   — ChatGPT Codex / OpenAI Codex CLI
  for-codex-appserver/ — OpenAI Codex App Server
  for-gemini-cli/      — Gemini CLI
  for-antigravity/     — Google Antigravity
  for-google-adk/      — Google ADK (Python agent)
  for-gocode/          — gocode
  for-adkcode/         — adkcode (plugin system)
  for-copilot-cli/     — GitHub Copilot CLI
  for-qwen-code/       — Qwen Code
  for-openclaw/        — OpenClaw (TypeScript npm plugin)
  install.sh           — one-command installer
```

---

## ความต้องการ

- Odoo 19.0 (หรือ 18.0) พร้อมติดตั้ง module `legal_forms`
- MCP server `odoo-mcp-claude` ทำงานที่ `http://localhost:8000/mcp/`
