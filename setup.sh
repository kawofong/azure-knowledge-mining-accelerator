#!/usr/bin/env bash
#
#  - Setup script for Azure Cognitive Search solution accelerator
#
# Usage:
#
#  AZ_SUBSCRIPTION_ID='XXXX-XXXX' AZ_BASE_NAME='akm' ./setup.sh
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
AZ_SUBSCRIPTION_ID="${AZ_SUBSCRIPTION_ID:-1234}"                  # Azure subscription id
ARM_TEMPLATE_PATH="${ARM_TEMPLATE_PATH:-./arm/azuredeploy.json}"  # File path to Azure environment ARM template
AZ_REGION="${AZ_REGION:-eastus}"                                  # Azure region
AZ_BASE_NAME="${AZ_BASE_NAME:-akm}"                               # Base name for Azure resources


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

if ! [ -x "$(command -v az)" ]; then
  error "command not found: az. Please install Azure CLI before executing this setup script. See https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest to install Azure CLI."
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  error "command not found: jq. Please install jq before executing this setup script."
  exit 1
fi

az_rg_name="${AZ_BASE_NAME}-rg"

info "Initiating login to Azure"
az login > /dev/null
info "Successfully login to Azure"

info "Setting Az CLI subscription context to '${AZ_SUBSCRIPTION_ID}'"
az account set \
--subscription "${AZ_SUBSCRIPTION_ID}"

info "Creating resource group '${az_rg_name}' in region '${AZ_REGION}'"
az group create \
--subscription "${AZ_SUBSCRIPTION_ID}" \
--location "${AZ_REGION}" \
--name "${az_rg_name}" 1> /dev/null

info "Validating ARM template '${ARM_TEMPLATE_PATH}' deployment to resource group '${az_rg_name}'"
az deployment group validate \
--resource-group "${az_rg_name}" \
--template-file "${ARM_TEMPLATE_PATH}" \
--parameters baseName="${AZ_BASE_NAME}" > /dev/null

if [ $? -eq 0 ]; then
  info "ARM template validation passes"
else
  error "ARM template validation fails. Exiting.."
  exit 1
fi

info "Deploying ARM template '${ARM_TEMPLATE_PATH}' deployment to resource group '${az_rg_name}'"
arm_template_output=$(az deployment group create \
--resource-group "${az_rg_name}" \
--template-file "${ARM_TEMPLATE_PATH}" \
--parameters baseName="${AZ_BASE_NAME}" | jq ".properties.outputs")
echo $arm_template_output | jq
info "ARM template deployment finishes"

azure_blob_name=$(echo $arm_template_output | jq -r '.azureBlobName.value' )
azure_blob_conn_str=$(echo $arm_template_output | jq -r '.azureBlobConnectionString.value' )
# echo $azure_blob_conn_str
azure_cogsearch_name=$(echo $arm_template_output | jq -r '.azureCognitiveSearchName.value' )
# echo $azure_cogsearch_name
azure_cogsearch_key=$(echo $arm_template_output | jq -r '.azureCognitiveSearchKey.value' )
# echo $azure_cogsearch_key
azure_cogservice_key=$(echo $arm_template_output | jq -r '.azureCognitiveServiceKey.value' )
azure_formrec_name=$(echo $arm_template_output | jq -r '.azureFormRecognizerName.value' )
azure_formrec_key=$(echo $arm_template_output | jq -r '.azureFormRecognizerKey.value' )
# echo $azure_cogservice_key
azure_function_name=$(echo $arm_template_output | jq -r '.azureFunctionName.value' )
# echo $azure_function_name

# Create blob containers
info "Creating 'raw' and 'enriched' blob containers"
az storage container create -n raw \
--connection-string "${azure_blob_conn_str}"
az storage container create -n enriched \
--connection-string "${azure_blob_conn_str}"

# Copy data to blob "raw" container
info "Copying sample data to 'raw' blob container"
az storage copy --source-local-path ./data/travel_collateral \
--destination-account-name "${azure_blob_name}" \
--destination-container raw \
--recursive
az storage copy --source-local-path ./data/invoice \
--destination-account-name "${azure_blob_name}" \
--destination-container raw \
--recursive

# Train form recognizer model
info "Creating SAS token for blob"
end=`date -u -d "1 month" '+%Y-%m-%dT%H:%MZ'`
blob_sas_token=$(az storage account generate-sas \
--permissions lr \
--account-name "${azure_blob_name}" \
--services b \
--resource-types co \
--expiry $end \
--connection-string "${azure_blob_conn_str}" \
-o tsv)
blob_sas_url="https://${azure_blob_name}.blob.core.windows.net/raw?${blob_sas_token}"

info "Executing setup_form_recognizer.sh"
export FORM_REC_NAME=$azure_formrec_name
export FORM_REC_KEY=$azure_formrec_key
export BLOB_SAS_URL=$blob_sas_url
./scripts/setup_form_recognizer.sh

# Configure Azure function custom skill
info "Configuring custom skill hosted on Azure function"
az functionapp config appsettings set \
--name "$azure_function_name" \
--resource-group "${az_rg_name}" \
--settings "FORMS_RECOGNIZER_ENDPOINT_URL=https://${azure_formrec_name}.cognitiveservices.azure.com" 1> /dev/null
az functionapp config appsettings set \
--name "$azure_function_name" \
--resource-group "${az_rg_name}" \
--settings "FORMS_RECOGNIZER_API_KEY=${azure_formrec_key}" 1> /dev/null
az functionapp config appsettings set \
--name "$azure_function_name" \
--resource-group "${az_rg_name}" \
--settings "FORMS_RECOGNIZER_MODEL_ID=${FORM_REC_MODEL_ID}" 1> /dev/null

# Setup cognitive search
info "Retrieving function key for Azure function"
function_name='analyze-form'
function_resource_id="/subscriptions/${AZ_SUBSCRIPTION_ID}/resourceGroups/${az_rg_name}/providers/Microsoft.Web/sites/${azure_function_name}/functions/${function_name}"
function_key=$(az rest \
--method post \
--uri "https://management.azure.com${function_resource_id}/listKeys?api-version=2018-11-01" \
| jq -r '.default')

info "Executing setup_cognitive_search.sh"
export COG_SEARCH_NAME=$azure_cogsearch_name
export COG_SEARCH_KEY=$azure_cogsearch_key
export BLOB_CONN_STR=$azure_blob_conn_str
export COG_SERVICE_KEY=$azure_cogservice_key
export FUNCTION_URL="https://${azure_function_name}.azurewebsites.net/api/${function_name}?code=${function_key}"
./scripts/setup_cognitive_search.sh

info "Knowledge mining solution accelerator setup complete!"
