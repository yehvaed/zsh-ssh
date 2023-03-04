# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

# Return if requirements are missing
if [[ $TERM == 'dumb' ]]; then
  return 1
fi

# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Functions directory
# https://wiki.zshell.dev/community/zsh_plugin_standard#funtions-directory
if [[ ${zsh_loaded_plugins[-1]} != */kalc && -z ${fpath[(r)${0:h}/functions]} ]]; then
  fpath+=( "${0:h}/functions" )
fi

if [[ $PMSPEC != *f* ]]; then
  fpath+=( "${0:h}/functions" )
fi

autoload -Uz fzf-complete-ssh

[ -z "$fzf_ssh_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || fzf_ssh_default_completion=$binding[(s: :w)2]
  unset binding
}

zle -N fzf-complete-ssh
bindkey '^I' fzf-complete-ssh