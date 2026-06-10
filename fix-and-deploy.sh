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
if ! gh repo view soletp2/pavlo-soletskyi-site &>/dev/null; then
  gh repo create pavlo-soletskyi-site --public \
    --description "Personal website for Pavlo Soletskyi" \
    --source=. --remote=origin --push
else
  git remote get-url origin &>/dev/null || \
    git remote add origin https://github.com/soletp2/pavlo-soletskyi-site.git
  git push -u origin main
fi

echo ""
echo "==> Enabling GitHub Pages (Actions source)..."
if ! gh api repos/soletp2/pavlo-soletskyi-site/pages &>/dev/null; then
  gh api repos/soletp2/pavlo-soletskyi-site/pages -X POST -f build_type=workflow
else
  gh api repos/soletp2/pavlo-soletskyi-site/pages -X PUT -f build_type=workflow
fi

echo ""
echo "==> Triggering deploy workflow..."
gh workflow run deploy.yml || gh run rerun --failed

echo ""
echo "==> Waiting for GitHub Actions deploy..."
sleep 15
gh run list --workflow=deploy.yml --limit 3

echo ""
echo "Site URL (after workflow completes):"
echo "  https://soletp2.github.io/pavlo-soletskyi-site/"
