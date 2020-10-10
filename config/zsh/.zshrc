# Load Antigen bundles first

source ${ZDOTDIR}/env.zsh

source ${ZDOTDIR}/bundles.zsh
source ${ZDOTDIR}/fasd.zsh

source ${ZDOTDIR}/config.zsh
source ${ZDOTDIR}/utils.zsh
source ${ZDOTDIR}/aliases.zsh
source ${ZDOTDIR}/completion.zsh
source ${ZDOTDIR}/keybinds.zsh

source ${ZDOTDIR}/extra.zshrc
if [ -f ~/.zshrc ]; then source ~/.zshrc; fi
