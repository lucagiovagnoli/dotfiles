# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH to include user's private bin directories
export PATH="$HOME/local/bin:$HOME/.local/bin:/usr/local/sbin:$PATH"

# set MANPATH to include user's private manpath directories
MANPATH="$HOME/local/share/man:$MANPATH"

if [ -f "$HOME/.utils.bash" ]; then
    source "$HOME/.utils.bash"
fi

export GPG_TTY=$(tty)

### Linux specific settings
if [[ "$(uname -s)" == "Linux" ]];
then

    # makes steam minimized to system tray when closing the window
    export STEAM_FRAME_FORCE_CLOSE=1

    # Swap ESC-CAPSLOC
    setxkbmap -option caps:swapescape
fi


### MAC OS X specific settings ###
if [[ "$(uname -s)" == "Darwin" ]];
then
    if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ];
    then
      . `brew --prefix`/etc/bash_completion.d/git-completion.bash
    fi

    #export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/"
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home"

    #scala 2.11
    PATH="/usr/local/opt/scala@2.11/bin:${PATH}"

    # Setting PATH for Python 3.6
    # The original version is saved in .profile.pysave
    PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
    export PATH

    # start docker on mac os X
    function docker_start {
        docker-machine start
        eval $(docker-machine env default)
    }

    # Mount external ext4 hard drive on mac:
    alias mount_ext4='sudo ext4fuse </dev/disk2s2> /Volumes/ext4_hard_drive -o allow_other'

    # Mount external ntfs hard drive on mac:
    alias mount_ntfs='sudo /usr/local/bin/ntfs-3g </dev/disk2s1> /Volumes/NTFS_hard_drive -olocal -oallow_other -oauto_xattr'
fi
