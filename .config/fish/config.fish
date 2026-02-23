set fish_greeting

alias v="nvim"
alias vv="nvim ."
alias vh="nvim ~/.config/hypr/"
alias vn="nvim ~/.config/nvim/"
alias vf="nvim ~/.config/fish"
alias vha="nvim /mnt/ha"

alias l="ls --color"
alias ll="ls -la --color"
alias py="python3"
alias gp="git add . && git commit -m "update" && git push"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

abbr -a vc nvim ~/.config/fish/config.fish

set -gx EDITOR /usr/bin/nvim
set -gx BROWSER /usr/bin/firefox
set -gx TERMINAL /usr/bin/kitty

set -Ux fish_user_paths $HOME/.local/bin $fish_user_paths

set -Ux ELECTRON_USE_WAYLAND 1
set -Ux ELECTRON_OZONE_PLATFORM wayland
set -Ux ELECTRON_ENABLE_FEATURES WaylandWindowDecorations
set -Ux ELECTRON_DISABLE_GPU 1

fzf --fish | source

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

