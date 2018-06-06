#!/usr/bin/env bash

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LH_ROOT="$DIRNAME/../.."
cd $LH_ROOT

set -e

# Testing lantern can be expensive, we'll only run the tests if we touched files that affect the simulations.
CHANGED_FILES=""
if [[ "$CI" ]]; then
  CHANGED_FILES=$(git --no-pager diff --name-only $TRAVIS_COMMIT_RANGE)
else
  CHANGED_FILES=$(git --no-pager diff --name-only master)
fi

printf "Determined the following files have been touched:\n\n$CHANGED_FILES\n\n"

if ! echo $CHANGED_FILES | grep -E 'dependency-graph|metrics|lantern' > /dev/null; then
  echo "No lantern files affected, skipping lantern checks."
  exit 0
fi

printf "Lantern files affected!\n\nDownloading test set...\n"
"$LH_ROOT/lighthouse-core/scripts/lantern/download-traces.sh"

printf "\n\nRunning all expectations...\n"
"$LH_ROOT/lighthouse-core/scripts/lantern/run-all-expectations.js"

printf "\n\n"
"$LH_ROOT/lighthouse-core/scripts/lantern/evaluate-results.js"

printf "\n\nComparing to golden expectations...\n"
"$LH_ROOT/lighthouse-core/scripts/lantern/diff-expectations.js"