#!/usr/bin/env bash
set -eu

repo="${1:?Usage: $0 <repo> <version> <sha256> <target-directory>}"
version="${2:?Usage: $0 <repo> <version> <sha256> <target-directory>}"
expected_sha256="${3:?Usage: $0 <repo> <version> <sha256> <target-directory>}"
target_dir="${4:?Usage: $0 <repo> <version> <sha256> <target-directory>}"

url="https://github.com/${repo}/archive/refs/tags/v${version}.tar.gz"
archive="${target_dir}.tar.gz"

echo "Downloading $url to $target_dir" >&2
mkdir -p "$(dirname "$archive")"
curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --retry 4 \
  --retry-connrefused \
  --output "$archive" \
  "$url"

if command -v sha256sum >/dev/null; then
  actual_sha256="$(sha256sum "$archive")"
elif command -v shasum >/dev/null; then
  actual_sha256="$(shasum -a 256 "$archive")"
else
  echo "Could not find sha256sum or shasum" >&2
  rm -f "$archive"
  exit 1
fi
actual_sha256="${actual_sha256%% *}"

if [ "$actual_sha256" != "$expected_sha256" ]; then
  echo "Checksum mismatch for $url" >&2
  echo "Expected: $expected_sha256" >&2
  echo "Actual:   $actual_sha256" >&2
  rm -f "$archive"
  exit 1
fi

mkdir -p "$target_dir"
tar xzf "$archive" -C "$target_dir" --strip-components 1
rm -f "$archive"

echo "${repo} v${version} downloaded to ${target_dir}" >&2
