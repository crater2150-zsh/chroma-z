# Show screen STY and tmux number
__chromaz::sty () {
	local sty=$?
	echo -n "${STY:+"SCREEN:"}${(S)STY/#*./}${STY+" - "}"
	echo -n "${TMUX:+"TMUX:"}${TMUX/*,/}${TMUX+" - "}"
	echo -n "%y"
}

# show number of attached and detached screens
__chromaz::screennum() {
	local att
	local det
	local dead
	if [ -x /usr/bin/screen ]; then
		att=`screen -ls | grep -c Attached`
		det=`screen -ls | grep -c Detached`
		dead=`screen -ls | grep -c Dead `
		echo "A:$att|D:$det|?:$dead"
	fi
}

__chromaz::exitstatus () {
  local exitstatus=$?

  if [ $exitstatus -ne 0 ] ; then
    if [ $exitstatus -gt 128 -a $exitstatus -lt 163 ] ; then
      echo "SIG$signals[$exitstatus-127]"
    else
      echo "${exitstatus}${SIG_PROMPT_SUFFIX}"
    fi
  fi
}

__chromaz::in_ssh_session() {
  if command -v pstree &>/dev/null; then
    pstree -s $$ | grep -q sshd
  else
    [ ! -z $SSH_CLIENT ] || [ ! -z $SSH_CONNECTION ]
  fi
}
