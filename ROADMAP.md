# Roadmap

## Planned

Items are listed in priority order.

- **just** — add [just](https://github.com/casey/just) (modern task runner) to the default image; single binary, zero dependencies, gives users a standard way to define project commands
- **lazydocker** — add [lazydocker](https://github.com/jesseduffield/lazydocker) (Docker management TUI) to the default image; same author as lazygit, completes the TUI tool suite for developers managing containers
- **difftastic** — add [difftastic](https://github.com/Wilfred/difftastic) (syntax-aware structural diffs) to the default image; complements delta with language-aware diffing
- **btop** — add [btop](https://github.com/aristocratos/btop) (system resource monitor TUI) to the default image; fills the "what's eating my CPU/memory" gap without requiring manual package installation
- **direnv** — add [direnv](https://github.com/direnv/direnv) (automatic per-directory environment loading) to the default image; auto-loads `.envrc` files on `cd`, integrates with zoxide for seamless per-project environment variables
- **Zsh option** — offer Zsh with Oh My Zsh, autosuggestions, and syntax highlighting as a selectable shell in `setup.sh` alongside the Bash default; closes the biggest UX gap vs. competing dev environments
- **Dotfile portability** — let users mount or bootstrap their own dotfiles (starship.toml, tmux.conf, aliases, etc.) via a `~/.squarebox/` convention, with sensible merge/override behaviour against the defaults
- **hyperfine** — add [hyperfine](https://github.com/sharkdp/hyperfine) (command-line benchmarking) to the default image
- **Host theme transparency** — configure tools (fzf, eza, starship, tmux) to use ANSI colour references so they inherit the host terminal's theme automatically; provide sensible defaults for tools with their own named themes (bat, delta) with easy overrides
- **Neovim defaults from omarchy** — bring across the neovim configuration defaults from omarchy so nvim works well out of the box
- **Multiple concurrent container instances** — support running more than one squarebox container simultaneously
