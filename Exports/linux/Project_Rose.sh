#!/bin/sh
echo -ne '\033c\033]0;Project_Rose\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Project_Rose.x86_64" "$@"
