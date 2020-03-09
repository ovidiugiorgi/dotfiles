# OSX antigen file
source $HOME/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load the theme
# antigen theme robbyrussell
# antigen theme denysdovhan/spaceship-prompt
# antigen theme tobyjamesthomas/pi
# antigen theme gschnall/leverage
# antigen theme halfo/lambda-mod-zsh-theme
antigen theme ergenekonyigit/lambda-gitster

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle brew
antigen bundle common-aliases
antigen bundle compleat
antigen bundle git-extras
antigen bundle git-flow
antigen bundle npm
antigen bundle osx
antigen bundle web-search
antigen bundle z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh
antigen bundle zsh-users/zsh-autosuggestions

# NVM bundle
export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm
antigen bundle Sparragus/zsh-auto-nvm-use

# Tell Antigen that you're done.
antigen apply

# Load custom aliases
[[ -s "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
alias swagger="docker run --rm -it -e GOPATH=$HOME/go:/go -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger"

# Custom Binaries
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/Users/ovidiugiorgi/Documents/redis-5.0.7/src:$PATH"
export PATH="$GOBIN:$PATH"
