#!/usr/bin/env bash
#
# Produce a semver-compliant version string derived from `git describe`.
#
# Mapping from `git describe --tags --always --dirty`:
#   v0.5.0                       -> v0.5.0
#   v0.5.0-dirty                 -> v0.5.0-dev+dirty
#   v0.5.0-7-g420d428            -> v0.5.0-dev+7.g420d428
#   v0.5.0-7-g420d428-dirty      -> v0.5.0-dev+7.g420d428.dirty
#   420d428      (no-tag fallback) -> 0.0.0-dev+g420d428
#   420d428-dirty                  -> 0.0.0-dev+g420d428.dirty
#
set -euo pipefail

desc=$(git describe --tags --always --dirty)

is_dirty=0
if [[ "$desc" == *-dirty ]]; then
    is_dirty=1
    desc="${desc%-dirty}"
fi

if [[ "$desc" =~ ^(.+)-([0-9]+)-g([0-9a-f]+)$ ]]; then
    tag="${BASH_REMATCH[1]}"
    n="${BASH_REMATCH[2]}"
    hash="${BASH_REMATCH[3]}"
    out="${tag}-dev+${n}.g${hash}"
    [[ $is_dirty -eq 1 ]] && out="${out}.dirty"
elif [[ "$desc" =~ ^[0-9a-f]+$ ]]; then
    out="0.0.0-dev+g${desc}"
    [[ $is_dirty -eq 1 ]] && out="${out}.dirty"
else
    if [[ $is_dirty -eq 1 ]]; then
        out="${desc}-dev+dirty"
    else
        out="${desc}"
    fi
fi

echo "$out"
