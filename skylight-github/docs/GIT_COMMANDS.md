# Git Commands Quick Reference

Quick reference for common Git commands used with this project.

## Initial Setup (One Time)

```bash
# Navigate to project
cd /path/to/SkylightShoppingList

# Initialize repository
git init

# Add all files
git add .

# First commit
git commit -m "Initial commit"

# Rename branch to main
git branch -M main

# Add GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/skylight-shopping-list-ios.git

# Push to GitHub
git push -u origin main
```

## Daily Workflow

```bash
# Check status (see what changed)
git status

# Add all changes
git add .

# Add specific file
git add filename.swift

# Commit changes
git commit -m "descriptive message"

# Push to GitHub
git push
```

## Branching

```bash
# Create new branch
git checkout -b feature/new-feature

# Switch branches
git checkout main

# List branches
git branch

# Delete branch
git branch -d feature/old-feature

# Push branch to GitHub
git push -u origin feature/new-feature
```

## Updating from GitHub

```bash
# Pull latest changes
git pull

# Or fetch + merge
git fetch origin
git merge origin/main
```

## Undoing Changes

```bash
# Discard changes in file
git checkout -- filename.swift

# Unstage file
git reset HEAD filename.swift

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1
```

## Viewing History

```bash
# View commit history
git log

# View compact log
git log --oneline

# View specific file history
git log filename.swift

# View changes
git diff
```

## Stashing Changes

```bash
# Stash current changes
git stash

# List stashes
git stash list

# Apply last stash
git stash apply

# Apply and remove stash
git stash pop
```

## Tags & Releases

```bash
# Create tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tags
git push --tags

# List tags
git tag

# Delete tag
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0
```

## Commit Message Conventions

```bash
# Feature
git commit -m "feat: Add barcode scanning"

# Bug fix
git commit -m "fix: Resolve camera crash on iOS 16"

# Documentation
git commit -m "docs: Update API integration guide"

# Style
git commit -m "style: Format code with SwiftLint"

# Refactor
git commit -m "refactor: Simplify scanner service"

# Test
git commit -m "test: Add unit tests for API service"

# Chore
git commit -m "chore: Update dependencies"
```

## Helpful Aliases (Optional)

Add to `~/.gitconfig`:

```bash
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    last = log -1 HEAD
    unstage = reset HEAD --
    visual = log --graph --oneline --all --decorate
```

Then use:
```bash
git st          # instead of git status
git co main     # instead of git checkout main
git ci -m "msg" # instead of git commit -m "msg"
```

## Troubleshooting

```bash
# See remote URLs
git remote -v

# Change remote URL
git remote set-url origin NEW_URL

# Remove remote
git remote remove origin

# Force push (use carefully!)
git push -f origin main

# Cleanup
git gc
git prune
```

## GitHub Specific

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-ios.git

# Fork workflow
git remote add upstream https://github.com/ORIGINAL_OWNER/skylight-shopping-list-ios.git
git fetch upstream
git merge upstream/main
```

## Tips

- **Commit often**: Small, focused commits are better
- **Write clear messages**: Explain *why*, not just *what*
- **Pull before push**: Always pull latest changes first
- **Branch for features**: Create branches for new work
- **Review before commit**: Use `git diff` to check changes

## Need More Help?

```bash
# Get help for any command
git help <command>
git <command> --help

# Examples
git help commit
git push --help
```

---

**Pro Tip**: Create a `.git-cheat-sheet.txt` file in your project root with these commands for quick reference!
