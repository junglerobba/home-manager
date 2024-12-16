#!/bin/sh

CURRENT=$(tmux display-message -p "#S")
POPUP="popup-${CURRENT}"

if tmux has-session -t "${POPUP}";
then
  tmux kill-session -t "${POPUP}"
fi

tms kill
