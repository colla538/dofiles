# Minimal ZSH config with autosuggestions + spacing

# precmd() { echo }   # always echo a blank line before the prompt

PROMPT=' [ %~ ] '

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

autoload -U compinit
compinit

# enable menu selection with tab
zstyle ':completion:*' menu select
bindkey '^I' expand-or-complete

bindkey ";5D" backward-word
bindkey ";5C" forward-word

# CLONE ZSH-AUTOSUGGESTION FIRST BEFORE ENABLING THIS
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Make clear also echo a blank line
 alias clear='clear && echo'

echo

wal -R -q
