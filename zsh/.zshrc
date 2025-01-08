#devbox
eval "$(devbox global shellenv --init-hook)"

#posh
eval "$(oh-my-posh init zsh)"

#zellij
if [[ $- == *i* && -z "$ZELLIJ" ]]; then
    zellij ls
fi
