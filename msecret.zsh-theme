# custom theme
autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' |%b%c%u%B%F{green}|'
    } else {
        zstyle ':vcs_info:*' formats ' |%b%c%u%B%F{red}●%F{green}|'
    }

    vcs_info
}
trunc_git="${(l:20:: :)${vcs_info_msg_0_[1,20]}}..."

setopt prompt_subst
PROMPT='%B%F{yellow}𝕄𝕊 %20<…<%2c/%<<%F{green}%20<…<${vcs_info_msg_0_}%<<%B%F{green} ❯%F{green}❯ %F{white}%{$reset_color%}'
RPROMPT='%F{blue}⌚ %T %{$reset_color%}%'

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
