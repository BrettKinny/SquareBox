#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/SquareWaveSystems/squarebox.git"

# On Windows/mintty (Git Bash), docker needs winpty for interactive TTY
# passthrough. mintty uses named pipes instead of the Windows Console API,
# which breaks interactive docker commands. winpty bridges the gap.
# PowerShell and CMD work natively — this only activates in MSYS2/mintty.
docker_interactive() {
    if [[ -n "${MSYSTEM:-}" || "${TERM_PROGRAM:-}" == "mintty" ]] \
        && command -v winpty &>/dev/null; then
        winpty docker "$@"
    else
        docker "$@"
    fi
}

INSTALL_DIR="${HOME}/squarebox"
IMAGE_NAME="squarebox"
CONTAINER_NAME="squarebox"

# Clone or update
if [ -d "$INSTALL_DIR" ]; then
	echo "Updating existing install..."
	git -C "$INSTALL_DIR" pull --ff-only
else
	echo "Cloning squarebox..."
	git clone "$REPO" "$INSTALL_DIR"
fi

# Verify Docker is available
if ! command -v docker &>/dev/null; then
	echo "Error: Docker is not installed. See https://docs.docker.com/get-docker/" >&2
	exit 1
fi
if ! docker info &>/dev/null; then
	echo "Error: Docker daemon is not running or current user lacks permissions." >&2
	exit 1
fi

# Build
echo "Building image..."
docker build -t "$IMAGE_NAME" "$INSTALL_DIR"

# Remove old container if it exists
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
	echo "Removing old container..."
	docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
	docker rm "$CONTAINER_NAME" >/dev/null
fi

# Add shell aliases
case "${SHELL:-}" in
	*/zsh) SHELL_RC="${HOME}/.zshrc" ;;
	*)     SHELL_RC="${HOME}/.bashrc" ;;
esac

# Determine docker start command (winpty needed on mintty/MSYS2)
if [[ -n "${MSYSTEM:-}" || "${TERM_PROGRAM:-}" == "mintty" ]] \
    && command -v winpty &>/dev/null; then
	DOCKER_START="winpty docker start -ai squarebox"
else
	DOCKER_START="docker start -ai squarebox"
fi

ALIASES_ADDED=false

if ! grep -q 'alias sqrbx=' "$SHELL_RC" 2>/dev/null; then
	echo "alias sqrbx='${DOCKER_START}'" >> "$SHELL_RC"
	ALIASES_ADDED=true
fi

if ! grep -q 'alias squarebox=' "$SHELL_RC" 2>/dev/null; then
	echo "alias squarebox='${DOCKER_START}'" >> "$SHELL_RC"
	ALIASES_ADDED=true
fi

if ! grep -q 'alias sqrbx-rebuild=' "$SHELL_RC" 2>/dev/null; then
	echo "alias sqrbx-rebuild='~/squarebox/install.sh'" >> "$SHELL_RC"
	ALIASES_ADDED=true
fi

if ! grep -q 'alias squarebox-rebuild=' "$SHELL_RC" 2>/dev/null; then
	echo "alias squarebox-rebuild='~/squarebox/install.sh'" >> "$SHELL_RC"
	ALIASES_ADDED=true
fi

if [ "$ALIASES_ADDED" = true ]; then
	echo "Added squarebox aliases to $SHELL_RC — restart your shell or run: source $SHELL_RC"
fi

# Prepare host directories
mkdir -p "${HOME}/.config/git" "${INSTALL_DIR}/workspace" "${INSTALL_DIR}/.config/lazygit"

# Propagate host git identity into the container's config directory.
# This avoids fragile file mounts on Windows/MSYS2 and prevents leaking
# credential helpers or tokens from the host's full git config.
_git_cfg="${HOME}/.config/git/config"
_host_name="$(git config --global user.name 2>/dev/null || true)"
_host_email="$(git config --global user.email 2>/dev/null || true)"
[ -n "$_host_name" ] && git config --file "$_git_cfg" user.name "$_host_name"
[ -n "$_host_email" ] && git config --file "$_git_cfg" user.email "$_host_email"

# Debug: show git identity propagation and environment state
echo "[debug] HOME=${HOME}"
echo "[debug] SHELL=${SHELL:-unset} MSYSTEM=${MSYSTEM:-unset} TERM_PROGRAM=${TERM_PROGRAM:-unset}"
echo "[debug] host git user.name: '${_host_name}'"
echo "[debug] host git user.email: '${_host_email}'"
echo "[debug] git config files: $(git config --global --list --show-origin 2>/dev/null | head -5 || echo 'none found')"
echo "[debug] ~/.gitconfig exists: $([ -f "${HOME}/.gitconfig" ] && echo yes || echo no)"
echo "[debug] ~/.config/git/config exists: $([ -f "$_git_cfg" ] && echo yes || echo no)"
[ -f "$_git_cfg" ] && echo "[debug] ~/.config/git/config contents:" && cat "$_git_cfg"

# Migrate from old layout if needed
if [ -d "${HOME}/squarebox-workspace" ] && [ ! -d "${INSTALL_DIR}/workspace" ]; then
	echo "Migrating ~/squarebox-workspace to ~/squarebox/workspace..."
	mv "${HOME}/squarebox-workspace" "${INSTALL_DIR}/workspace"
fi

# Seed default configs (preserves existing customizations)
if [ ! -f "${INSTALL_DIR}/.config/starship.toml" ]; then
	cp "${INSTALL_DIR}/starship.toml" "${INSTALL_DIR}/.config/starship.toml"
fi
if [ ! -f "${INSTALL_DIR}/.config/lazygit/config.yml" ]; then
	printf 'git:\n  paging:\n    colorArg: always\n    pager: delta --dark --paging=never\n' > "${INSTALL_DIR}/.config/lazygit/config.yml"
fi

echo "Creating container..."
DOCKER_VOLUMES=(
	-v "${INSTALL_DIR}/workspace:/workspace"
	-v "${HOME}/.ssh:/home/dev/.ssh:ro"
	-v "${HOME}/.config/git:/home/dev/.config/git"
	-v "${INSTALL_DIR}/.config/starship.toml:/home/dev/.config/starship.toml"
	-v "${INSTALL_DIR}/.config/lazygit:/home/dev/.config/lazygit"
	-v /etc/localtime:/etc/localtime:ro
)

docker create -it --name "$CONTAINER_NAME" \
	"${DOCKER_VOLUMES[@]}" \
	"$IMAGE_NAME" > /dev/null

# Debug: TTY state
echo "[debug] stdin is terminal: $([ -t 0 ] && echo yes || echo no)"
echo "[debug] stdout is terminal: $([ -t 1 ] && echo yes || echo no)"
echo "[debug] /dev/tty exists: $([ -e /dev/tty ] && echo yes || echo no)"
echo "[debug] DOCKER_START='${DOCKER_START}'"

if [ -t 0 ]; then
	echo "[debug] taking branch: stdin is terminal"
	docker_interactive start -ai "$CONTAINER_NAME"
elif [ -t 1 ] && [ -e /dev/tty ]; then
	echo "[debug] taking branch: stdin piped, using /dev/tty"
	docker_interactive start -ai "$CONTAINER_NAME" </dev/tty
else
	echo "[debug] taking branch: non-interactive"
	echo "Install complete. Run 'squarebox' (or 'sqrbx') to start (you may need to restart your shell first)."
fi
