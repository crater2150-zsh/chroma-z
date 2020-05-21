##############
# Color config
##############

autoload -U colors && colors

#
# 256-color-term or rxvt with wrong tput output
#
if [[ "`tput colors`" == "256" ]] || [[ "`tput colors`" == "88" ]] ; then
	local BOLD="[01m"
	local color_fg() {
		echo "%{$2[38;5;${1}m%}"
	}
	local color_bg() {
		echo "%{$2[48;5;${1}m%}"
	}

	reset="%{${reset_color}%}"
	pathcolor=$(color_fg 27)
	ropathcolor=$(color_fg 92)

	gitdirty=$(color_fg 160 $BOLD)
	gitstaged=$(color_fg 34 $BOLD)
	gitclean=$(color_fg 240)
	stycolor=$(color_fg 240)
	exitcolor=$gitdirty
	rpscolor=$(color_fg 238)
	gituntracked="$(color_fg 253 $BOLD)●${reset}${rpscolor}"

	local usercolor_base
	if [ "$EUID" = "0" ] || [ "$USER" = "root" ] ; then
		usercolor_base=196
		usercolor_mod=30
	else
		usercolor_base=47
		usercolor_mod=28

	fi
	if in_ssh_session; then
		usercolor_base=$((usercolor_base + usercolor_mod))
		hostcolor=$(color_fg 226)
	else
		hostcolor=$gitclean
	fi
	usercolor=$(color_fg $usercolor_base $BOLD)

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
	pathcolor="%{$fg_bold[blue]}%}"

	gitdirty="%{${fg[yellow]}%}"
	gitstaged="%{${fg[green]}%}"
	gitclean="%{${fg[white]}%}"
	vcs_revision="%{${fg_bold[black]}%}"

	exitcolor="$gitdirty"
	rpscolor="%{$fg_bold[black]}%}"

	if [ "$EUID" = "0" ] || [ "$USER" = "root" ] ; then
		if [ ! -z $SSH_CLIENT ]; then
			usercolor="%{${fg_bold[yellow]}%}"
			hostcolor="%{${fg_no_bold[blue]}%}"
		else
			usercolor="%{${fg_bold[red]}%}"
			hostcolor="%{${fg_bold[black]}%}"
		fi
	else
		if [ ! -z $SSH_CLIENT ]; then
			usercolor="%{${fg_bold[blue]}%}"
			hostcolor="%{${fg_no_bold[blue]}%}"
		else
			usercolor="%{${fg_bold[green]}%}"
			hostcolor="%{${fg_bold[black]}%}"
		fi
	fi
fi
