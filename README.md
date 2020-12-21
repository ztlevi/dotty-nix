![Test](https://github.com/ztlevi/nix-dotfiles/workflows/Test/badge.svg)
[![Made with Doom Emacs](https://img.shields.io/badge/Made_with-Doom_Emacs-blueviolet.svg?style=flat-square&logo=GNU%20Emacs&logoColor=white)](https://github.com/hlissner/doom-emacs)
[![NixOS 20.03](https://img.shields.io/badge/NixOS-v20.03-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

![Me looking busy](/../screenshots/fluorescence/fakebusy.png?raw=true)

<p align="center">
<span><img src="/../screenshots/fluorescence/desktop.png?raw=true" height="188" /></span>
<span><img src="/../screenshots/fluorescence/rofi.png?raw=true" height="188" /></span>
<span><img src="/../screenshots/fluorescence/tiling.png?raw=true" height="188" /></span>
</p>

# My dotfiles

- **Operating System:** NixOS
- **Shell:** zsh + antigen
- **DM:** sddm + clairvoyance.nix
- **WM:** bspwm + polybar
- **Editor:** [Doom Emacs][doom-emacs] (and occasionally [vim][vimrc])
- **Terminal:** alacritty
- **Launcher:** rofi
- **Browser:** firefox
- **GTK Theme:** [flat-remix-gtk](https://github.com/daniruiz/flat-remix-gtk)
- **Icon Theme:** [flat-remix-icon](https://github.com/daniruiz/flat-remix)

_Works on my machine_ ¯\\\_(ツ)\_/¯

## Quick start

### NixOS

1. Yoink [NixOS 20.09][nixos] (must be newer than Sept 12, 2020 for `nixos-install --flake`).
2. Boot into the installer.
3. Do your partitions and mount your root to `/mnt`
4. `git clone --recurse-submodules -j8 https://github.com/ztlevi/nix-dotfiles /mnt/etc/nixos`
5. Install NixOS: `nixos-install --root /mnt --flake /mnt/etc/nixos#XYZ`, where `XYZ` is your
   hostname. Use `#generic` for a simple, universal config.
6. OPTIONAL: Create a sub-directory in `hosts/` for your device. See [host/kuro] as an example.
7. Reboot!

Note: `hey re` equals `sudo nixos-rebuild --flake .#kuro switch`. You can also add
`-p <profile-name>` to assign a profile name.

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

# Build the system
nix --experimental-features 'flakes nix-command' build $HOME/.config/dotfiles#darwinConfigurations.shiro.system
./result/sw/bin/darwin-rebuild switch --flake $HOME/.config/dotfiles#shiro
```

## Management

And I say, `bin/hey`. [What's going on?](http://hemansings.com/)

| Command           | Description                                                     |
| ----------------- | --------------------------------------------------------------- |
| `hey rebuild`     | Rebuild this flake (shortcut: `hey re`)                         |
| `hey upgrade`     | Update flake lockfile and switch to it (shortcut: `hey up`)     |
| `hey rollback`    | Roll back to previous system generation                         |
| `hey gc`          | Runs `nix-collect-garbage -d`. Use sudo to clean system profile |
| `hey push REMOTE` | Deploy these dotfiles to REMOTE (over ssh)                      |
| `hey check`       | Run tests and checks for this flake                             |
| `hey show`        | Show flake outputs of this repo                                 |

## Frequently asked questions

- **Why NixOS?**

  Because declarative, generational, and immutable configuration is a godsend when you have a fleet
  of computers to manage.

- **How do I change the default username?**

  1. Set `USER` the first time you run `nixos-install`:
     `USER=myusername nixos-install --root /mnt --flake #XYZ`
  2. Or change `"ztlevi"` in modules/options.nix.

- **How do I "set up my partitions"?**

  My main host [has a README](hosts/kuro/README.org) you can use as a reference. I set up an EFI+GPT
  system and partitions with `parted` and `zfs`.

- **Why did you write bin/hey?**

  I'm nonplussed by the user story for nix's CLI tools and thought fixing it would be more
  productive than complaining about it on the internet. Then I thought,
  [why not do both](https://youtube.com/watch?v=vgk-lA12FBk)?

- **How 2 flakes?**

  Would it be the NixOS experience if I gave you all the answers in one, convenient place?

  No, but here are some resources that helped me:

  - [A three-part tweag article that everyone's read.](https://www.tweag.io/blog/2020-05-25-flakes/)
  - [An overengineered config to scare off beginners.](https://github.com/nrdxp/nixflk)
  - [A minimalistic config for scared beginners.](https://github.com/colemickens/nixos-flake-example)
  - [A nixos wiki page that spells out the format of flake.nix.](https://nixos.wiki/wiki/Flakes)
  - [Official documentation that nobody reads.](https://nixos.org/learn.html)
  - [Some great videos on general nixOS tooling and hackery.](https://www.youtube.com/channel/UC-cY3DcYladGdFQWIKL90SQ)
  - A couple flake configs that I [may](https://github.com/LEXUGE/nixos)
    [have](https://github.com/bqv/nixrc)
    [shamelessly](https://git.sr.ht/~dunklecat/nixos-config/tree)
    [rummaged](https://github.com/utdemir/dotfiles) [through](https://github.com/purcell/dotfiles).
  - [Some notes about using Nix](https://github.com/justinwoo/nix-shorts)
  - [What helped me figure out generators (for npm, yarn, python and haskell)](https://myme.no/posts/2020-01-26-nixos-for-development.html)
  - [What y'all will need when Nix drives you to drink.](https://www.youtube.com/watch?v=Eni9PPPPBpg)
