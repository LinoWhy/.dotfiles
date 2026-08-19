#!/usr/bin/env bash
set -euo pipefail

npx --yes skills@latest add https://github.com/vercel-labs/skills --skill find-skills --yes --global
npx skills@latest add mattpocock/skills --global

npx --yes @larksuite/cli@latest install
