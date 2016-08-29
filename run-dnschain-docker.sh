#!/bin/bash
#
# Create docker container
#

# Help function
function show_help() {
   echo
   echo "Invalid number of arguments."
   echo "Usage: ./$(basename "$0") <namecoin_container>"
   echo
}

# Verify arguments
if [ $# -ne 1 ] ; then
    show_help
    exit 1
fi

# Docker image
IMG="zekaf/dnschain"
TAG="latest"

# Docker DNSChain container
DNSCHAIN_CT="dnschain"
DNSCHAIN_IP="10.17.0.3"

# Docker network
NET_NAME="isolated_nw"

# Docker Namecoin container
NMC_CT="$1"
NMC_CONF="/data/namecoin/namecoin.conf"

# Namecoin configuration
RPC_USER=$(docker exec $NMC_CT cat $NMC_CONF | grep rpcuser | awk -F '[/=]' '{print $2}')
RPC_PASS=$(docker exec $NMC_CT cat $NMC_CONF | grep rpcpassword | awk -F '[/=]' '{print $2}')
RPC_PORT=$(docker exec $NMC_CT cat $NMC_CONF | grep rpcport | awk -F '[/=]' '{print $2}')
RPC_CONNECT=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $NMC_CT)

# DNSChain configuration
OLDDNS_ADDR="10.17.0.4" # we recommend running PowerDNS yourself and sending it there
OLDDNS_PORT="53"

# Create docker container
docker run -d \
  --net $NET_NAME --ip $DNSCHAIN_IP \
  --name $DNSCHAIN_CT \
  --restart=always \
  -e OLDDNS_ADDR=$OLDDNS_ADDR \
  -e OLDDNS_PORT=$OLDDNS_PORT \
  -e RPC_USER=$RPC_USER \
  -e RPC_PASS=$RPC_PASS \
  -e RPC_PORT=$RPC_PORT \
  -e RPC_CONNECT=$RPC_CONNECT \
  $IMG:$TAG
