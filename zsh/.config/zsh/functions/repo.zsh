# check repo project source status
function rstt() {
  repo status | rg -v "project .* branch" -B1
}

# check repo project branch status
function rsbb() {
  repo forall -c bash -c \
    '[[ $(git branch | wc -l) -gt 1 \
    || -z $(git branch --show-current) \
    || $(git status -sb | rg "ahead|behind" &>/dev/null; echo $?) -eq 0 ]] && \
      echo -e "\n\033[1;31mproject $REPO_PATH/\033[0m" && git branch -vv'
}

# fetch repo project and check branch status
function rsff() {
  repo forall -c git fetch && rsbb
}
