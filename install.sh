#!/bin/bash
# lawform-ai-plugin installer
# ติดตั้ง AI plugin สำหรับ lawform ลงใน project directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"
TOOL="${2:-claude-code}"

usage() {
  echo "Usage: $0 [target-dir] [tool]"
  echo ""
  echo "  target-dir  — โฟลเดอร์ที่ต้องการติดตั้ง (default: current directory)"
  echo "  tool        — AI tool ที่ใช้: claude-code | opencode | chatgpt-codex | codex-appserver | gemini-cli | antigravity | openclaw | google-adk | gocode | adkcode | copilot-cli | qwen-code (default: claude-code)"
  echo ""
  echo "Examples:"
  echo "  $0                              # ติดตั้ง Claude Code ใน current dir"
  echo "  $0 /path/to/project opencode    # ติดตั้ง OpenCode ใน project dir"
  echo "  $0 . chatgpt-codex              # ติดตั้ง ChatGPT Codex ใน current dir"
  echo "  $0 . codex-appserver            # ติดตั้ง Codex App Server ใน current dir"
  echo "  $0 . gemini-cli                 # ติดตั้ง Gemini CLI ใน current dir"
  echo "  $0 . antigravity                # ติดตั้ง Google Antigravity ใน current dir"
  echo "  $0 . openclaw                   # แสดงวิธีติดตั้ง OpenClaw plugin"
  echo "  $0 . google-adk                 # แสดงวิธีติดตั้ง Google ADK agent"
  echo "  $0 . gocode                     # ติดตั้ง gocode ใน project dir"
  echo "  $0 . adkcode                    # แสดงวิธีติดตั้ง adkcode plugin"
  echo "  $0 . copilot-cli                # ติดตั้ง GitHub Copilot CLI ใน project dir"
  echo "  $0 . qwen-code                  # ติดตั้ง Qwen Code ใน project dir"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

echo "=== lawform-ai-plugin installer ==="
echo "Target: $TARGET"
echo "Tool:   $TOOL"
echo ""

# Copy core agent docs (shared across all tools)
echo "📄 Copying agent docs..."
cp "$SCRIPT_DIR/agents/LAWYER.md" "$TARGET/agent-LAWYER.md"
cp "$SCRIPT_DIR/agents/REVIEW.md" "$TARGET/agent-REVIEW.md"
echo "   ✓ agent-LAWYER.md"
echo "   ✓ agent-REVIEW.md"

case "$TOOL" in
  claude-code)
    echo "🤖 Installing for Claude Code..."
    mkdir -p "$TARGET/.claude/commands"
    cp "$SCRIPT_DIR/for-claude-code/.claude/commands/lawyer.md" "$TARGET/.claude/commands/lawyer.md"
    cp "$SCRIPT_DIR/for-claude-code/.claude/commands/review.md" "$TARGET/.claude/commands/review.md"
    if [[ ! -f "$TARGET/.mcp.json" ]]; then
      cp "$SCRIPT_DIR/for-claude-code/.mcp.json" "$TARGET/.mcp.json"
      echo "   ✓ .mcp.json (created)"
    else
      echo "   ⚠ .mcp.json already exists — skipped (merge manually if needed)"
    fi
    echo "   ✓ .claude/commands/lawyer.md"
    echo "   ✓ .claude/commands/review.md"
    echo ""
    echo "✅ Done! Use /lawyer or /review in Claude Code."
    ;;

  opencode)
    echo "🤖 Installing for OpenCode..."
    if [[ ! -f "$TARGET/opencode.json" ]]; then
      cp "$SCRIPT_DIR/for-opencode/opencode.json" "$TARGET/opencode.json"
      echo "   ✓ opencode.json (created)"
    else
      echo "   ⚠ opencode.json already exists — skipped (merge manually if needed)"
    fi
    cp "$SCRIPT_DIR/for-opencode/AGENTS.md" "$TARGET/AGENTS.md"
    echo "   ✓ AGENTS.md"
    echo ""
    echo "✅ Done! Tell OpenCode: 'ทำหน้าที่ AI ทนาย' or 'ตรวจสำนวนคดี X'"
    ;;

  chatgpt-codex)
    echo "🤖 Installing for ChatGPT Codex..."
    cp "$SCRIPT_DIR/for-chatgpt-codex/AGENTS.md" "$TARGET/AGENTS.md"
    echo "   ✓ AGENTS.md"
    echo ""
    echo "✅ Done! Codex will read AGENTS.md automatically."
    ;;

  codex-appserver)
    echo "🤖 Installing for Codex App Server..."
    cp "$SCRIPT_DIR/for-codex-appserver/AGENTS.md" "$TARGET/AGENTS.md"
    echo "   ✓ AGENTS.md"
    echo ""
    echo "✅ Done! Codex App Server will read AGENTS.md automatically."
    ;;

  copilot-cli)
    echo "🤖 Installing for GitHub Copilot CLI..."
    cp "$SCRIPT_DIR/for-copilot-cli/AGENTS.md" "$TARGET/AGENTS.md"
    echo "   ✓ AGENTS.md"
    echo ""
    echo "✅ Done! GitHub Copilot CLI will read AGENTS.md automatically."
    ;;

  qwen-code)
    echo "🤖 Installing for Qwen Code..."
    cp "$SCRIPT_DIR/for-qwen-code/AGENTS.md" "$TARGET/AGENTS.md"
    echo "   ✓ AGENTS.md"
    echo ""
    echo "✅ Done! Qwen Code will read AGENTS.md automatically."
    ;;

  gemini-cli)
    echo "🤖 Installing for Gemini CLI..."
    cp "$SCRIPT_DIR/for-gemini-cli/GEMINI.md" "$TARGET/GEMINI.md"
    echo "   ✓ GEMINI.md"
    echo ""
    echo "✅ Done! Gemini CLI will read GEMINI.md automatically."
    ;;

  antigravity)
    echo "🤖 Installing for Google Antigravity..."
    cp "$SCRIPT_DIR/for-antigravity/GEMINI.md" "$TARGET/GEMINI.md"
    mkdir -p "$TARGET/.agent/skills/lawform-lawyer"
    mkdir -p "$TARGET/.agent/skills/lawform-review"
    cp "$SCRIPT_DIR/for-antigravity/.agent/skills/lawform-lawyer/SKILL.md" "$TARGET/.agent/skills/lawform-lawyer/SKILL.md"
    cp "$SCRIPT_DIR/for-antigravity/.agent/skills/lawform-review/SKILL.md" "$TARGET/.agent/skills/lawform-review/SKILL.md"
    echo "   ✓ GEMINI.md"
    echo "   ✓ .agent/skills/lawform-lawyer/SKILL.md"
    echo "   ✓ .agent/skills/lawform-review/SKILL.md"
    echo ""
    echo "✅ Done! Use 'lawform-lawyer' or 'lawform-review' skill in Antigravity."
    ;;

  openclaw)
    echo "🦞 OpenClaw plugin (@lawform/openclaw-plugin)"
    echo ""
    echo "   OpenClaw plugin is a TypeScript npm package — install via OpenClaw CLI:"
    echo ""
    echo "   openclaw plugins install @lawform/openclaw-plugin"
    echo ""
    echo "   Or install from local path:"
    echo "   openclaw plugins install $SCRIPT_DIR/for-openclaw"
    echo ""
    echo "   Then configure:"
    echo "   openclaw config set lawform-legal.mcpUrl http://localhost:8000/mcp/"
    echo "   openclaw config set lawform-legal.odooUrl http://localhost:8069"
    echo "   openclaw config set lawform-legal.database lawform"
    echo ""
    echo "✅ See for-openclaw/README.md for full details."
    exit 0
    ;;

  gocode)
    echo "🐹 Installing for gocode..."
    cp "$SCRIPT_DIR/for-gocode/AGENTS.md" "$TARGET/AGENTS.md"
    echo "   ✓ AGENTS.md"
    echo ""
    echo "✅ Done! gocode will read AGENTS.md automatically."
    echo "   Tell gocode: 'ทำหน้าที่ AI ทนาย' or 'ตรวจสำนวนคดี X'"
    ;;

  adkcode)
    echo "🐍 adkcode plugin (lawform)"
    echo ""
    echo "   Copy the plugin directory to adkcode's plugins folder:"
    echo ""
    echo "   cp -r $SCRIPT_DIR/for-adkcode <adkcode-dir>/plugins/lawform"
    echo ""
    echo "   Or if running via Docker, mount it:"
    echo "   volumes:"
    echo "     - $SCRIPT_DIR/for-adkcode:/app/plugins/lawform"
    echo ""
    echo "   Then also copy agent docs to your project:"
    echo "   cp $SCRIPT_DIR/agents/LAWYER.md <project>/agent-LAWYER.md"
    echo "   cp $SCRIPT_DIR/agents/REVIEW.md  <project>/agent-REVIEW.md"
    echo ""
    echo "   Use /lawyer or /review commands, or describe a case directly."
    echo ""
    echo "✅ See for-adkcode/.claude-plugin/plugin.json for plugin metadata."
    exit 0
    ;;

  google-adk)
    echo "🐍 Google ADK agent (Python)"
    echo ""
    echo "   Google ADK agent is a Python package — set it up directly:"
    echo ""
    echo "   cd $SCRIPT_DIR/for-google-adk"
    echo "   pip install -e ."
    echo "   cp lawform_agent/.env.example lawform_agent/.env"
    echo "   # แก้ไข .env ใส่ GOOGLE_API_KEY"
    echo ""
    echo "   # รัน:"
    echo "   adk web          # Dev UI (browser)"
    echo "   adk run lawform_agent    # Terminal"
    echo ""
    echo "✅ See for-google-adk/README.md for full details."
    exit 0
    ;;

  *)
    echo "❌ Unknown tool: $TOOL"
    echo "   Supported: claude-code | opencode | chatgpt-codex | codex-appserver | gemini-cli | antigravity | openclaw | google-adk | gocode | adkcode | copilot-cli | qwen-code"
    usage
    exit 1
    ;;
esac

echo ""
echo "📌 Make sure MCP server is running at http://localhost:8000/mcp/"
echo "   See: https://github.com/monthop-gmail/odoo-mcp-claude"
