# check repo project source status
function rstt() {
  repo status | rg -v "project .* branch" -B1
}

# check repo project branch status
function rsbb() {
  repo forall -pc git branch -vv | rg "behind|ahead|change-" -B1
}
