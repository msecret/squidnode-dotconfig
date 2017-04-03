# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="msecret"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras git-flow colored-man colorize github virtualenv pip python brew osx docker gem zsh-syntax-highlighting extract npm osx tmux nvm-auto nvm-auto nvm-auto nvm-auto nvm-auto)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source $HOME/.zsh-env
source $HOME/.zsh-plugins

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias zshconfig="subl ~/.zshrc"
alias envconfig="subl ~/Projects/config/env.sh"
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'
alias l='ls -amPF'
alias ll='ls -al -GF'
alias git-clean='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'

treeDir() {
  tree -Clhcr --dirsfirst $@ | less
}
alias lll=treeDir
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


ZSH_TMUX_AUTOSTART=true

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

autoload -U +X add-zsh-hook

is-at-least 4.3.12 && __() {
    MARKPATH=$ZSH/run/marks

    _bookmark_directory_name() {
        emulate -L zsh
        setopt extendedglob
        case $1 in
            d)
                # Turn the directory into a shortest name using
                # bookmarks. We need to sort them by length of solved
                # path.
                local link slink
                local -A links
                local cache=$ZSH/run/bookmarks-$HOST-$UID
                if [[ -f $cache ]] && [[ $MARKPATH -ot $cache ]]; then
                    . $cache
                else
                    for link ($MARKPATH/*(N@)) links[${#link:A}$'\0'${link:A}]=${link:t}
                    print -r "links=( ${(kv@)^^links} )" > $cache
                fi
                for slink (${(@On)${(k)links}}) {
                    link=${slink#*$'\0'}
                    if [[ $2 = (#b)(${link})(|/*) ]]; then
                        typeset -ga reply
                        reply=("@"${links[$slink]} $(( ${#match[1]} )) )
                        return 0
                    fi
                }
                return 1
                ;;
            n)
                # Turn the name into a directory
                [[ $2 != (#b)"@"(?*) ]] && return 1
                typeset -ga reply
                reply=(${${:-$MARKPATH/$match[1]}:A})
                return 0
                ;;
            c)
                # Completion
                local expl
                local -a dirs
                dirs=($MARKPATH/*(N@:t))
                dirs=("@"${^dirs})
                vbe-remove-slash-after-bookmark () {
                    case $KEYS in
                        '/'|' '|$'\n'|$'\r')
                            LBUFFER="${LBUFFER[0,-2]}"
                            ;;
                    esac
                }
                _wanted dynamic-dirs expl 'bookmarked directory' compadd -S\]/ -R vbe-remove-slash-after-bookmark -a dirs
                return
                ;;
            *)
                return 1
                ;;
        esac
        return 0
    }

    add-zsh-hook zsh_directory_name _bookmark_directory_name

    vbe-insert-bookmark() {
        emulate -L zsh
        LBUFFER=${LBUFFER}"~[@"
    }
    zle -N vbe-insert-bookmark
    bindkey '@@' vbe-insert-bookmark

    # Manage bookmarks
    bookmark() {
        [[ -d $MARKPATH ]] || mkdir -p $MARKPATH
        if (( $# == 0 )); then
            # When no arguments are provided, just display existing
            # bookmarks
            for link in $MARKPATH/*(N@); do
                local markname="$fg[green]${link:t}$reset_color"
                local markpath="$fg[blue]${link:A}$reset_color"
                printf "%-30s -> %s\n" $markname $markpath
            done
        else
            # Otherwise, we may want to add a bookmark or delete an
            # existing one.
            local -a delete
            zparseopts -D d=delete
            if (( $+delete[1] )); then
                # With `-d`, we delete an existing bookmark
                command rm $MARKPATH/$1
            else
                # Otherwise, add a bookmark to the current
                # directory. The first argument is the bookmark
                # name. `.` is special and means the bookmark should
                # be named after the current directory.
                local name=$1
                [[ $name == "." ]] && name=${PWD:t}
                ln -s $PWD $MARKPATH/$name
            fi
            # Clean up the cache
            command rm $ZSH/run/bookmarks-$HOST-$UID
        fi
    }
} && __

# bookmarks
dev=$HOME/Dev
cg=$dev/go/src/github.com/18F/cg-deck

# Boot2Docker
$(boot2docker shellinit 2> /dev/null)

alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'

function diff {
  colordiff -u "$@" | less -RF
}

nvm use default
