#!/usr/bin/env bash
set -euo pipefail

npx --yes skills@latest add https://github.com/vercel-labs/skills --skill find-skills --yes --global
npx skills@latest add mattpocock/skills --global

npx --yes skills@latest add plannotator/effective-html --skill html --yes --global
npx --yes skills@latest add lewislulu/html-ppt-skill --skill html-ppt --yes --global
npx --yes skills@latest add anthropics/skills --skill frontend-design --yes --global

npx --yes @larksuite/cli@latest install
