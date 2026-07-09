#!/usr/bin/env bash
set -eu

target_dir="${1:?Usage: $0 <target-directory>}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
. "$script_dir/bats-versions.sh"

"$script_dir/download-bats-repo.sh" \
  bats-core/bats-core "$BATS_VERSION" "$BATS_SHA256" "$target_dir/bats-core"
"$script_dir/download-bats-repo.sh" \
  bats-core/bats-support "$SUPPORT_VERSION" "$SUPPORT_SHA256" \
  "$target_dir/bats-support"
"$script_dir/download-bats-repo.sh" \
  bats-core/bats-assert "$ASSERT_VERSION" "$ASSERT_SHA256" \
  "$target_dir/bats-assert"
"$script_dir/download-bats-repo.sh" \
  bats-core/bats-detik "$DETIK_VERSION" "$DETIK_SHA256" "$target_dir/bats-detik"
"$script_dir/download-bats-repo.sh" \
  bats-core/bats-file "$FILE_VERSION" "$FILE_SHA256" "$target_dir/bats-file"
