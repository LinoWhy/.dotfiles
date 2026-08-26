#!/usr/bin/env bash

set -euo pipefail

awk '
  function error(message) {
    print message > "/dev/stderr"
    failed = 1
  }

  NR == 1 {
    if ($0 == "") {
      error("empty title")
    }
    if (length($0) > 72) {
      printf "title too long: %d characters\n", length($0) > "/dev/stderr"
      failed = 1
    }
    next
  }

  NR == 2 && $0 != "" {
    error("missing blank line after title")
  }

  {
    if ($0 == "") {
      if (previous_blank) {
        printf "repeated blank line at line %d\n", NR > "/dev/stderr"
        failed = 1
      }
      previous_blank = 1
      next
    }

    previous_blank = 0
    if (length($0) > 80 &&
        $0 !~ /^(Change-Id|Signed-off-by|Fixes|Closes|BREAKING CHANGE):[[:space:]]/) {
      printf "body/footer line too long at %d: %d characters\n", NR, length($0) > "/dev/stderr"
      failed = 1
    }
  }

  END {
    if (NR == 0) {
      error("empty message")
    }
    exit failed
  }
'

printf 'commit message check passed\n'
