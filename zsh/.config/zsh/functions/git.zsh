# push to current tracking remote branch on gerrit
function ggp() {
  remote_name=$(git remote)
  branch_name=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} | awk -F'/' '{print substr($0, index($0,$2))}')

  yellow='\033[1;33m'
  reset='\033[0m'

  # Check if branch name is non-empty
  if [[ -n "$branch_name" ]]; then
    echo "${yellow}pushing to $remote_name $branch_name${reset}"
    git push $remote_name HEAD:refs/for/$branch_name
  else
    echo "Error: Cannot determine the remote branch to push."
  fi
}

# detect lfs repo and pull under $1 or $PWD
function gplfs() {
  local directory="${1:-$PWD}"
  rg -l -F "merge=lfs" --glob=".gitattributes" | while IFS= read -r line; do
    local dir=$(dirname "$line")
    echo "git lfs pull for \"$dir\""
    (cd "$dir" || exit ; git lfs pull)
  done
}

# shallow fetch a remote branch, works within a shallow gloned repo
function gsf() {
  git fetch --depth=1 origin "$1:$1"
  git switch "$1"
}
