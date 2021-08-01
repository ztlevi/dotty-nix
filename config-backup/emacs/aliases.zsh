alias e='emacsclient -n'
alias et="emacs -nw"
alias ec="emacsclient"
alias e.="emacsclient ."
alias se="sudo -E emacs"
alias doom='doom -y'
alias magit="emacsclient -n -e \(magit-status\)"
alias ke="pkill -SIGUSR2 -i emacs"
alias edebug="emacs --debug-init"
alias etime="emacs --timed-requires --profile"

ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }
