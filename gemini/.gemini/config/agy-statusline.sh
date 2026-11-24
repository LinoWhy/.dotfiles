#!/usr/bin/env bash

exec jq -r '
  def field($color):
    strings | select(length > 0) | gsub("[[:cntrl:]]+"; " ")
    | if $color and (env.NO_COLOR // "") == "" then "\u001b[\($color)m\(.)\u001b[0m" else . end;

  def remaining($label):
    select(. and (.disabled != true))
    | ((.remaining_fraction | numbers | "\(. * 100 | round)%") // .remaining_amount // empty)
    | "\($label) \(.)" | field(35);

  (.model.display_name // .model.id // "") as $model
  | (.model.effort // "") as $effort
  | (.quota // {}) as $quota
  | (if ($model | test("argon"; "i")) and ($quota["gemini-argon-wtu-weekly"] | . and (.disabled != true)) then "gemini-argon-wtu"
     elif ($model | test("gemini|orchestrator"; "i")) then "gemini"
     elif ($model | test("claude|gpt"; "i")) then "3p"
     else "" end) as $group
  | [
      (if $model != "" and $effort != "" and ($model | ascii_downcase | endswith("(\($effort | ascii_downcase))") | not)
       then "\($model) (\($effort))" else $model end | field(36)),
      (.conversation_title | field(null)),
      ((.workspace.current_dir // .cwd) | strings
       | if . == env.HOME then "~" else split("/") | map(select(length > 0)) | last // "/" end | field(34)),
      ($quota["\($group)-5h"] | remaining("5h")),
      ($quota["\($group)-weekly"] | remaining("7d"))
    ]
  | join(" · ")
'
