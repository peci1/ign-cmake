#!/bin/sh

set -x
set -e

SYSTEM_VERSION=`lsb_release -cs`
IGN_VERSION=dome

wget https://raw.githubusercontent.com/ignition-tooling/gazebodistro/master/collection-${IGN_VERSION}.yaml

mkdir deps/src
vcs import deps/src collection-${IGN_VERSION}.yaml

apt -y install \
  $(sort -u $(find . -iname 'packages-'$SYSTEM_VERSION'.apt' -o -iname 'packages.apt') | tr '\n' ' ')

colcon build --symlink-install --merge-install 

colcon build --symlink-install --merge-install --cmake-target codecheck --cmake-target-skip-unavailable --continue-on-error
