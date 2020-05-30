bindkey '^[x' fzf-history-widget
bindkey '^[p' fzf-file-widget

if _is_callable fzf-share; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

for file in ${XDG_CONFIG_HOME}/fzf/addons/*.zsh; do
  source ${file}
done
