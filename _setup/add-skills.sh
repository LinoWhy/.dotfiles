#!/usr/bin/env bash
set -euo pipefail

npx --yes skills@latest add https://github.com/vercel-labs/skills --skill find-skills --yes --global
npx --yes skills@latest add https://github.com/github/awesome-copilot --skill git-commit --yes --global
npx --yes skills@latest add mattpocock/skills --yes --global

npx --yes @larksuite/cli@latest install
