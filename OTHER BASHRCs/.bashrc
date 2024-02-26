# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

###---------- ALIASES ----------###
# source ~/.bashrc

echo "" && fortune && echo ""

alias alert='notify-send --urgency=low "$(history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'
alias tolga='sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/TolgaFedora39.sh)"'

###---------- my tools ----------###
alias htos="sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh"
alias mount="sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/MOUNT-ALL.sh"
alias mse="sudo ~/scripts/MYTOOLS/mse.sh"
alias stoh="sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh"
alias umount="sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/UMOUNT-ALL.sh"

###---------- fun stuff ----------###
alias pics="sxiv -t $HOME/Pictures/backgrounds/"
alias wp="sxiv -t $HOME/Pictures/fedora/"

###---------- navigate files and directories ----------###
alias ..="cd .."
alias cl="clear"
alias copy="rsync -P"
alias la="lsd -a"
alias ll="lsd -l"
alias ls="lsd"
alias lsla="lsd -la"

# alias chmod commands
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
alias mx='chmod a+x'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Alias's for safe and forced reboots
alias rebootforce='sudo shutdown -r -n now'
alias rebootsafe='sudo shutdown -r now'

###---------- Tools ----------###
alias rc="source ~/.bashrc"
alias bashrc='kwrite  ~/.bashrc'
alias cong="sysctl net.ipv4.tcp_congestion_control"
alias fmem="echo && echo 'Current mem:' && free -h && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' && echo && echo 'After: ' && free -h"
alias fstab="sudo mount -a && sudo systemctl daemon-reload && echo && echo \"Reloading of fstab done\" && echo"
alias grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg"
#alias io="cat /sys/block/sda/queue/scheduler"
alias io="cat /sys/block/nvme0n1/queue/scheduler"
alias line="echo '## ------------------------------ ##'"
#alias nvidia="sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo \"Force akmods and Dracut on nvidia done\" && echo"
alias pdfcompress='bash /home/tolga/scripts/pdf1.sh'
alias samba='gum spin --spinner dot --title "Restarting Samba" -- sleep 2 && sudo systemctl enable smb.service nmb.service && sudo systemctl restart smb.service nmb.service'
alias swapreload="cl && echo && echo 'Turning swap off:' && echo 'Turning swap on:' && line && sudo swapon --all && sudo swapon --show && echo && echo 'Reload Swap(s):' && line && sudo mount -a && sudo systemctl daemon-reload && sudo swapon --show && echo && echo 'Free memory:' && line && free -h && echo && duf && sys && fmem"
alias sys="echo && io && echo && cong && echo && echo 'ZSWAP status: ( Y = ON )' && cat /sys/module/zswap/parameters/enabled && systemctl restart earlyoom && systemctl status earlyoom --no-pager"
alias trim="sudo fstrim -av"
alias update="sudo dnf5 update && sudo dnf update && flatpak update && sudo snap refresh"

###---------- file access ----------###
alias bconf="vim ~/.config/bash/.bashrc"
alias cp="cp -riv"
alias htos='sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh'
alias mkdir="mkdir -vp"
alias mount='sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/MOUNT-ALL.sh'
alias mse='sudo ~/scripts/MYTOOLS/MAKE-SCRIPTS-EXECUTABLE.sh'
alias mv="mv -iv"
alias stoh='sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh'
alias umount='sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/UMOUNT-ALL.sh'
alias zconf="vim ~/.config/zsh/.zshrc"

###---------- session ----------###
alias sess='session=$XDG_SESSION_TYPE && echo "" && gum spin --spinner dot --title "Current XDG session is: [ $session ] """ -- sleep 2'

###---------- Konsole effects ----------###
# PS1="\[\e[1;m\]┌[\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]] \[\e[1;m\]::\[\e[1;36m\] \W \[\e[1;m\]::\n\[\e[1;m\]└\[\e[1;33m\]➤\[\e[0;m\]  "

###---------- Vscoding ----------###
 eval "$(direnv hook bash)"

# Display a fortune message when opening a new Bash session
echo "" && fortune && echo ""

# include .bashrc if it exists
if [ -f $HOME/.bashrc_extreme_ultimate_prompt ]; then
    . $HOME/.bashrc_extreme_ultimate_prompt
fi
