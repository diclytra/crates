alias tmux='tmux -2'
export PATH="$(yarn global bin):~/go/bin:$PATH"
[ -z $TMUX  ] && { tmux attach || tmux new && exit;}
