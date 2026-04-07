# Changelog

## v0.2.0 — 2026-04-07

### Added
- **AI tool choices** — Claude Code, GitHub Copilot CLI, Google Gemini CLI, OpenAI Codex CLI, and OpenCode are now selectable during first-run setup (any combination)
- **Text editor choices** — micro, edit (Microsoft), fresh, helix, and neovim selectable during setup
- **SDK choices** — Node.js (nvm), Python (uv), Go, and .NET selectable during setup
- **`sqrbx-update`** — in-container tool updater that checks GitHub releases and updates binaries in-place without rebuilding
- **`sqrbx-rebuild`** — host-side alias to pull, rebuild, and replace the container while preserving workspace and selections
- **gum** — interactive shell script toolkit (used for setup menus, also available to users)
- **Devcontainer / Codespaces support** via `.devcontainer/devcontainer.json`
- **SECURITY.md** — full trust model documentation covering verification strategy for every tool category
- **CONTRIBUTING.md** — build, test, and PR guidelines
- Persistent setup selections survive container rebuilds (stored in `/workspace/.squarebox/`)
- MOTD showing installed AI tools and SDKs on container start

### Changed
- First-run setup now uses gum TUI menus (with text fallback)
- Shell aliases inspired by Omarchy (`c`, `g`, `gcm`, `ff`, `eff`, etc.)
- Starship prompt customised with squarebox icon

### Fixed
- Helix install no longer shows false "not installed" warning
- Container permissions for `/workspace` on first run
- SDK paths sourced before MOTD so they appear immediately

## v0.1.0

Initial release. Ubuntu 24.04 base with bat, curl, delta, eza, fd, fzf, gh,
gh-dash, glow, jq, lazygit, nano, ripgrep, starship, xh, yazi, yq, zoxide.
All tools version-pinned and SHA256-verified. Persistent container model with
host volume mount.
