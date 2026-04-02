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
  echo "  tool        — AI tool ที่ใช้: claude-code | opencode | chatgpt-codex (default: claude-code)"
  echo ""
  echo "Examples:"
  echo "  $0                              # ติดตั้ง Claude Code ใน current dir"
  echo "  $0 /path/to/project opencode    # ติดตั้ง OpenCode ใน project dir"
  echo "  $0 . chatgpt-codex              # ติดตั้ง ChatGPT Codex ใน current dir"
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

  *)
    echo "❌ Unknown tool: $TOOL"
    echo "   Supported: claude-code | opencode | chatgpt-codex"
    usage
    exit 1
    ;;
esac

echo ""
echo "📌 Make sure MCP server is running at http://localhost:8000/mcp/"
echo "   See: https://github.com/monthop-gmail/odoo-mcp-claude"
