#!/usr/bin/env bash
set -eu

script_dir="$(cd "$(dirname "$0")" && pwd)"
install_path="${INSTALL_PATH:?}"
temp_dir="$(mktemp -d)"
"$script_dir/download-bats-repos.sh" "$temp_dir"

mkdir -p "$install_path"
"$temp_dir/bats-core/install.sh" "$install_path"

install_library() {
  local repository="$1"

  mkdir -p "$install_path/$repository"
  if [ "$repository" = bats-detik ]; then
    cp -R "$temp_dir/$repository/lib/." "$install_path/$repository/"
  else
    cp -R "$temp_dir/$repository"/{load.bash,src} \
      "$install_path/$repository/"
  fi
}

install_library bats-support
install_library bats-assert
install_library bats-detik
install_library bats-file

rm -rf "$temp_dir"
