# macos

# .zshrc

```
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

osascript -e 'tell application "Viscosity" to connectall'

eval "$(/opt/homebrew/bin/brew shellenv)"

# ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fox"
CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
	git
	docker
	docker-compose
)

source $ZSH/oh-my-zsh.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

```


# nightlight

brew install smudge/smudge/nightlight
