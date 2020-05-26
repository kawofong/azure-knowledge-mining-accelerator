#!/usr/bin/env bash
#
#  - Setup Azure cognitive search by creating data source, skillset, indexer, and indexer
#
# Usage:
#
#  COG_SEARCH_NAME='akm-search' COG_SEARCH_KEY='key' ./setup_cognitive_search.sh
#
# Based on a template by BASH3 Boilerplate v2.3.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace


# Environment variables (and their defaults) that this script depends on
COG_SEARCH_NAME="${COG_SEARCH_NAME:-akm-search}" # Azure cognitive search resource name
COG_SEARCH_KEY="${COG_SEARCH_KEY:-key}"          # Azure cognitive search admin key
BLOB_CONN_STR="${BLOB_CONN_STR:-key}"            # Azure blob connection string
COG_SERVICE_KEY="${COG_SERVICE_KEY:-key}"        # Azure cognitive service admin key

### Functions
##############################################################################

function __b3bp_log () {
  local log_level="${1}"
  shift

  # shellcheck disable=SC2034
  local color_info="\x1b[32m"
  local color_warning="\x1b[33m"
  # shellcheck disable=SC2034
  local color_error="\x1b[31m"

  local colorvar="color_${log_level}"

  local color="${!colorvar:-${color_error}}"
  local color_reset="\x1b[0m"

  if [[ "${NO_COLOR:-}" = "true" ]] || [[ "${TERM:-}" != "xterm"* ]] || [[ ! -t 2 ]]; then
    if [[ "${NO_COLOR:-}" != "false" ]]; then
      # Don't use colors on pipes or non-recognized terminals
      color=""; color_reset=""
    fi
  fi

  # all remaining arguments are to be printed
  local log_line=""

  while IFS=$'\n' read -r log_line; do
    echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" "${log_level}")${color_reset} ${log_line}" 1>&2
  done <<< "${@:-}"
}

function error ()     { __b3bp_log error "${@}"; true; }
function warning ()   { __b3bp_log warning "${@}"; true; }
function info ()      { __b3bp_log info "${@}"; true; }


### Runtime
##############################################################################

if ! [ -x "$(command -v curl)" ]; then
  error "command not found: curl. Please install curl before executing this setup script."
  exit 1
fi


api_version='2019-05-06-Preview'
cog_search_endpoint="https://${COG_SEARCH_NAME}.search.windows.net"
datasource_endpoint="${cog_search_endpoint}/datasources?api-version=${api_version}"
skillset_endpoint="${cog_search_endpoint}/skillsets?api-version=${api_version}"
index_endpoint="${cog_search_endpoint}/indexes?api-version=${api_version}"
indexer_endpoint="${cog_search_endpoint}/indexers?api-version=${api_version}"


info "Substituting parameter values to files"
find . -name '*.json' -exec sed -i -e "s/<blob-connection-string>/${BLOB_CONN_STR//\//\/}/g" {} \;
find . -name '*.json' -exec sed -i -e "s/<cognitive-service-key>/${COG_SERVICE_KEY}/g" {} \;

info "--- Creating collateral AI enrichment pipeline ---"

info "Creating collateral data source"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @collateral/collateral-datasource.json \
  "${datasource_endpoint}" \
  > /dev/null

info "Creating collateral skillset"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @collateral/collateral-skillset.json \
  "${skillset_endpoint}" \
  > /dev/null

info "Creating collateral index"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @collateral/collateral-index.json \
  "${index_endpoint}" \
  > /dev/null

info "Creating collateral indexer"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @collateral/collateral-indexer.json \
  "${indexer_endpoint}" \
  > /dev/null

info "--- Collateral AI enrichment pipeline setup complete ---"


info "--- Creating invoice AI enrichment pipeline ---"

info "Creating invoice data source"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @invoice/invoice-datasource.json \
  "${datasource_endpoint}" \
  > /dev/null

info "Creating invoice skillset"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @invoice/invoice-skillset.json \
  "${skillset_endpoint}" \
  > /dev/null

info "Creating invoice index"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @invoice/invoice-index.json \
  "${index_endpoint}" \
  > /dev/null

info "Creating invoice indexer"
curl --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "api-key: ${COG_SEARCH_KEY}" \
  -d @invoice/invoice-indexer.json \
  "${indexer_endpoint}" \
  > /dev/null

info "--- Invoice AI enrichment pipeline setup complete ---"
