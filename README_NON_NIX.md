### Non NixOS Linux

```sh
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. $HOME/.nix-profile/etc/profile.d/nix.sh
nix-env -iA nixpkgs.nixFlakes

git clone --recurse-submodules -j8 https://github.com/ztlevi/nix-dotfiles ~/.config/dotfiles

# Build the toplevel flake build
nix --experimental-features 'flakes nix-command' build \
    ~/.config/dotfiles#nixosConfigurations.kuro.config.system.build.toplevel -L

# Then you could do to set it as a new generation in the system profile:
sudo nix build --profile /nix/var/nix/profiles/system "$(readlink -f result)"

# And then you could immediately switch to it:
# This is very similar to what nixos-rebuild --flake does.
# (Blocked) This will raise error on non-nixos system
# sudo nix shell -vv "$(readlink -f result)" -c switch-to-configuration switch
```

### Darwin

```sh
git clone --recurse-submodules -j8 https://github.com/ztlevi/nix-darwin-dotfiles ~/.config/dotfiles

cd ~/.config/dotfiles

# For single user
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. $HOME/.nix-profile/etc/profile.d/nix.sh

# For multi-user install see https://nixos.org/manual/nix/stable/#sect-multi-user-installation
# sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
# sudo chown -R ztlevi /nix

# Install nixUnstable
nix-env -f https://github.com/nixos/nixpkgs/archive/nixpkgs-20.09-darwin.tar.gz -iA nixUnstable
nix-env -f https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz -iA nixUnstable

# Build the system
nix --experimental-features 'flakes nix-command' build $HOME/.config/dotfiles#darwinConfigurations.shiro.system
./result/sw/bin/darwin-rebuild switch --flake $HOME/.config/dotfiles#shiro
```



