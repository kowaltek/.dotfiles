# Enabl
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history-substring-search fzf ssh-agent aws nvm)

# ssh-agent config
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent identities id_rsa id_ed25519
zstyle :omz:plugins:ssh-agent lifetime 4h
zstyle :omz:plugins:ssh-agent quiet yes

# nvm plugin setup
zstyle :omz:plugins:nvm lazy yes

source $ZSH/oh-my-zsh.sh

# User configuration

# moving in search history using history-substring-search
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# vim keybindings
bindkey -v
export KEYTIMEOUT=1 # for faster switch between modes

# open command buffer in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

# add appimage folder to path
export PATH="$HOME/Applications:$PATH"

# add local scripts folder to path
export PATH="$HOME/.local/bin:$PATH"

# make neovim our manpager
# export MANPAGER='nvim --appimage-extract-and-run -c "set ft=man"'

# export MANPATH="/usr/local/man:$MANPATH"

# go configuration
# /usr/local/go/bin path is go tools install path
# while $HOME/go/bin is for tools installed using go install
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

export PATH="$HOME/.govm/shim:$PATH"

# rust configuration
export PATH=$PATH:$HOME/.cargo/bin

# pico sdk configuration
export PICO_SDK_PATH="$HOME/pico/pico-sdk"

# android sdk configuration
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# android-studio configuration
export PATH="$PATH:$HOME/android-studio/bin"

# java configuration
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export PATH=$PATH:$JAVA_HOME/bin

# esp-idf configuration
alias get_idf='. $HOME/esp/esp-idf/export.sh'

# platformio configuration
export PATH=$PATH:$HOME/.platformio/penv/bin

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ll='ls -alF'
alias lg='lazygit'

# update these after system setup
# NEVER COMMIT VALID AUTH TOKENS!!!!!!!!!!!!!!!!!!!
export BW_CLIENTID=""
export BW_CLIENTSECRET=""
export GEMINI_API_KEY="AIzaSyBBkE-hUp1QWlpElvwOA-vTngEjnZVqg4M"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/mk/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# Starship prompt initialization
export STARSHIP_CONFIG=~/.config/starship/starship.toml
# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

# # makes that so when in insert mode, the cursor is a beam '|' instead of block
# cursor_mode() {
#     # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
#     cursor_block='\e[2 q'
#     cursor_beam='\e[6 q'
#
#     function zle-keymap-select {
#         if [[ ${KEYMAP} == vicmd ]] ||
#             [[ $1 = 'block' ]]; then
#             echo -ne $cursor_block
#         elif [[ ${KEYMAP} == main ]] ||
#             [[ ${KEYMAP} == viins ]] ||
#             [[ ${KEYMAP} = '' ]] ||
#             [[ $1 = 'beam' ]]; then
#             echo -ne $cursor_beam
#         fi
#     }
#
#     zle-line-init() {
#         echo -ne $cursor_beam
#     }
#
#     zle -N zle-keymap-select
#     zle -N zle-line-init
# }
#
# cursor_mode


