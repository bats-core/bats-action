#!/usr/bin/env bash
set -eu

script_dir="$(cd "$(dirname "$0")" && pwd)"
versions_file="$script_dir/bats-versions.sh"
temp_dir="$(mktemp -d)"

declare -a curl_args=(
  --fail
  --silent
  --show-error
  --location
  --retry 4
  --retry-connrefused
)

if [ -n "${GITHUB_TOKEN:-}" ]; then
  curl_args+=(--header "Authorization: Bearer $GITHUB_TOKEN")
fi

update_repository() {
  local repo="$1"
  local version_variable="$2"
  local sha256_variable="$3"
  local release
  local tag
  local version
  local archive
  local sha256

  release="$(curl "${curl_args[@]}" \
    "https://api.github.com/repos/$repo/releases/latest")"
  tag="$(printf '%s' "$release" |
    sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
    head -n 1)"

  case "$tag" in
    v*) version="${tag#v}" ;;
    *)
      echo "Failed to resolve a v-prefixed release tag for $repo" >&2
      exit 1
      ;;
  esac

  archive="$temp_dir/${repo##*/}.tar.gz"
  curl "${curl_args[@]}" --output "$archive" \
    "https://github.com/$repo/archive/refs/tags/$tag.tar.gz"

  sha256="$(sha256sum "$archive")"
  sha256="${sha256%% *}"
  rm -f "$archive"

  sed -i \
    -e "s/^${version_variable}=.*/${version_variable}=\"$version\"/" \
    -e "s/^${sha256_variable}=.*/${sha256_variable}=\"$sha256\"/" \
    "$versions_file"

  echo "$repo: $version" >&2
}

update_repository "bats-core/bats-core" BATS_VERSION BATS_SHA256
update_repository "bats-core/bats-support" SUPPORT_VERSION SUPPORT_SHA256
update_repository "bats-core/bats-assert" ASSERT_VERSION ASSERT_SHA256
update_repository "bats-core/bats-detik" DETIK_VERSION DETIK_SHA256
update_repository "bats-core/bats-file" FILE_VERSION FILE_SHA256

rmdir "$temp_dir"
