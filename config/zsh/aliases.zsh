zman() { PAGER="less -g -s '+/^       "$1"'" man zshall; }

r() {
  local time=$1
  shift
  sched "$time" "notify-send --urgency=critical 'Reminder' '$@'"
}
compdef r=sched

# aliases common to all shells
alias q=exit
alias open=open_command
alias clr=clear
alias sudo='sudo '
k9() {
  # Usage: k9 22234 1213 or k9 chrome
  if echo $@ | rg -q "[\d\s\t]+"; then
    process_ids=("${(@f)}$@")
  else
    process_ids=("${(@f)$(pgrep $1)}")
  fi
  kill -9 ${process_ids[@]} || "no process found by searching $@"
}
alias ka=killall

alias du=dust
alias dud="dust -d 1"

if _is_callable exa; then
  alias ls="exa"
  alias l="exa -1"
  alias ll="exa -lgh"
  alias la="LC_COLLATE=C exa -la"
fi
alias ls="${aliases[ls]:-ls} --color=auto --group-directories-first"
alias sc="systemctl";
alias ssc="sudo systemctl";

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias ln="${aliases[ln]:-ln} -v" # verbose ln
alias mkdir='mkdir -p'
unalias fd 2>/dev/null

alias gurl='curl --compressed'
alias wget='wget -c' # Resume dl if possible

alias ag="noglob ag -p $XDG_CONFIG_HOME/ag/agignore"
alias rg='noglob rg'
alias prg="ps aux | rg -i"
function grep_search() { echo $2 | grep -qiP $1; }
function rg_search() { echo $2 | rg -qS $1; }
function vread() {
  (
    $@ > /tmp/dummy_vread_file
    nvim /tmp/dummy_vread_file
    rm -f /tmp/dummy_vread_file
  )
}

# For example, to list all directories that contain a certain file: find . -name
# .gitattributes | map dirname
alias map="xargs -n1"

# Convenience
alias mk=make
if _is_callable bat; then
  alias bat="bat --theme OneHalfLight"
  alias cat=bat
fi
_is_callable neofetch && alias nf="neofetch"
_is_callable cmatrix && alias cm="cmatrix -C red"

take() { mkdir "$1" && cd "$1"; }
compdef take=mkdir
hex() { echo -n $@ | xxd -psdu; }

_is_callable antigen && alias ar="antigen reset"

alias get_window_class="xprop | grep WM_CLASS"

alias nr="nix repl '<nixpkgs/nixos>'"
