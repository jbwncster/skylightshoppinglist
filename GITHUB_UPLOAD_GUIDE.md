# GitHub Repository Setup Guide 🚀

This guide walks you through uploading this project to GitHub.

## Prerequisites

- [Git installed](https://git-scm.com/downloads) on your computer
- A [GitHub account](https://github.com/join)
- Git configured with your credentials:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```

---

## Step 1: Create a New GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Fill in the details:
   - **Repository name**: `skylight-shopping-list`
   - **Description**: "Multi-platform shopping list apps with camera scanning and Skylight Calendar integration"
   - **Visibility**: Public (or Private)
   - ❌ **Do NOT** initialize with README, .gitignore, or license (we already have these)
3. Click **"Create repository"**
4. **Copy the repository URL** (e.g., `https://github.com/YOUR_USERNAME/skylight-shopping-list.git`)

---

## Step 2: Initialize and Push the Code

Open a terminal in the project folder and run these commands:

```bash
# Navigate to the project folder
cd /path/to/skylight-shopping-list

# Initialize Git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Multi-platform Skylight Shopping List"

# Set the main branch
git branch -M main

# Add the remote repository (replace with YOUR repo URL)
git remote add origin https://github.com/YOUR_USERNAME/skylight-shopping-list.git

# Push to GitHub
git push -u origin main
```

---

## Step 3: Verify Upload

1. Go to your repository on GitHub
2. Confirm all files are present:
   - ✅ `README.md` (main documentation)
   - ✅ `LICENSE` (MIT license)
   - ✅ `CONTRIBUTING.md` (contribution guidelines)
   - ✅ `.gitignore` (ignored files)
   - ✅ `python/` folder with Python app
   - ✅ `ios/` folder with Swift app
   - ✅ `android/` folder with Kotlin app
   - ✅ `windows/` folder with .NET MAUI app
   - ✅ `docs/` folder with documentation
   - ✅ `packaging/` folder with distribution configs

---

## Step 4: Configure Repository Settings (Optional)

### Add Topics/Tags
1. Go to repository settings
2. Click "Add topics"
3. Add: `skylight`, `shopping-list`, `ios`, `android`, `windows`, `swift`, `kotlin`, `maui`, `barcode-scanner`, `camera-scanning`

### Enable GitHub Pages (Optional)
1. Settings → Pages
2. Source: Deploy from branch
3. Branch: main, /docs folder
4. Your docs will be at `https://YOUR_USERNAME.github.io/skylight-shopping-list/`

### Set Up Branch Protection (Recommended)
1. Settings → Branches
2. Add rule for `main`
3. Enable "Require pull request reviews"

---

## Alternative: GitHub Desktop

If you prefer a GUI:

1. Download [GitHub Desktop](https://desktop.github.com/)
2. File → Add Local Repository
3. Select this project folder
4. Click "Create Repository"
5. Publish to GitHub

---

## Alternative: GitHub CLI

If you have [GitHub CLI](https://cli.github.com/) installed:

```bash
cd /path/to/skylight-shopping-list
git init
git add .
git commit -m "Initial commit"

# This creates the repo AND pushes in one command
gh repo create skylight-shopping-list --public --source=. --push
```

---

## Updating the README

After uploading, update URLs in the README:

1. Replace `YOUR_USERNAME` with your actual GitHub username
2. Update screenshot/image URLs if you add them
3. Update any absolute paths

---

## Next Steps After Upload

- [ ] Add a profile picture / avatar to your GitHub account
- [ ] Write a better repository description
- [ ] Add screenshots to the README
- [ ] Create GitHub Issues for planned features
- [ ] Set up GitHub Actions for CI/CD (optional)
- [ ] Enable Discussions for community Q&A

---

## Troubleshooting

### "Authentication failed"
- Use a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) instead of password
- Or set up [SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

### "Repository already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/skylight-shopping-list.git
```

### "Updates were rejected"
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

---

## Questions?

- GitHub Docs: https://docs.github.com/
- Git Tutorial: https://git-scm.com/doc
