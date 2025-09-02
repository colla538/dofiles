# Minimal ZSH config with autosuggestions + spacing

# precmd() { echo }   # always echo a blank line before the prompt

PROMPT=' [ %~ ] '

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

bindkey ";5D" backward-word
bindkey ";5C" forward-word

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Make clear also echo a blank line
 alias clear='clear && echo'

echo

wal -R -q
