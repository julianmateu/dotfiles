###############################################################
# Author: Julian Mateu - julianmateu@gmail.com
#
# Sections:
#    -> Environment variables
#    -> Plugins
#    -> External files
#    -> Options
#    -> Functions
#    -> Aliases
#    -> Key bindings
#
###############################################################

###############################################################
# => Environment variables
###############################################################
zmodload zsh/zprof

export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="julianmateu"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

# Lazy load NVM: https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
###############################################################
# => Plugins
###############################################################
plugins=(
    zsh-nvm
    git
    bundler
    dotenv
    macos
    rake
    zsh-autosuggestions
    last-working-dir
    web-search
    cloudfoundry
    zsh-syntax-highlighting
    zsh-history-substring-search
    history
    sudo
    yarn
    z
)

###############################################################
# => External files
###############################################################
source "${ZSH}/oh-my-zsh.sh"

## Source NVM
[[ -s ${HOME}/.nvm/nvm.sh ]] && . ${HOME}/.nvm/nvm.sh

###############################################################
# => Options
###############################################################
setopt correct

###############################################################
# => Functions
###############################################################
function gcpr {
  # Create a PR in github for the current branch
  if [ $? -eq 0 ]; then
        github_url=$(git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@' -e 's%\.git$%%')
        branch_name=$(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)
        pr_url=${github_url}"/compare/master..."${branch_name}
        open ${pr_url}
    else
        echo 'failed to open a pull request.'
    fi
}

function grebase() {
  PREVIOUS_BRANCH="$(git branch --show-current)"
  git checkout "$(git_main_branch)"
  git pull
  git checkout "${PREVIOUS_BRANCH}"
  git rebase "$(git_main_branch)"
}

commands() {
    awk '{a[$2]++}END{for(i in a){print a[i] " " i}}'
}

bashman() {
    man bash | less -p "^       ${1} "
}

function precmd() {
    if [[ "$(which kubectl)" ]]; then
        current_kubecontext="$(kubectl config current-context | awk -F'/' '{print $NF}')"
    fi
}

###############################################################
# => Aliases
###############################################################
[[ -f "${HOME}/.aliases.zsh" ]] && source "${HOME}/.aliases.zsh"

###############################################################
# => Key bindings
###############################################################
# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "${terminfo}[kcuu1]" history-substring-search-up
bindkey "${terminfo}[kcud1]" history-substring-search-down

# Enable vi mode:
bindkey -v
