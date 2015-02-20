# ---[ History ]-------------------------------------------------------
HISTSIZE=3000
SAVEHIST=$HISTSIZE
bindkey -e

# ---[ Environment ]---------------------------------------------------
export PS_PERSONALITY='linux'
[[ $TERM == eterm-color ]] && export TERM=xterm

# ---[ Augment fpath ]-------------------------------------------------
fpath=(~/.zsh/completion $fpath)

# ---[ Autojump ]------------------------------------------------------
source ~/dotfiles.bkp/z/z.sh
function j () {
    z "$@" || return 0;
}
function _z_preexec () {
    z --add "$(pwd -P)";
}

preexec_functions=(_z_preexec $preexec_functions)



#---Autols
function chpwd() {
    ls --color -v
    
}

function afp(){
         node ~/codes/afp/main.js --proxyCommand "sh ~/codes/afp/proxy.zsh %h %p"

}

function sarl(){
        /home/anakin/btp/eclipse-sarl.linux.gtk.x86_64.zip.1_FILES/eclipse-sarl

}

#--Custom
function md(){
    mkdir -p "$1" && cd "$1";
}



# ---[ Modules ]-------------------------------------------------------
zmodload zsh/complist
autoload -Uz compinit
autoload -Uz vcs_info
compinit
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -ap zsh/mapfile mapfile
autoload colors zsh/terminfo
autoload -U add-zsh-hook

# ---[ Shell exports ]-------------------------------------------------
export LANG=en_US.utf8
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export ALTERNATE_EDITOR=emacs
export EDITOR=emacsclient
export VISUAL=emacsclient

# ---[ Aliases ]-------------------------------------------------------
alias ls='ls --color'
alias i="sudo apt-fast install"
alias u="sudo apt-fast update"
alias apt="sudo apt-fast"
alias gcl="git clone"
alias gco="git commit -m"
alias ga="git add"
alias rm="rm -i"
alias mv="mv -i"
alias oldHome='cd /media/anakin/oldHome'
alias xi='cd ~/codes/Xi_2.0'
alias betty='~/codes/Xi_2.0/betty/main.rb'

# tiny helpers
function l () {
    case "$1" in
	recent)
	    shift
	    ls --color -vt "$@" | head -n 5
	    ;;
	size)
	    shift
	    ls --color -vS "$@"
	    ;;
	*)
	    ls --color -v "$@"
	    ;;
    esac
}

function x () {
    case "$1" in
	*.tar*)
	    tar xf "$1"
	    ;;
	*.zip)
	    unzip "$1"
	    ;;
        *.gz)
            gzip -d "$1"
            ;;
    esac
}



# ---[ ZSH Options ]---------------------------------------------------
setopt   NO_GLOBAL_RCS NO_FLOW_CONTROL NO_BEEP MULTIOS
setopt   AUTO_LIST NO_LIST_AMBIGUOUS MENU_COMPLETE AUTO_REMOVE_SLASH
setopt   LIST_PACKED LIST_TYPES
setopt   INC_APPEND_HISTORY EXTENDED_HISTORY SHARE_HISTORY HIST_REDUCE_BLANKS
setopt   HIST_SAVE_NO_DUPS HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST
setopt   NO_NOTIFY LONG_LIST_JOBS
setopt   AUTO_CD AUTO_PUSHD PUSHD_SILENT
setopt   PROMPT_SUBST
setopt   CORRECT
# ---[ Completition system ]-------------------------------------------
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list '+' '+m:{|:lower:|}={|:upper:|}' '+l:|=* r:|=*' '+r:|[._-]=** r:|=**'
zstyle ':completion:*' list-colors no=00 fi=00 di=01\;34 pi=33 so=01\;35 bd=00\;35 cd=00\;34 or=00\;41 mi=00\;45 ex=01\;32
zstyle ':completion:*' verbose yes
zstyle ':completion:*' insert-tab false
zstyle ':completion:*:*:git:*' verbose no
zstyle ':completion:*:files' ignored-patterns '*?.o' '*?~'
zstyle ':completion:*:files' file-sort 'date'
zstyle ':completion:*:default' list-prompt
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 5 )) )'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '|%F{green}%b%c%u%f'

# ---[ ZLE ]-----------------------------------------------------------
history-incremental-search-backward-initial() {
    zle history-incremental-search-backward $BUFFER
}
zle -N history-incremental-search-backward-initial
bindkey '^R' history-incremental-search-backward-initial
bindkey -M isearch '^R' history-incremental-search-backward

# ---[ Prompt ]--------------------------------------------------------
function precmd() { vcs_info }
[[ "$terminfo[colors]" -ge 8 ]] && colors
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="white"; fi

PROMPT='%F{$NCOLOR}%B%n%b%f\
${vcs_info_msg_0_}${proxy_info_message_}\
%F{yellow}%B%~%b%f%(!.#.$) '

# ---[ System settings ]-----------------------------------------------
limit -s coredumpsize 0
umask 002
#source /opt/ros/groovy/setup.zsh
#export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/anakin/catkin_ws/src

#--ruby

#---Vikrant Proxy functions-----
function reload-proxy(){
    proxy_info_message_='%F{red}:%f'
    if [[ -f ~/proxy.zsh ]]; then
        if [[ -z "$STOP_AUTO_PROXY" ]]; then
            source ~/proxy.zsh
            proxy_info_message_=':'
        fi
    fi

}

add-zsh-hook preexec reload-proxy
reload-proxy


function set_proxy() {
    case $1 in
	'kgp')
	    unset STOP_AUTO_PROXY
            ;;
        
	'home'|'none')
            export STOP_AUTO_PROXY="stop"
	    unset socks_proxy
	    unset http_proxy
	    unset https_proxy
            unset HTTP_PROXY
	    unset HTTPS_PROXY
	    ;;
	*)
            export STOP_AUTO_PROXY="stop"
	    unset socks_proxy && unset HTTP_PROXY && unset HTTPS_PROXY && \
	        export http_proxy=$1 && export https_proxy=$1;;
    esac
    reload-proxy
}


set_proxy kgp
function set_system_proxy(){
    proxy=$1
    #change_proxy proxy

    case $1 in
	'kgp')
	    proxy='10.3.100.211'
            change_system_proxy $proxy
            ;;
	'home'|'none')
            gsettings set org.gnome.system.proxy mode 'none'
            echo "Home"
            ;;

	*)
            gsettings set org.gnome.system.proxy mode 'manual' 
            gsettings set org.gnome.system.proxy.http host $proxy
            gsettings set org.gnome.system.proxy.https host $proxy
            gsettings set org.gnome.system.proxy.http port 8080
            gsettings set org.gnome.system.proxy.http port 8080
            echo "et cet era"
    esac
}


function notify(){
}

add-zsh-hook precmd  notify

### Added by the Heroku Toolbelt
export PATH=~/.local/share/npm/bin:/usr/local/heroku/bin:$PATH
export PATH=~/scripts:$PATH
export PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting
export PATH=$PATH:~/android/sdk/platform-tools
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
source ~/.rvm/scripts/rvm

### ANTLR
export CLASSPATH=".:/usr/local/lib/antlr-4.5-complete.jar:$CLASSPATH"
alias antlr4='java -jar /usr/local/lib/antlr-4.5-complete.jar'
alias grun='java org.antlr.v4.runtime.misc.TestRig'

function e(){
    $EDITOR $1&
}

export no_proxy="10.*"
#HADOOP VARIABLES START
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export HADOOP_INSTALL=/usr/local/hadoop
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_HOME=$HADOOP_INSTALL
export HADOOP_HDFS_HOME=$HADOOP_INSTALL
export YARN_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
#HADOOP VARIABLES END

