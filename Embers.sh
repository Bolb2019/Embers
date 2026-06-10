#!/bin/sh
printf '\033c\033]0;%s\a' Embers
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Embers.x86_64" "$@"
