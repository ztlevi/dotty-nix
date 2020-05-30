function ranger-cd() {
  tmpfile='/tmp/choosedir'
  curdir=$(pwd)
  ranger --choosedir="$tmpfile" "${@:-$curdir}"
  if [[ -f "$tmpfile" ]] && [[ $(cat "$tmpfile") != $curdir ]]; then
    cd $(cat $tmpfile)
  fi
  rm -f "$tmpfile"
}

function widget-ranger-cd() {
  BUFFER="ranger-cd"
  zle accept-line
}
zle -N widget-ranger-cd

# Ranger
bindkey '^o' widget-ranger-cd
