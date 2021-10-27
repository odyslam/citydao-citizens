#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
ROYALTY_ADDRESS=$ETH_FROM
ROYALTY=1000
CitizenNFTAddress=$(deploy CitizenNFT $ROYALTY_ADDRESS $ROYALTY)
log "CityDAO citizen deployed at:" $CitizenNFTAddress
