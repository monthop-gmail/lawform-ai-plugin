# lawform-ai-plugin

AI plugin สำหรับระบบ **lawform** (Odoo Thai court forms)
รองรับหลาย AI tools: Claude Code, OpenCode, ChatGPT Codex

---

## ภาพรวม

Plugin นี้ให้ AI ทำงานในระบบ lawform ได้ 2 บทบาท:

| บทบาท | คำอธิบาย |
|-------|---------|
| **AI ทนาย** (`/lawyer`) | รับเรื่องลูกความ → สร้างคดี → เตรียมเอกสารศาลครบชุด |
| **AI ผู้ตรวจ** (`/review`) | ตรวจสำนวนคดี 6 หัวข้อ → รายงานสิ่งที่ขาด/ต้องแก้ |

การสื่อสารกับ Odoo ผ่าน **MCP server** (`odoo-mcp-claude`) โดยตรง

---

## โครงสร้าง

```
lawform-ai-plugin/
  agents/
    LAWYER.md          — คู่มือ AI ทนาย (tool-agnostic)
    REVIEW.md          — คู่มือ AI ผู้ตรวจ (tool-agnostic)
  for-claude-code/     — สำหรับ Claude Code
  for-opencode/        — สำหรับ OpenCode
  for-chatgpt-codex/   — สำหรับ ChatGPT Codex / OpenAI Codex
  for-gemini-cli/      — สำหรับ Gemini CLI
  for-antigravity/     — สำหรับ Google Antigravity
  for-openclaw/        — สำหรับ OpenClaw (TypeScript npm plugin)
```

---

## ติดตั้ง MCP Server

ก่อนใช้ plugin ต้องมี MCP server ทำงานอยู่:

```bash
# clone
git clone https://github.com/monthop-gmail/odoo-mcp-claude.git
cd odoo-mcp-claude

# ตั้งค่า
cp env.example .env
# แก้ไข .env ใส่ข้อมูล Odoo

# รัน
./start-mcp.sh
# MCP endpoint: http://localhost:8000/mcp/
```

---

## วิธีติดตั้งตาม AI Tool

### Claude Code

```bash
cd /path/to/your-odoo-project
cp -r lawform-ai-plugin/for-claude-code/.claude .
cp lawform-ai-plugin/for-claude-code/.mcp.json .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

ใช้งาน: `/lawyer` หรือ `/review` ใน Claude Code

### OpenCode

```bash
cd /path/to/your-odoo-project
cp lawform-ai-plugin/for-opencode/opencode.json .
cp lawform-ai-plugin/for-opencode/AGENTS.md .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

ใช้งาน: บอก AI ว่า "ทำหน้าที่ทนาย" หรือ "ตรวจสำนวนคดี X"

### ChatGPT Codex

```bash
cd /path/to/your-odoo-project
cp lawform-ai-plugin/for-chatgpt-codex/AGENTS.md .
cp lawform-ai-plugin/agents/LAWYER.md agent-LAWYER.md
cp lawform-ai-plugin/agents/REVIEW.md agent-REVIEW.md
```

ใช้งาน: บอก AI บทบาทที่ต้องการในแต่ละ session

---

### Gemini CLI

```bash
cd /path/to/your-odoo-project
cp for-gemini-cli/GEMINI.md .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

ใช้งาน: บอก AI ว่า "ทำหน้าที่ AI ทนาย" หรือ "ตรวจสำนวนคดี X"

### OpenClaw

```bash
# ติดตั้ง plugin
openclaw plugins install @lawform/openclaw-plugin

# ตั้งค่า MCP URL
openclaw config set lawform-legal.mcpUrl http://localhost:8000/mcp/
```

ใช้งาน: บอก OpenClaw ว่า "ทำหน้าที่ทนาย..." หรือ "ตรวจสำนวนคดี X"

Plugin ลงทะเบียน tools: `lawform_start_lawyer_mode`, `lawform_search_cases`, `lawform_create_case`, `lawform_create_document`, `lawform_apply_merge`, `lawform_review_case`

### Google Antigravity

```bash
cd /path/to/your-odoo-project
cp for-antigravity/GEMINI.md .
cp -r for-antigravity/.agent .
cp agents/LAWYER.md agent-LAWYER.md
cp agents/REVIEW.md agent-REVIEW.md
```

ใช้งาน: Antigravity จะโหลด skill `lawform-lawyer` และ `lawform-review` โดยอัตโนมัติ

---

## ความต้องการ

- Odoo 19.0 (หรือ 18.0) พร้อมติดตั้ง module `legal_forms`
- MCP server `odoo-mcp-claude` ทำงานที่ `http://localhost:8000/mcp/`
- AI tool ที่รองรับ MCP (Claude Code, OpenCode) หรือ function calling (ChatGPT)
