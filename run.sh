#!/bin/bash
#
# Docker container entrypoint
#

set -eo pipefail

echo "rpcuser=${RPC_USER}
rpcpassword=${RPC_PASS}
rpcport=${RPC_PORT}
rpcconnect=${RPC_CONNECT}" > /data/namecoin/namecoin.conf

echo "[log]
level=info
[dns]
port=${DNS_PORT}
oldDNS.address=${OLDDNS_ADDR}
[http]
port=${HTTP_PORT}
tlsPort=${TLS_PORT}
[namecoin]
config=/data/namecoin/namecoin.conf" > /etc/dnschain/dnschain.conf

exec "$@"
