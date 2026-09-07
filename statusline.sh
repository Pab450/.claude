#!/bin/bash
# Claude Code status line: "Model Effort | context: XX% | ponytail: on/off | usage: XX% / 5h, XX% / 7j, reset in: 1h 23m"
# The usage percentages are what has been USED, the same numbers /usage prints.
# Labels and separators keep the bar's own grey, values are bright: the eye lands on the numbers.
input=$(cat)
project_dir=$(jq -r '.workspace.project_dir // empty' <<<"$input")

# ponytail plugin: project settings win over global ones
ponytail=off
for f in "$project_dir/.claude/settings.local.json" "$project_dir/.claude/settings.json" "$HOME/.claude/settings.local.json" "$HOME/.claude/settings.json"; do
  [ -f "$f" ] || continue
  if [ "$(jq -r '.enabledPlugins["ponytail@ponytail"] // false' "$f" 2>/dev/null)" = true ]; then ponytail=on; break; fi
done

DIM=$'\033[0m'
BRIGHT=$'\033[0;97m'
RESET=$'\033[0m'

jq -r --arg ponytail "$ponytail" --arg dim "$DIM" --arg bright "$BRIGHT" --arg reset "$RESET" '
  def v(x): $bright + x + $reset;
  def k(x): $dim + x + $reset;
  def pct(x): if x == null then null else ((x | tonumber) | round | tostring) + "%" end;
  # resets_at may come as epoch seconds, epoch milliseconds, or an ISO string
  def epoch(x): if x == null then null
    elif (x | type) == "number" then (if x > 1000000000000 then x / 1000 else x end)
    else (x | sub("[.][0-9]+"; "") | try fromdateiso8601 catch null) end;
  def left(x): (epoch(x)) as $t | if $t == null then null else
    (($t - now) | floor) as $s | if $s <= 0 then "now"
    elif $s < 3600 then "\(($s / 60) | floor)m"
    else "\(($s / 3600) | floor)h \((($s % 3600) / 60) | floor)m" end end;
  [
    ([.model.display_name, .effort.level] | map(select(. != null)) | join(" ") | select(. != "") | v(.)),
    (pct(.context_window.used_percentage) | select(. != null) | k("context: ") + v(.)),
    (k("ponytail: ") + v($ponytail)),
    ([ (pct(.rate_limits.five_hour.used_percentage) | select(. != null) | v(.) + k(" / 5h")),
       (pct(.rate_limits.seven_day.used_percentage) | select(. != null) | v(.) + k(" / 7j")),
       (left(.rate_limits.five_hour.resets_at) | select(. != null) | k("reset in: ") + v(.)) ]
      | select(length > 0) | k("usage: ") + join(k(", ")))
  ] | map(select(. != null)) | join(k(" | "))
' <<<"$input"
