#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-08-15 11:52:44 +0100 (Sat, 15 Aug 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

vagrantfiles="$(find "${1:-.}" -maxdepth 3 -name Vagrantfile)"

if [ -z "$vagrantfiles" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "V a g r a n t"

start_time="$(start_timer)"

if type -P vagrant &>/dev/null; then
    echo "Validating Vagrantfiles:"
    echo
    while read -r vagrantfile; do
        pushd "$(dirname "$vagrantfile")" >/dev/null
        echo -n "$vagrantfile => "
        vagrant validate
        popd >/dev/null
    done <<< "$vagrantfiles"
else
    echo "WARNING: 'vagrant' is not installed, skipping..."
    echo
    exit 0
fi

time_taken "$start_time"
section2 "Vagrantfile validation SUCCEEDED"
echo
