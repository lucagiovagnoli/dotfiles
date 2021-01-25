# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T " 
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# git branch on prompt
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
    PS1=$PS1'\[\e[1;36m\]$(__git_ps1 " (%s)")\[\e[0m\]'
fi

# prompt always on a new line
PS1=$PS1'\n\$ '

PROMPT_COMMAND=__prompt_command # Function called after every command

__print_time() {
    echo -n "[$(date +%H:%M:%S)] "
}

__print_exit_code() {
    local EXIT="$?"             # previous exit code

    local Red='\033[0;31m'
    local Gre='\033[0;32m'
    local ResetColor='\033[0m'

    local exitFormatted=""

    if [ $EXIT != 0 ]; then
        exitFormatted+="${Red}($EXIT)${ResetColor}"  # Add red if exit code non 0
    else
        exitFormatted+="${Gre}($EXIT)${ResetColor}"
    fi

    echo -en "$exitFormatted "
}

__prompt_command() {
    __print_exit_code
    __print_time
}


alias vim=nvim
export VISUAL=vim
export EDITOR="$VISUAL"
PROMPT_DIRTRIM=3    # trims the prompt to 3 directories

## ALIASES ##
alias ccat='pygmentize -O style=monokai -f console256 -g'
alias vim_staged="vim \$(git diff --name-only)"
alias python='python3'

function vim_diff_from {
    diff_param=$1

    vim $(git diff $diff_param --name-only)
}

if [ $(which brew) ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

## SECURE WIPING SECTION

## Secure remove folder/files
function my_srm {
    srm -flvr $@
}

## Example: Wipe hard drive completely (note: must use sudo, careful cp-pasting)
#
# dd if=/dev/urandom bs=1M of=/dev/sda8

## ATA SECURE ERASE command (DO NOT attempt via USB)
#
# Information about the disk:
#  hdparm -I /dev/X
#
# Need to set up a master psswrd:
#  hdparm --user-master u --security-set-pass <passwd> /dev/X
#
# Run the command:
#  time hdparm --user-master u --security-erase <passwd> /dev/X


## COPY massive directories (preserve permissions and hard links): 
#
# rsync -nav --hard-links --progress $SOURCE $DESTINATION
#
# where:
#  -n DRY_RUN
#  -a archive (preserves most things and file attributes, includes -r)
#  -v verbose
#  -r recursive (included in -a)
#  -H --hard-links (preserve hard links)

# DIFF entire directories:
#
# rsync -navi --delete $SOURCE $DESTINATION
#
# where:
#  -i itemize (gives complete info of the differences via flags)
# --delete (for symmetrical comparisons, shows what items will be deleted in DEST)

## CRYTPSETUP (Encrypt OS partition)
#
# 1. You can restore the /boot partition using boot-repair
# 2. To restore (or setup) cryptsetup on boot, follow:
# https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019
#
# vim /etc/fstab  (for mounting partitions)
# vim /etc/crypttab  (for decrypting partitions)
# mount /dev/mapper/abcdef1234567 /target
# for n in proc sys dev etc/resolv.conf; do mount --rbind /$n /target/$n; done
# chroot /target
# mount -a
# apt install -y cryptsetup-initramfs
# update-initramfs -u -k all
