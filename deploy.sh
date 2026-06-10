#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Checking GitHub authentication..."
gh auth status -h github.com

echo "Creating repository (if needed) and pushing..."
if ! gh repo view soletp2/pavlo-soletskyi-site &>/dev/null; then
  gh repo create pavlo-soletskyi-site --public \
    --description "Personal website for Pavlo Soletskyi" \
    --source=. --remote=origin --push
else
  git push -u origin main
fi

echo ""
echo "Deployment workflow triggered. Watching latest run..."
sleep 5
gh run list --workflow=deploy.yml --limit 1
echo ""
echo "Site URL (after workflow completes):"
echo "  https://soletp2.github.io/pavlo-soletskyi-site/"
echo ""
echo "Ensure GitHub Pages source is set to 'GitHub Actions' in repo Settings → Pages."
