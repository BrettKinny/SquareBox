#!/usr/bin/env bash
set -euo pipefail

echo "=== TUI Devbox First-Run Setup ==="
echo

# Git identity
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
	read -rp "Git name: " name
	git config --global user.name "$name"
fi

if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
	read -rp "Git email: " email
	git config --global user.email "$email"
fi

# GitHub CLI
if ! gh auth status &>/dev/null; then
	echo
	echo "Logging into GitHub..."
	gh auth login
fi

# AI coding assistant
AI_CONFIG="/workspace/.devbox/ai-tool"
mkdir -p /workspace/.devbox ~/.local/bin

if [ -f "$AI_CONFIG" ]; then
	ai_choice=$(cat "$AI_CONFIG")
	echo "Installing AI tool: $ai_choice (from previous selection)"
else
	echo
	echo "Choose your AI coding assistant:"
	echo "  1) Claude Code"
	echo "  2) OpenCode"
	echo "  3) Both"
	read -rp "Selection [1/2/3]: " selection
	case "$selection" in
		1) ai_choice="claude" ;;
		2) ai_choice="opencode" ;;
		3) ai_choice="both" ;;
		*) echo "Invalid selection, defaulting to Claude Code"; ai_choice="claude" ;;
	esac
	echo "$ai_choice" > "$AI_CONFIG"
fi

if [ "$ai_choice" = "claude" ] || [ "$ai_choice" = "both" ]; then
	echo "Installing Claude Code..."
	curl -fsSL https://claude.ai/install.sh | bash
fi

if [ "$ai_choice" = "opencode" ] || [ "$ai_choice" = "both" ]; then
	echo "Installing OpenCode..."
	ARCH=$(uname -m)
	if [ "$ARCH" = "aarch64" ]; then OCARCH="arm64"; else OCARCH="x64"; fi
	curl -fsSL "https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-${OCARCH}.tar.gz" | tar xz -C /tmp
	find /tmp -name 'opencode' -type f -executable -exec mv {} ~/.local/bin/opencode \;
fi

# Set aliases based on selection
{
	if [ "$ai_choice" = "claude" ]; then
		echo "alias c='claude'"
		echo "alias claude-yolo='claude --dangerously-skip-permissions'"
	elif [ "$ai_choice" = "opencode" ]; then
		echo "alias c='opencode'"
		echo "alias opencode-yolo='opencode --dangerously-skip-permissions'"
	else
		echo "alias claude-yolo='claude --dangerously-skip-permissions'"
		echo "alias opencode-yolo='opencode --dangerously-skip-permissions'"
	fi
} > ~/.devbox-ai-aliases

echo
echo "Done. Ready to go."
