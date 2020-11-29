USER ?= ztlevi
SYSTEM 		:=$(shell uname -s)
CI 			?=$(GITHUB_ACTIONS)
CI 			?=$(TRAVIS)

NIXOS_VERSION := 20.09
NIXOS_PREFIX  := $(PREFIX)/etc/nixos
DARWIN_PREFIX := $(HOME)/.nixpkgs
COMMAND       := test
FLAGS         := -I "config=$$(pwd)/config" \
				 -I "modules=$$(pwd)/modules" \
				 -I "bin=$$(pwd)/bin" \
				 $(FLAGS)

ifeq ($(SYSTEM),Linux)
HOST ?= kuro
HOME := /home/$(USER)
# The real Labowski
all: channels
	@sudo nixos-rebuild $(FLAGS) $(COMMAND)

install: channels update config move_to_home
	@sudo nixos-install --root "$(PREFIX)" $(FLAGS)

upgrade: update switch

update: channels
	@sudo nix-channel --update

switch:
	@sudo nixos-rebuild $(FLAGS) switch

build:
	@sudo nixos-rebuild $(FLAGS) build

boot:
	@sudo nixos-rebuild $(FLAGS) boot

rollback:
	@sudo nixos-rebuild $(FLAGS) --rollback $(COMMAND)

dry:
	@sudo nixos-rebuild $(FLAGS) dry-build

gc:
	@sudo nix-collect-garbage -d

vm:
	@sudo nixos-rebuild $(FLAGS) build-vm

clean:
	@rm -f result


# Parts
config: $(NIXOS_PREFIX)/configuration.nix
move_to_home: $(HOME)/.dotfiles

channels:
	@sudo nix-channel --add "https://nixos.org/channels/nixos-${NIXOS_VERSION}" nixos
	@sudo nix-channel --add "https://github.com/rycee/home-manager/archive/release-${NIXOS_VERSION}.tar.gz" home-manager
	@sudo nix-channel --add "https://nixos.org/channels/nixos-unstable" nixos-unstable
# for other linux
# @sudo nix-channel --add "https://nixos.org/channels/nixpkgs-unstable" nixpkgs-unstable

$(NIXOS_PREFIX)/configuration.nix:
	@sudo nixos-generate-config --root "$(PREFIX)"
	@echo "import /etc/dotfiles \"$${HOST:-$$(hostname)}\" \"$$USER\"" | sudo tee "$(NIXOS_PREFIX)/configuration.nix"
	@[ -f machines/$(HOST).nix ] || echo "WARNING: hosts/$(HOST)/default.nix does not exist"

$(HOME)/.dotfiles:
	@mkdir -p $(HOME)
	@[ -e $(HOME)/.dotfiles ] || sudo mv /etc/dotfiles $(HOME)/.dotfiles
	@[ -e /etc/dotfiles ] || sudo ln -s $(HOME)/.dotfiles /etc/dotfiles
	@chown $(USER):users $(HOME) $(HOME)/.dotfiles
endif

ifeq ($(SYSTEM),Darwin)
HOST ?= shiro
HOME := /Users/$(USER)

# @darwin-rebuild $(FLAGS) switch --show-trace
switch:
	@darwin-rebuild $(FLAGS) switch

nix_install:
	@bash -c "sh <(curl -L https://nixos.org/nix/install) --no-daemon"
	@. $(HOME)/.nix-profile/etc/profile.d/nix.sh
	@mkdir -p /tmp/nix-install && cd /tmp/nix-install; \
		nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer; \
		yes | ./result/bin/darwin-installer; \
		rm -rf /tmp/nix-install

install: nix_install channels $(DARWIN_PREFIX)/darwin-configuration.nix
	@darwin-rebuild $(FLAGS) switch

channels:
	@nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	@nix-channel --update

gc:
	@nix-collect-garbage -d

config: $(DARWIN_PREFIX)/darwin-configuration.nix
$(DARWIN_PREFIX)/darwin-configuration.nix:
	@echo "import ~/.config/dotfiles \"$${HOST:-$$(hostname)}\" \"$$USER\"" > "$(DARWIN_PREFIX)/darwin-configuration.nix"
endif

# Convenience aliases
i: install
s: switch
up: upgrade

.PHONY: config

