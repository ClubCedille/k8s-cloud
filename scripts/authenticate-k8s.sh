#!/usr/bin/env bash
set -euo pipefail

# Configuration
OUTPUT_FILE="${OUTPUT_FILE:-config.yaml}"
CHECK_INTERVAL="${CHECK_INTERVAL:-5m}"
CERTIFICATE_EXPIRATION_THRESHOLD="${CERTIFICATE_EXPIRATION_THRESHOLD:-48h}"

# Kubernetes contexts to scan
CONTEXTS=(
  cedille-k8s-shared
  cedille-k8s-management-v2
  cedille-k8s-cedille-production-v2
)

# Temporary file to store all discovered endpoints
TEMP_ENDPOINTS=$(mktemp)

echo "🔍 Discovering endpoints across clusters..."

# Discover endpoints from all clusters
for ctx in "${CONTEXTS[@]}"; do
  echo "Fetching kubeconfig for ${ctx}"
  omnictl kubeconfig --cluster ${ctx} --grant-type=authcode-keyboard
done
