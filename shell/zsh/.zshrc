#!/usr/bin/env zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Shell options (zsh equivalents of bash shopt)
setopt AUTO_CD           # cd by typing directory name
setopt GLOB_STAR_SHORT   # ** recursive globbing
setopt NO_CASE_GLOB      # case-insensitive globbing
setopt CORRECT           # autocorrect typos in commands
setopt CHECK_JOBS        # warn about background jobs on exit

# History
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=50000000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Completion
autoload -Uz compinit
compinit

# Source shared dotfiles
for file in ~/.{aliases,functions,extra,exports}; do
  [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

# Window title
set_win_title() {
  echo -ne "\033]0; ${PWD} \007"
}

# SSH tab completion via zsh completion system
if [[ -e "$HOME/.ssh/config" ]]; then
  zstyle ':completion:*:ssh:*' hosts $(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')
fi

# opencode completion (zsh)
_opencode_completion() {
  local -a completions
  completions=("${(@f)$(opencode --get-yargs-completions "${words[@]}" 2>/dev/null)}")
  compadd -a completions
}
compdef _opencode_completion opencode

# starship prompt
if hash starship 2>/dev/null; then
  precmd() { set_win_title }
  eval "$(starship init zsh)"
fi

# kubectl completion
if hash kubectl 2>/dev/null; then
  source <(kubectl completion zsh)
fi

# thefuck
if hash thefuck 2>/dev/null; then
  eval "$(thefuck --alias)"
fi

# thefuck alternative
if hash pay-respects 2>/dev/null; then
  eval "$(pay-respects zsh)"
fi

# direnv
if hash direnv 2>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# navi shell widget
if hash navi 2>/dev/null; then
  eval "$(navi widget zsh)"
fi

# fzf key bindings and fuzzy completion
if hash fzf 2>/dev/null; then
  eval "$(fzf --zsh)"
fi
