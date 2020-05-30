bindkey -M viins '^[x' fzf-history-widget
bindkey -M viins '^[p' fzf-file-widget
bindkey -M viins "^r" fzf-history-widget
bindkey "^I" fzf-completion

for file in ${XDG_CONFIG_HOME}/fzf/addons/*.zsh; do
  source ${file}
done
