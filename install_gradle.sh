#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2016-08-01 10:17:55 +0100 (Mon, 01 Aug 2016)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -eu
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$srcdir/utils.sh"

section "Gradle Install"

GRADLE_VERSION=${GRADLE_VERSION:-2.14.1}

BASE=/opt

date
start_time="$(date +%s)"
echo

if ! [ -e "$BASE/gradle" ]; then
    mkdir -p "$BASE"
    cd "$BASE"
    wget -t 100 --retry-connrefused "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip"
    unzip "gradle-$GRADLE_VERSION-bin.zip"
    ln -sv gradle-$GRADLE_VERSION gradle && \
    rm -f gradle-$GRADLE_VERSION-bin.zip
    echo
    echo "Gradle Install done"
else
    echo "$BASE/gradle already exists - doing nothing"
fi
if ! [ -e /etc/profile.d/gradle.sh ]; then
    echo "Adding /etc/profile.d/gradle.sh"
    # shell execution tracing comes out in the file otherwise
    set +x
    cat >> /etc/profile.d/gradle.sh <<EOF
export GRADLE_HOME=/opt/gradle
export PATH=\$PATH:\$GRADLE_HOME/bin
EOF
fi

echo
date
echo
end_time="$(date +%s)"
# if start and end time are the same let returns exit code 1
let time_taken=$end_time-$start_time || :
echo "Completed in $time_taken secs"
echo
section2 "Gradle Install Completed"
echo
