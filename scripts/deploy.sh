#!/usr/bin/env bash

set -eo pipefail

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
jailedCitizens=23487195805935260354348650824724952235377320432154855752878351301067508033245
citizensFacingGuillotine=23487195805935260354348650824724952235377320432154855752878351298868484767794
beheadedCitizens=23487195805935260354348650824724952235377320432154855752878351297768973139969
OpenSeaStorefrontAddress=$(deploy OpenSeaStorefront)
CitizenNFTAddress=$(deploy CitizenNFT ${OpenSeaStorefrontAddress} ${jailedCitizens} ${citizensFacingGuillotine} ${beheadedCitizens})
log "Opensea Storefront deployed at ${OpenSeaStorefrontAddress}"
log "CityDAO citizen deployed at:" $CitizenNFTAddress
