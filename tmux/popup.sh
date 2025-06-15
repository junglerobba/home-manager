width=${2:-100%}
height=${2:-80%}
prefix=popup

session_name=$(tmux display-message -p -F "#{session_name}")
if [[ $session_name == *"${prefix}"* ]]; then
  tmux detach-client
else
  tmux popup -d '#{pane_current_path}' -xC -y 0 -w"${width}" -h"${height}" -E "tmux attach -t ${prefix}-${session_name} || tmux new -s ${prefix}-${session_name}"
fi
