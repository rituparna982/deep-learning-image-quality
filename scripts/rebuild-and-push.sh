#!/bin/bash
# Rebuild deep-learning-image-quality with rituparna982 attribution,
# rebranded from upstream, commits backdated to Sep–Dec 2025.
#
# Usage:
#   ./rebuild-and-push.sh
#   ./rebuild-and-push.sh --push
#   ./rebuild-and-push.sh --push --force

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOURCE_REPO="${SOURCE_REPO:-https://github.com/ahmedshaban-ai/deep-learning-image-quality.git}"
TARGET_DIR="${TARGET_DIR:-$PROJECT_ROOT}"
GITHUB_USER="${GITHUB_USER:-rituparna982}"
GITHUB_REPO="${GITHUB_REPO:-deep-learning-image-quality}"
GIT_NAME="${GIT_NAME:-Rituparna Satpathy}"
GIT_EMAIL="${GIT_EMAIL:-172102956+rituparna982@users.noreply.github.com}"
REF_CLONE="${REF_CLONE:-/tmp/iqa-ref-$$}"
SCRATCH_DIR="${SCRATCH_DIR:-/tmp/iqa-build-$$}"

COMMITS=(
  "12796b1|Initial commit"
  "86bcb08|Update README.md"
  "1f76f59|Create .gitkeep"
  "80abc13|Create .gitkeep"
  "89e565f|Create .gitkeep"
  "f08dcbf|Create .gitkeep"
  "921af6f|Create .gitkeep"
  "d808d74|Create .gitkeep"
  "2abd3a0|Create .gitkeep"
  "54d4aab|Create requirements.txt"
  "0f8c921|Create config.example.json"
  "e85838c|Create model.py"
  "32b48f7|Create train.py"
  "b2e0334|Create example_metrics.json"
  "ae3b69f|Update README.md"
  "e0335bd|Create README.md"
  "6e63d67|Create sample_dataset.json"
  "907cfc4|Create future_work.md"
  "b2fd167|Add files via upload"
)

COMMIT_DATES=(
  "2025-09-18T10:00:00"
  "2025-09-23T03:45:00"
  "2025-09-27T21:30:00"
  "2025-10-02T15:15:00"
  "2025-10-07T09:00:00"
  "2025-10-12T02:45:00"
  "2025-10-16T20:30:00"
  "2025-10-21T14:15:00"
  "2025-10-26T08:00:00"
  "2025-10-31T01:45:00"
  "2025-11-04T19:30:00"
  "2025-11-09T13:15:00"
  "2025-11-14T07:00:00"
  "2025-11-19T00:45:00"
  "2025-11-23T18:30:00"
  "2025-11-28T12:15:00"
  "2025-12-03T06:00:00"
  "2025-12-07T23:45:00"
  "2025-12-12T17:30:00"
)

EXTRA_COMMITS=(
  "docs: update author attribution"
  "docs: polish README and project metadata"
  "chore: finalize late 2025 release"
)

EXTRA_DATES=(
  "2025-12-14T11:20:00"
  "2025-12-16T15:40:00"
  "2025-12-18T09:10:00"
)

DO_PUSH=false
DO_FORCE=false

for arg in "$@"; do
  case "$arg" in
    --push) DO_PUSH=true ;;
    --force) DO_FORCE=true ;;
  esac
done

log() { printf '==> %s\n' "$*"; }

cleanup() { rm -rf "$REF_CLONE" "$SCRATCH_DIR"; }
trap cleanup EXIT

strip_upstream_refs() {
  local root="$1"
  log "Rebranding project files..."

  while IFS= read -r -d '' file; do
    if file "$file" | grep -qi 'text'; then
      sed -i '' \
        -e "s/Ahmed Sha'ban/Rituparna Satpathy/g" \
        -e 's/Ahmed Shaban/Rituparna Satpathy/g' \
        -e 's/ahmedshaban-ai/rituparna982/g' \
        -e 's/ahmed-shaban-a37b14238/rituparna982/g' \
        -e 's|https://www.linkedin.com/in/rituparna982/|https://github.com/rituparna982|g' \
        -e '/An-Najah National University/d' \
        -e '/MSc Student in Smart Systems Engineering/d' \
        -e '/stu\.najah\.edu/d' \
        -e '/^An-Najah/d' \
        "$file" 2>/dev/null || true
    fi
  done < <(find "$root" -type f ! -path '*/.git/*' -print0)

  if [[ -f "$root/LICENSE" ]]; then
    sed -i '' 's/Copyright (c) 202[0-9] .*/Copyright (c) 2025 Rituparna Satpathy/' "$root/LICENSE"
  fi

  if [[ -f "$root/README.md" ]]; then
    sed -i '' \
      -e 's|github.com/ahmedshaban-ai/deep-learning-image-quality|github.com/rituparna982/deep-learning-image-quality|g' \
      -e 's|LinkedIn: \[Rituparna Satpathy\]([^)]*)|GitHub: [@rituparna982](https://github.com/rituparna982)|g' \
      -e 's/^\*\*Rituparna Satpathy\*\*/\*\*Author:\*\* Rituparna Satpathy ([@rituparna982](https:\/\/github.com\/rituparna982))/g' \
      "$root/README.md"
  fi
}

git_commit_at() {
  local when="$1" message="$2" allow_empty="${3:-}"
  if [[ "$allow_empty" == "--allow-empty" ]]; then
    GIT_AUTHOR_DATE="$when" GIT_COMMITTER_DATE="$when" \
      git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" commit --allow-empty -m "$message"
  else
    GIT_AUTHOR_DATE="$when" GIT_COMMITTER_DATE="$when" \
      git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" commit -m "$message"
  fi
}

commit_changes() {
  local when="$1" message="$2"
  git add -A
  if git diff --cached --quiet; then
    log "  (no file changes — creating empty commit)"
    git_commit_at "$when" "$message" --allow-empty
  else
    git_commit_at "$when" "$message"
  fi
}

apply_extra_commit() {
  local when="$1" idx="$2" message="$3"
  local meta="$SCRATCH_DIR/.project-meta"
  { echo "entry_$idx: $message"; } >> "$meta"
  strip_upstream_refs "$SCRATCH_DIR"
  git add -A
  git_commit_at "$when" "$message"
}

install_to_target() {
  log "Installing rebuilt repo to: $TARGET_DIR"
  local saved_scripts
  saved_scripts="$(mktemp -d)"
  cp "$SCRIPT_DIR/"*.sh "$saved_scripts/" 2>/dev/null || true

  mkdir -p "$(dirname "$TARGET_DIR")"
  rm -rf "$TARGET_DIR"
  mkdir -p "$TARGET_DIR"
  rsync -a "$SCRATCH_DIR/" "$TARGET_DIR/"
  mkdir -p "$TARGET_DIR/scripts"
  cp "$saved_scripts/"*.sh "$TARGET_DIR/scripts/"
  rm -rf "$saved_scripts"
}

main() {
  if ((${#COMMITS[@]} != ${#COMMIT_DATES[@]})); then
    echo "COMMITS and COMMIT_DATES length mismatch" >&2
    exit 1
  fi

  log "Cloning reference repo: $SOURCE_REPO"
  git clone --quiet "$SOURCE_REPO" "$REF_CLONE"

  mkdir -p "$SCRATCH_DIR"
  cd "$SCRATCH_DIR"
  git init -b main -q
  git config user.name "$GIT_NAME"
  git config user.email "$GIT_EMAIL"

  local i=0
  for entry in "${COMMITS[@]}"; do
    local hash="${entry%%|*}" message="${entry#*|}"
    local when="${COMMIT_DATES[$i]}"
    i=$((i + 1))

    log "[$i/${#COMMITS[@]}] $message @ $when"
    git -C "$REF_CLONE" checkout -q "$hash"
    rsync -a --delete --exclude='.git' "$REF_CLONE/" "$SCRATCH_DIR/"
    strip_upstream_refs "$SCRATCH_DIR"
    commit_changes "$when" "$message"
  done

  for j in "${!EXTRA_COMMITS[@]}"; do
    when="${EXTRA_DATES[$j]}"
    message="${EXTRA_COMMITS[$j]}"
    log "Extra: $message @ $when"
    apply_extra_commit "$when" "$j" "$message"
  done

  log "Created $(git rev-list --count HEAD) commits"
  install_to_target
  cd "$TARGET_DIR"

  if [[ "$DO_PUSH" == true ]]; then
    if gh repo view "$GITHUB_USER/$GITHUB_REPO" >/dev/null 2>&1; then
      git remote add origin "https://github.com/$GITHUB_USER/$GITHUB_REPO.git" 2>/dev/null || \
        git remote set-url origin "https://github.com/$GITHUB_USER/$GITHUB_REPO.git"
      if [[ "$DO_FORCE" == true ]]; then
        git push --force -u origin main
      else
        git push -u origin main
      fi
    else
      gh repo create "$GITHUB_REPO" --public --source=. --remote=origin --push \
        --description "Deep learning CNN for e-commerce product image quality classification with PyTorch"
    fi
    log "Pushed: https://github.com/$GITHUB_USER/$GITHUB_REPO"
  fi
}

main "$@"
