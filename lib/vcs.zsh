########################################
# vcs-info config
# Partly based on Seth House's zsh promp
########################################

autoload -Uz vcs_info

# Set up VCS_INFO
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true

zstyle ':vcs_info:hg*' formats "(%s)[%i%u %b %m]" # rev+changes branch misc
zstyle ':vcs_info:hg*' actionformats "(%s|${white}%a${__color[rps]})[%i%u %b %m]"

zstyle ':vcs_info:hg*:netbeans' use-simple true
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-mq true

zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"

zstyle ':vcs_info:hg*:*' hgrevformat "%r" # only show local rev.
zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b${__color[vcs_revision]}:%f%r%f${__color[reset]}"

if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
	zstyle ':vcs_info:git*' formats "(%s) %12.12i %c%u %b%m" # hash changes branch misc
	zstyle ':vcs_info:git*' actionformats "(%s|${white}%a${__color[rps]}) %12.12i %c%u %b%m"
} else {
        # hash changes branch misc
	zstyle ':vcs_info:git*' formats "(%s) %12.12i %c%u${__color[gituntracked]}●${__color[reset]}${__color[rps]} %b%m"
	zstyle ':vcs_info:git*' actionformats "(%s|${white}%a${__color[rps]}) %12.12i %c%u %b%m"
}


zstyle ':vcs_info:*' stagedstr "${__color[gitstaged]}●${__color[rps]}"
zstyle ':vcs_info:*' unstagedstr "${__color[gitdirty]}●${__color[rps]}"

# zstyle ':vcs_info:hg:*:-all-' command fakehg
# zstyle ':vcs_info:*+*:*' debug true

zstyle ':vcs_info:hg*+set-hgrev-format:*' hooks hg-hashfallback
zstyle ':vcs_info:hg*+set-message:*' hooks mq-vcs
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash
zstyle ':vcs_info:*+pre-get-data:*' hooks vcs-detect

+vi-vcs-detect() {
	export VCS_DETECTED=$vcs
}
#
### Dynamically set hgrevformat based on if the local rev is available
# We don't always know the local revision, e.g. if use-simple is set
# Truncate long hash to 12-chars but also allow for multiple parents
+vi-hg-hashfallback() {
    if [[ -z ${hook_com[localrev]} ]] ; then
        local -a parents

        parents=( ${(s:+:)hook_com[hash]} )
        parents=( ${(@r:12:)parents} )
        hook_com[rev-replace]="${(j:+:)parents}"

        ret=1
    fi
}

# Show remote ref name and number of commits ahead-of or behind
+vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name --abbrev-ref 2>/dev/null)}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
		(( $ahead )) && gitstatus+=( "${__color[gitstaged]}+${ahead}${__color[rps]}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "${__color[gitdirty]}-${behind}${__color[rps]}" )

        hook_com[branch]="${hook_com[branch]} [ ${remote}${gitstatus:+ }${gitstatus} ]"
    fi
}


# Show count of stashed changes
+vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

vcs_char() {
  if [[ "$PROMPT_UNICODE" == "yes" ]]; then
    case $VCS_DETECTED in 
      git) echo '±';;
      hg)  echo '☿';;
      svn) echo '☣';;
      *)   echo '#';;
    esac
  else
    echo "+"
  fi
}

