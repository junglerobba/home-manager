#!/bin/sh

if [[ $(pgrep caffeinate) ]]; then
  echo " ☕️"
  exit 0
fi
echo ""
