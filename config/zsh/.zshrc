# Load Antigen bundles first

source ${ZDOTDIR}/env.zsh

source ${ZDOTDIR}/bundles.zsh

source ${ZDOTDIR}/config.zsh
source ${ZDOTDIR}/utils.zsh
source ${ZDOTDIR}/aliases.zsh
source ${ZDOTDIR}/completion.zsh
source ${ZDOTDIR}/keybinds.zsh

source ${ZDOTDIR}/extra.zshrc

if [ -f ${ZDOTDIR}/local.zsh ]; then
  source ${ZDOTDIR}/local.zsh
fi
[ -f ~/.zshrc ] && source ~/.zshrc
