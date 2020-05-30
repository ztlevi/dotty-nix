#!/usr/bin/env zsh
# env -- envvars & standard library for dotfiles; don't symlink me!
# Can be sourced by zsh/bash scripts

for dir in "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_BIN_HOME"; do
  [[ -d $dir ]] || mkdir -p "$dir"
done

## Library
function _is_interactive() { [[ $- == *i* || -n $EMACS ]]; }

function _is_running() {
  for prc in "$@"; do
    pgrep -x "$prc" >/dev/null || return 1
  done
}

function _is_callable() {
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || return 1
  done
}

function _run() {
  if _is_callable "$1" && ! _is_running "$1"; then
    "$@"
  fi
}

function _call() {
  if _is_callable "$1"; then
    "$@"
  fi
}

function _source() {
  [[ -f $1 ]] && source "$1"
}

function _load() {
  case $1 in
  /*) source "$1" ;;
  *) source "$DOTFILES/$1" ;;
  esac
}

function _load_all() {
  for file in "$DOTFILES_DATA"/*.topic/"$1"; do
    [[ -e $file ]] && source "$file"
  done
}

function _load_repo() {
  _ensure_repo "$1" "$2" && source "$2/$3" || echo >&2 "Failed to load $1"
}

function _ensure_repo() {
  local target=$1
  local dest=$2
  if [[ ! -d $dest ]]; then
    if [[ $target =~ "^[^/]+/[^/]+$" ]]; then
      url=https://github.com/$target
    elif [[ $target =~ "^[^/]+$" ]]; then
      url=git@github.com:$USER/$target.git
    fi
    [[ -n ${dest%/*} ]] && mkdir -p ${dest%/*}
    git clone --recursive "$url" "$dest" || return 1
  fi
}

function _os() {
  case $OSTYPE in
  linux*) if [[ -f /etc/arch-release ]]; then
    echo arch
  elif [[ -f /etc/debian_version ]]; then
    echo debian
  fi ;;
  darwin*) echo macos ;;
  cygwin*) echo cygwin ;;
  esac
}

function _cache() {
  command -v "$1" >/dev/null || return 1
  local cache_dir="$XDG_CACHE_HOME/${SHELL##*/}"
  local cache="$cache_dir/$1"
  if [[ ! -f $cache || ! -s $cache ]]; then
    echo "Caching $1"
    mkdir -p $cache_dir
    "$@" >$cache
  fi
  source $cache || rm -f $cache
}

function _cache_clear() {
  command rm -rf $XDG_CACHE_HOME/${SHELL##*/}
}
