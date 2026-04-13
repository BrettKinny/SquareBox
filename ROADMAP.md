# Roadmap

## Planned

Items are listed in priority order.

- **direnv** — add [direnv](https://github.com/direnv/direnv) (automatic per-directory environment loading) to the default image; auto-loads `.envrc` files on `cd`, integrates with zoxide for seamless per-project environment variables
- **Dotfile portability** — let users mount or bootstrap their own dotfiles (starship.toml, tmux.conf, aliases, etc.) via a `~/.squarebox/` convention, with sensible merge/override behaviour against the defaults
- **MCP server pre-configuration** — ship ready-made MCP server configs (filesystem, GitHub, etc.) as part of the AI assistant setup step
- **hyperfine** — add [hyperfine](https://github.com/sharkdp/hyperfine) (command-line benchmarking) to the default image
- **Atuin (searchable shell history)** — replace basic bash history with full-text search, sync, and stats across sessions
- **Host theme transparency** — configure tools (fzf, eza, starship, tmux) to use ANSI colour references so they inherit the host terminal's theme automatically; provide sensible defaults for tools with their own named themes (bat, delta) with easy overrides
- **Per-project container profiles** — save and load named profiles (e.g. `sqrbx start --profile python-ml`) that pre-select SDKs, editors, and AI tools without re-running the wizard
- **Neovim defaults from omarchy** — bring across the neovim configuration defaults from omarchy so nvim works well out of the box
- **Task completion notifications** — webhook, terminal bell, or desktop notification when long-running AI tasks finish
- **Network firewall / sandboxing mode** — optional network-level isolation (iptables/seccomp) so AI agents can only reach approved endpoints, inspired by trailofbits and clampdown
- **Multiple concurrent container instances** — support running more than one squarebox container simultaneously
- **Multi-agent workflow orchestration** — explore adding a layer to run multiple AI coding agents simultaneously in isolated contexts (git worktrees + tmux sessions), inspired by agent-of-empires; may be better to integrate an existing tool than build from scratch
- ~~**just**~~ — ✅ done: [just](https://github.com/casey/just) pinned in the Dockerfile tier with SHA256 checksums
- ~~**difftastic**~~ — ✅ done: [difftastic](https://github.com/Wilfred/difftastic) (`difft`) pinned in the Dockerfile tier with SHA256 checksums
- ~~**Podman compatibility**~~ — ✅ done: install scripts auto-detect Docker or Podman and skip UID chown logic for Podman's rootless user namespace mapping
- ~~**Zsh option**~~ — ✅ done (experimental): `setup.sh` now offers Zsh with Oh My Zsh, autosuggestions, and syntax highlighting as a selectable shell alongside the Bash default; opt in via the new `shell` setup section
