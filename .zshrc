# Minimal Zsh configuration with Starship prompt
# Created: 2026-03-22
# Migrated from Oh My Zsh to minimal setup

# ===== Basic Zsh Options =====
setopt autocd              # cd by typing directory name
setopt hist_ignore_dups    # ignore duplicate commands in history
setopt hist_ignore_space   # ignore commands starting with space
setopt share_history       # share history across sessions
setopt append_history      # append to history file

# ===== History Configuration =====
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ===== Path Configuration =====
export PATH="$HOME/.local/bin:$PATH"

# ===== Editor =====
export EDITOR=/usr/bin/nvim

# ===== Tokyo Night LS_COLORS =====
# Custom colors for ls output matching Tokyo Night theme
export LS_COLORS='rs=0:di=1;38;2;186;153;247:ln=38;5;117:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=00:su=38;5;9:sg=38;5;9:ca=38;5;9:tw=38;5;12:ow=38;5;12:st=38;5;10:ex=38;5;150:*.tar=38;5;179:*.tgz=38;5;179:*.arc=38;5;179:*.arj=38;5;179:*.taz=38;5;179:*.lha=38;5;179:*.lz4=38;5;179:*.lzh=38;5;179:*.lzma=38;5;179:*.tlz=38;5;179:*.txz=38;5;179:*.tzo=38;5;179:*.t7z=38;5;179:*.zip=38;5;179:*.z=38;5;179:*.dz=38;5;179:*.gz=38;5;179:*.lrz=38;5;179:*.lz=38;5;179:*.lzo=38;5;179:*.xz=38;5;179:*.zst=38;5;179:*.tzst=38;5;179:*.bz2=38;5;179:*.bz=38;5;179:*.tbz=38;5;179:*.tbz2=38;5;179:*.tz=38;5;179:*.deb=38;5;179:*.rpm=38;5;179:*.jar=38;5;179:*.war=38;5;179:*.ear=38;5;179:*.sar=38;5;179:*.rar=38;5;179:*.alz=38;5;179:*.ace=38;5;179:*.zoo=38;5;179:*.cpio=38;5;179:*.7z=38;5;179:*.rz=38;5;179:*.cab=38;5;179:*.jpg=38;5;183:*.jpeg=38;5;183:*.mjpg=38;5;183:*.mjpeg=38;5;183:*.gif=38;5;183:*.bmp=38;5;183:*.pbm=38;5;183:*.pgm=38;5;183:*.ppm=38;5;183:*.tga=38;5;183:*.xbm=38;5;183:*.xpm=38;5;183:*.tif=38;5;183:*.tiff=38;5;183:*.png=38;5;183:*.svg=38;5;183:*.svgz=38;5;183:*.mng=38;5;183:*.pcx=38;5;183:*.mov=38;5;183:*.mpg=38;5;183:*.mpeg=38;5;183:*.m2v=38;5;183:*.mkv=38;5;183:*.webm=38;5;183:*.webp=38;5;183:*.ogm=38;5;183:*.mp4=38;5;183:*.m4v=38;5;183:*.mp4v=38;5;183:*.vob=38;5;183:*.qt=38;5;183:*.nuv=38;5;183:*.wmv=38;5;183:*.asf=38;5;183:*.rm=38;5;183:*.rmvb=38;5;183:*.flc=38;5;183:*.avi=38;5;183:*.fli=38;5;183:*.flv=38;5;183:*.gl=38;5;183:*.dl=38;5;183:*.xcf=38;5;183:*.xwd=38;5;183:*.yuv=38;5;183:*.cgm=38;5;183:*.emf=38;5;183:*.ogv=38;5;183:*.ogx=38;5;183:*.aac=38;5;183:*.au=38;5;183:*.flac=38;5;183:*.m4a=38;5;183:*.mid=38;5;183:*.midi=38;5;183:*.mka=38;5;183:*.mp3=38;5;183:*.mpc=38;5;183:*.ogg=38;5;183:*.ra=38;5;183:*.wav=38;5;183:*.oga=38;5;183:*.opus=38;5;183:*.spx=38;5;183:*.xspf=38;5;183:'

# ===== Completion System =====
autoload -Uz compinit
compinit

# Enable completion menu
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ===== Key Bindings =====
# Emacs-style key bindings (default)
bindkey -e

# ===== Useful Aliases =====
alias ls='ls --color=auto'
alias ll='ls -lah'
alias vim='nvim'
alias v='nvim'

# Git aliases (replacing Oh My Zsh git plugin)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# ===== Initialize Starship Prompt =====
eval "$(starship init zsh)"
