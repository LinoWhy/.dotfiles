#!/usr/bin/env bash
set -euo pipefail

npm install -g @larksuite/cli -y
npx skills add https://github.com/vercel-labs/skills --skill find-skills -y -g
npx skills add larksuite/cli -y -g
