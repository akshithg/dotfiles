DOTFILES_REPO := git@github.com:akshithg/dotfiles.git
DOTFILES_DIR := $(HOME)/.dotfiles
BACKUP_DIR := $(HOME)/.config-backup
export DOTFILES_REPO DOTFILES_DIR BACKUP_DIR

# Scripts live next to the configs they install, so these relative paths resolve
# from this working copy and from $HOME alike.
SCRIPTS := .config/dotfiles

.PHONY: help clone install install-brew install-rust install-python install-node \
	install-macos install-macos-icloud install-linux test update uninstall

.DEFAULT_GOAL := help

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  clone                Bootstrap into \$$HOME (or pull latest if already set up)"
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
	./bootstrap.sh

install: install-brew install-rust install-python install-node
	@echo "All tools installed."

install-brew:
	$(SCRIPTS)/install-brew.sh

install-rust:
	$(SCRIPTS)/install-rust.sh

install-python:
	$(SCRIPTS)/install-python.sh

install-node:
	$(SCRIPTS)/install-node.sh

install-macos:
	.config/macos/defaults.sh

install-macos-icloud:
	.config/macos/setup-icloud.sh

install-linux:
	$(SCRIPTS)/install-linux.sh

test:
	./test/run.sh

update:
	$(SCRIPTS)/update.sh

uninstall:
	$(SCRIPTS)/uninstall.sh
