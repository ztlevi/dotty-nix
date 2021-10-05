![Test](https://github.com/ztlevi/nix-dotfiles/workflows/Test/badge.svg)
[![Made with Doom Emacs](https://img.shields.io/badge/Made_with-Doom_Emacs-blueviolet.svg?style=flat-square&logo=GNU%20Emacs&logoColor=white)](https://github.com/hlissner/doom-emacs)
[![NixOS 20.03](https://img.shields.io/badge/NixOS-v20.03-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

<p align="center">
<span><img src="/../screenshot/nix-gnome-whitesur.png?raw=true" height="500" /></span>
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

> Note: if you're in China, use the mirror instead https://mirrors.tuna.tsinghua.edu.cn/help/nix/

### NixOS

1. Yoink [NixOS 20.09][nixos] (must be newer than Sept 12, 2020 for `nixos-install --flake`).
2. Boot into the installer.
3. Do your partitions and mount your root to `/mnt`
4. `git clone --recurse-submodules -j8 https://github.com/ztlevi/nix-dotfiles /mnt/etc/nixos`
5. OPTIONAL: Clone my private assets repo, `cd /mnt/etc/nixos && git clone https://github.com/ztlevi/dotty-assets.git assets`
6. Install NixOS: `nixos-install --root /mnt --flake /mnt/etc/nixos#XYZ`, where `XYZ` is your
   hostname. Use `#generic` for a simple, universal config.
7. OPTIONAL: Create a sub-directory in `hosts/` for your device. See [host/kuro] as an example.
8. Reboot!

Note: `hey re` equals `sudo nixos-rebuild --flake .#kuro switch`. You can also add
`-p <profile-name>` to assign a profile name.

#### Post-Installation

- for fcitx, run the following script to install config and dict.
``` sh
${DOTTY_CONFIG_HOME}/misc/chinese/install_fcitx5_config.sh
```

## Uninstall

``` sh
rm -rf $HOME/{.nix-channels,.nix-defexpr,.nix-profile,.config/nixpkgs}
sudo rm -rf /nix

if [[ $(_os) == "macos" ]]; then
  # Delete Users in macos
  for num in {1..32}; do sudo dscl . -delete /Users/nixbld$num; done
  sudo dscl . -delete /Groups/nixbld
fi
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

- **Where is `$out`?**
  See `/etc/profiles/per-user/$USER/`.

- **No space left on device. Build failed.**

  Increase `/tmp` folder size with `sudo mount -o remount,size=30G /tmp`

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
