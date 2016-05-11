# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gallois"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"
# autocompete ../..
zstyle ':completion:*' special-dirs true
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras svn per-directory-history autojump python history-substring-search command-not-found common-aliases zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/.zsh_aliases
if grep -qa lxc /proc/1/cgroup 
then
  LXC_PROMPT="[LXC]"
fi

# customize prompt
PROMPT="$LXC_PROMPT%m@$PROMPT"

# Customize to your needs...
if [ -e /etc/lsb-release ]
then
    export DeploymentPath=~/Work/Deployment/ubu_`cat /etc/lsb-release | grep RELEASE | cut -d '=' -f2`/
    export LD_LIBRARY_PATH=$DeploymentPath/lib
fi
# export go path
export GOROOT=/usr/local/go
export GOPATH=$HOME/workspace/go

export PATH=/usr/share/centrifydc/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/home/users/kellere5/Work/TEE-CLC-10.0.0:~/workspace/ibench:/usr/local/go/bin:$GOPATH/bin:$HOME/bin

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi
