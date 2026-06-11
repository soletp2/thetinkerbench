#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Fixing git repository..."
if [[ -f .git && ! -d .git ]]; then
  # .git is a gitdir pointer from a prior sandbox session
  GITDIR=$(awk '/^gitdir:/{print $2}' .git)
  rm -f .git
  cp -R "$GITDIR" .git
elif [[ ! -d .git ]]; then
  git init -b main
fi

git status
git log --oneline -3 || true

echo ""
echo "==> Checking GitHub auth..."
gh auth status -h github.com

echo ""
echo "==> Creating repository (if needed) and pushing..."
if ! gh repo view soletp2/thetinkerbench &>/dev/null; then
  gh repo create thetinkerbench --public \
    --description "Personal website for Pavlo Soletskyi" \
    --source=. --remote=origin --push
else
  git remote get-url origin &>/dev/null || \
    git remote add origin https://github.com/soletp2/thetinkerbench.git
  git push -u origin main
fi

echo ""
echo "==> Checking GitHub Pages is enabled..."
if ! gh api repos/soletp2/thetinkerbench/pages &>/dev/null; then
  echo ""
  echo "Pages is NOT enabled yet. Do this once in your browser:"
  echo "  1. Open https://github.com/soletp2/thetinkerbench/settings/pages"
  echo "  2. Under 'Build and deployment', set Source to 'GitHub Actions'"
  echo "  3. Also open https://github.com/soletp2/thetinkerbench/settings/actions"
  echo "     and set Workflow permissions to 'Read and write permissions'"
  echo ""
  echo "Then run: git push   (or: gh workflow run deploy.yml)"
  exit 1
fi

echo ""
echo "==> Triggering deploy workflow..."
gh workflow run deploy.yml 2>/dev/null || true

echo ""
echo "==> Waiting for GitHub Actions deploy..."
sleep 15
gh run list --workflow=deploy.yml --limit 3

echo ""
echo "Site URL (after workflow completes):"
echo "  https://soletp2.github.io/thetinkerbench/"
