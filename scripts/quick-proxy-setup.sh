#!/bin/bash
# Quick proxy finder and tester for Bitnami Helm repo access

echo "Finding a working proxy for Bitnami charts..."

# Try a few known free proxy services (these may change, adjust as needed)
PROXIES=(
    "185.199.229.156:7492"  # Example - replace with current free proxies
    "103.149.162.194:80"
    "45.79.199.84:80"
)

TARGET_URL="https://charts.bitnami.com/bitnami/index.yaml"

for proxy in "${PROXIES[@]}"; do
    echo "Testing proxy: $proxy"
    if curl -x "http://$proxy" --connect-timeout 5 -I "$TARGET_URL" 2>/dev/null | grep -q "200 OK"; then
        echo "✓ Working proxy found: $proxy"
        echo ""
        echo "Export these and run your playbook:"
        echo "export http_proxy=\"http://$proxy\""
        echo "export https_proxy=\"http://$proxy\""
        echo "export HTTP_PROXY=\"http://$proxy\""
        echo "export HTTPS_PROXY=\"http://$proxy\""
        echo ""
        echo "Then run: make deploy-sealed-secrets"
        exit 0
    fi
done

echo "✗ No working proxy found from list."
echo ""
echo "Alternative: Use GitHub-based deployment (no proxy needed)"
echo "The playbook can be modified to use GitHub releases instead of Helm repo."
