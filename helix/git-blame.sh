#!/usr/bin/env bash

cursor_line=${1:?}
buffer_name=${2:?}

sha=$(git blame -p -L "${cursor_line}",+1 "${buffer_name}" | head -n1 | cut -d " " -f1)

git show "${sha}" --format=format:"%h %C(yellow)%ae %C(cyan)%ar %C(red)%s" --no-patch
