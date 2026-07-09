#!/usr/bin/env bash
set -eu

repo="${1:?Usage: $0 <repo> <version> <sha256> <target-directory>}"
version="${2:?Usage: $0 <repo> <version> <sha256> <target-directory>}"
expected_sha256="${3:?Usage: $0 <repo> <version> <sha256> <target-directory>}"
tempdir="${4:?Usage: $0 <repo> <version> <sha256> <target-directory>}"

url="https://github.com/${repo}/archive/refs/tags/v${version}.tar.gz"
archive="${tempdir}.tar.gz"

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

echo "Downloading $url to $tempdir" >&2
mkdir -p "$(dirname "$archive")"
curl "${curl_args[@]}" --output "$archive" "$url"

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

mkdir -p "$tempdir"
tar xzf "$archive" -C "$tempdir" --strip-components 1
rm -f "$archive"

echo "${repo} v${version} downloaded to ${tempdir}" >&2
