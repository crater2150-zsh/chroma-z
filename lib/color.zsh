##############
# Color config
##############

autoload -U colors && colors

#
# 256-color-term or rxvt with wrong tput output
#
typeset -gA __color

local term_colors=$(tput colors)
if [[ $term_colors -gt 16 ]] ; then
	local usercolor_base usercolor_mod colorfile

	local BOLD="[01m"
	local color_fg() {
		echo "%{$2[38;5;${1}m%}"
	}
	local color_bg() {
		echo "%{$2[48;5;${1}m%}"
	}

	__color=(
		[reset]="%{${reset_color}%}"
		[path]=$(color_fg 27)
		[path_ro]=$(color_fg 92)
		[gitdirty]=$(color_fg 160 $BOLD)
		[gitstaged]=$(color_fg 34 $BOLD)
		[gitclean]=$(color_fg 240)
		[sty]=$(color_fg 240)
		[rps]=$(color_fg 238)
		[gituntracked]="$(color_fg 253 $BOLD)"
		[vcs_revision]="$(color_fg 251 $BOLD)"
	)

	__color[exit]=${__color[gitdirty]}

	if [ "$EUID" = "0" ] || [ "$USER" = "root" ] ; then
		usercolor_base=196
		usercolor_mod=30
	else
		usercolor_base=47
		usercolor_mod=28

	fi
	if __chromaz::in_ssh_session; then
		usercolor_base=$((usercolor_base + usercolor_mod))
		__color[host]=$(color_fg 226)
	else
		__color[host]=${__color[gitclean]}
	fi
	__color[user]=$(color_fg $usercolor_base $BOLD)

	for colorfile in /etc/DIR_COLORS.256 \
	                 /etc/DIR_COLORS.256color \
	                 /etc/colors/DIR_COLORS.256 \
					 /etc/colors/DIR_COLORS.256color; do
		if [ -e $colorfile ] ; then
			eval "$(dircolors $colorfile)"
			break;
		fi
	done
else
	__color=(
		[reset]="%{${reset_color}%}"
		[path]="%{$fg_bold[blue]}%}"
		[path_ro]="%{$fg_bold[magenta]}%}"
		[gitdirty]="%{${fg[yellow]}%}"
		[gitstaged]="%{${fg[green]}%}"
		[gitclean]="%{${fg[white]}%}"
		[sty]="%{$fg_no_bold[black]}%}"
		[rps]="%{$fg_bold[black]}%}"
		[vcs_revision]="%{${fg_bold[black]}%}"
	)

	__color[exit]=${__color[gitdirty]}

	if [ "$EUID" = "0" ] || [ "$USER" = "root" ] ; then
		if [ ! -z $SSH_CLIENT ]; then
			__color[user]="%{${fg_bold[yellow]}%}"
			__color[host]="%{${fg_no_bold[blue]}%}"
		else
			__color[user]="%{${fg_bold[red]}%}"
			__color[host]="%{${fg_bold[black]}%}"
		fi
	else
		if [ ! -z $SSH_CLIENT ]; then
			__color[user]="%{${fg_bold[blue]}%}"
			__color[host]="%{${fg_no_bold[blue]}%}"
		else
			__color[user]="%{${fg_bold[green]}%}"
			__color[host]="%{${fg_bold[black]}%}"
		fi
	fi
fi
