DOTFILES_REPO := git@github.com:akshithg/dotfiles.git
DOTFILES_DIR := $(HOME)/.dotfiles
BACKUP_DIR := $(HOME)/.config-backup

define dotgit
	git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME)
endef

.PHONY: help clone install install-brew install-rust install-python install-node install-macos install-macos-icloud install-linux test update uninstall

.DEFAULT_GOAL := help

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  clone                Clone bare repo, checkout, install TPM"
	@echo "  install              Run all install-* targets"
	@echo "  install-brew         Homebrew + CLI tools"
	@echo "  install-rust         Rustup + cargo tools"
	@echo "  install-python       uv + ruff, ty, pip-audit"
	@echo "  install-node         fnm (Homebrew) + Node 22 + pnpm"
	@echo "  install-macos        Apply macOS defaults"
	@echo "  install-macos-icloud Link Documents to iCloud"
	@echo "  install-linux        CLI tools via apt/dnf/pacman (Linux)"
	@echo "  test                 Build + validate dotfiles in Ubuntu/Debian containers"
	@echo "  update               Upgrade all tools"
	@echo "  uninstall            Remove dotfiles and restore backups"

clone:
	git clone --bare $(DOTFILES_REPO) $(DOTFILES_DIR)
	mkdir -p $(HOME)/.config $(HOME)/.local/share $(HOME)/.cache $(HOME)/.local/state
	mkdir -p $(BACKUP_DIR)
	$(dotgit) checkout 2>&1 \
		| grep -E "^\s" | awk '{print $$1}' \
		| while read -r f; do \
			mkdir -p "$(BACKUP_DIR)/$$(dirname "$$f")"; \
			mv "$(HOME)/$$f" "$(BACKUP_DIR)/$$f"; \
		done

	$(dotgit) checkout
	$(dotgit) config --local status.showUntrackedFiles no
	git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm 2>/dev/null || true
	@echo "Done. Restart your shell."

install: install-brew install-rust install-python install-node
	@echo "All tools installed."

install-brew:
	@command -v brew >/dev/null || \
		/bin/bash -c "$$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	/opt/homebrew/bin/brew update
	/opt/homebrew/bin/brew install \
		git \
		git-delta \
		\
		neovim \
		\
		bat \
		dust \
		eza \
		fd \
		fzf \
		jq \
		procs \
		ripgrep \
		vivid \
		zoxide \
		\
		btop \
		lazydocker \
		lazygit \
		yazi \
		\
		actionlint \
		shellcheck \
		shfmt \
		zizmor \
		ast-grep \
		\
		tldr \
		gum \
		\
		colima \
		docker \
		macos-trash

install-rust:
	@command -v rustup >/dev/null || \
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	rustup update || rustup install stable
	cargo install prek worktrunk cargo-deny cargo-careful

install-python:
	@command -v uv >/dev/null || \
		curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh
	uv tool install ruff
	uv tool install ty
	uv tool install pip-audit

install-node:
	@command -v fnm >/dev/null || /opt/homebrew/bin/brew install fnm || true
	@zsh -c 'eval "$$(fnm env)" && fnm install 22 && fnm default 22 && npm install -g pnpm'

install-macos:
	@if [[ "$$(uname -s)" != "Darwin" ]]; then \
		echo "Error: Not macOS"; \
		exit 1; \
	fi
	zsh .config/macos/defaults.sh

install-macos-icloud:
	@if [[ "$$(uname -s)" != "Darwin" ]]; then \
		echo "Error: Not macOS"; \
		exit 1; \
	fi
	zsh .config/macos/setup-icloud.sh

install-linux:
	@if [ "$$(uname -s)" != "Linux" ]; then \
		echo "Error: Not Linux"; exit 1; \
	fi
	@if command -v apt-get >/dev/null; then \
		sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
			zsh git curl ca-certificates \
			neovim tmux \
			ripgrep fd-find fzf bat eza zoxide \
			jq shellcheck btop; \
		[ -e /usr/bin/fdfind ] && [ ! -e /usr/local/bin/fd ] && sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd; \
		[ -e /usr/bin/batcat ] && [ ! -e /usr/local/bin/bat ] && sudo ln -sf /usr/bin/batcat /usr/local/bin/bat; \
	elif command -v dnf >/dev/null; then \
		sudo dnf install -y \
			zsh git curl ca-certificates \
			neovim tmux \
			ripgrep fd-find fzf bat eza zoxide \
			jq ShellCheck lazygit btop; \
	elif command -v pacman >/dev/null; then \
		sudo pacman -Sy --noconfirm --needed \
			zsh git curl ca-certificates \
			neovim tmux \
			ripgrep fd fzf bat eza zoxide \
			jq shellcheck starship git-delta \
			yazi lazygit lazydocker btop; \
	else \
		echo "Error: no supported package manager (apt/dnf/pacman) found"; exit 1; \
	fi
	@command -v starship >/dev/null || curl -fsSL https://starship.rs/install.sh | sh -s -- -y
	@command -v delta >/dev/null || echo "Note: install git-delta separately (not in apt repos)"

test:
	./test/run.sh

update:
	/opt/homebrew/bin/brew update && /opt/homebrew/bin/brew upgrade
	rustup update
	cargo install prek worktrunk cargo-deny cargo-careful
	uv tool upgrade --all
	@command -v pnpm >/dev/null && pnpm update -g || true
	@echo "All tools updated."

uninstall:
	@echo "This will remove dotfiles and restore backups."
	@echo "Press Ctrl-C to abort, Enter to continue." && read _
	$(dotgit) checkout 2>/dev/null | true
	$(dotgit) ls-tree -r HEAD --name-only | xargs -I{} rm -f "$(HOME)/{}"
	rm -rf $(DOTFILES_DIR)
	@if [ -d "$(BACKUP_DIR)" ]; then \
		echo "Restoring backups from $(BACKUP_DIR)..."; \
		cp -r $(BACKUP_DIR)/. $(HOME)/; \
		echo "Backups restored. You can remove $(BACKUP_DIR) manually."; \
	fi
	@echo "Dotfiles removed. Restart your shell."
