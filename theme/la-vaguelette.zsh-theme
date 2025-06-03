local GIT_BRANCH_COLOR='%{\e[1;35m%}'
local GIT_CLEAN_COLOR='%F{2}'
local GIT_DIRTY_COLOR='%F{1}'
local GIT_STASH_COLOR='%F{5}'
local GIT_ARROW_COLOR='%F{6}'
local GIT_BRACKET_COLOR='%{\e[0;34m%}'

# Git
function git_prompt_custom() {
  local ref
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    ref=$(git symbolic-ref --short HEAD 2>/dev/null) || ref="➦$(git rev-parse --short HEAD 2>/dev/null)"

    local status_flags=""
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      status_flags+="${GIT_DIRTY_COLOR}✗%f"
    else
      status_flags+="${GIT_CLEAN_COLOR}✓%f"
    fi

    $(git rev-parse --verify refs/stash &>/dev/null) && status_flags+="${GIT_STASH_COLOR}⚑%f"

    local remote_status=$(git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)
    [[ -n "$remote_status" ]] && {
      local ahead=$(echo $remote_status | awk '{print $1}')
      local behind=$(echo $remote_status | awk '{print $2}')
      [[ $ahead -gt 0 ]] && status_flags+="${GIT_ARROW_COLOR}↑${ahead}%f"
      [[ $behind -gt 0 ]] && status_flags+="${GIT_ARROW_COLOR}↓${behind}%f"
    }

    echo -n " ${GIT_BRACKET_COLOR}[%f${GIT_BRANCH_COLOR}${ref}%f${status_flags}${GIT_BRACKET_COLOR}]%f"
  fi
}

PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%(!.%{\e[1;33m%}⚡root%{\e[1;31m%}⚡%{\e[0m%}%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m.%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m)%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%Y-%m-%d %H:%M:%S"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%b%{\e[0m%}$(git_prompt_custom) '
