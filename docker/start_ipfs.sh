#!/bin/sh
set -e
echo IPFS PATH is $IPFS_PATH
repo="$IPFS_PATH"

# 2nd invocation with regular user
ipfs version

if [ -e "$repo/config" ]; then
  echo "Found IPFS fs-repo at $repo"
else
  ipfs init
  ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
  ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
fi

# if the first argument is daemon
if [ "$1" = "daemon" ]; then
  # filter the first argument until
  # https://github.com/ipfs/go-ipfs/pull/3573
  # has been resolved
  shift
else
  # print deprecation warning
  # go-ipfs used to hardcode "ipfs daemon" in it's entrypoint
  # this workaround supports the new syntax so people start setting daemon explicitly
  # when overwriting CMD, making this PR safe to merge
  echo "DEPRECATED: arguments have been set but the first argument isn't 'daemon'" >&2
  echo "DEPRECATED: run 'docker run ipfs/go-ipfs daemon $@' instead" >&2
  echo "DEPRECATED: see the following PRs for more information:" >&2
  echo "DEPRECATED: * https://github.com/ipfs/go-ipfs/pull/3573" >&2
  echo "DEPRECATED: * https://github.com/ipfs/go-ipfs/pull/3685" >&2
fi

exec ipfs daemon "$@"