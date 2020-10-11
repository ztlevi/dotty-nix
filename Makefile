USER ?= ztlevi
HOME ?= /home/$(USER)
SYSTEM 		:=$(shell uname -s)
CI 			?=$(GITHUB_ACTIONS)
CI 			?=$(TRAVIS)

NIXOS_VERSION := 20.03
NIXOS_PREFIX  := $(PREFIX)/etc/nixos
DARWIN_PREFIX := $(HOME)/.nixpkgs
COMMAND       := test
FLAGS         := -I "config=$$(pwd)/config" \
				 -I "modules=$$(pwd)/modules" \
				 -I "bin=$$(pwd)/bin" \
				 $(FLAGS)

ifeq ($(SYSTEM),Linux)
HOST := kuro
# The real Labowski
all: channels
	@sudo nixos-rebuild $(FLAGS) $(COMMAND)

install: channels update config move_to_home
	@sudo nixos-install --root "$(PREFIX)" $(FLAGS)

upgrade: update switch

update: channels
	@sudo nix-channel --update

switch:
	@sudo nixos-rebuild $(FLAGS) switch --show-trace

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
HOST := shiro
switch:
	@darwin-rebuild $(FLAGS) switch --show-trace

install: channels $(DARWIN_PREFIX)/darwin-configuration.nix
	@darwin-rebuild $(FLAGS) switch

channels:
	@nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	@nix-channel --update

$(DARWIN_PREFIX)/darwin-configuration.nix:
	@echo "import ~/.dotfiles \"$${HOST:-$$(hostname)}\" \"$$USER\"" > "$(DARWIN_PREFIX)/darwin-configuration.nix"
endif

# Convenience aliases
i: install
s: switch
up: upgrade

.PHONY: config

