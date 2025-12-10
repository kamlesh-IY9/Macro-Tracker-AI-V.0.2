# 🚀 GitHub Push Guide for MacroMate

This guide will walk you through pushing your MacroMate project to GitHub step by step.

## 📋 Prerequisites

Before starting, ensure you have:
- ✅ A GitHub account ([Sign up here](https://github.com/join))
- ✅ Git installed (verify with `git --version`)

---

## Step 1: Create a New Repository on GitHub 🌐

1. **Go to [GitHub](https://github.com)** and log in
2. Click the **"+"** icon (top-right) → **"New repository"**
3. **Configure your repository**:
   - **Repository name**: `MacroMate` or `macro-tracker-ai`
   - **Description**: `AI-powered nutrition tracking app built with Flutter and Google Gemini`
   - **Visibility**: 
     - **Public** ➜ Anyone can see (recommended for portfolio)
     - **Private** ➜ Only you can see
   - ⚠️ **Important**: Do NOT check:
     - ❌ "Add a README file" (we already have one!)
     - ❌ "Add .gitignore" (we already have one!)
     - ❌ "Choose a license" (optional, we have MIT in README)
4. Click **"Create repository"**
5. **Copy the repository URL** (it will look like: `https://github.com/yourusername/MacroMate.git`)
   - Keep this page open!

---

## Step 2: Initialize Git Locally 🔧

Open **PowerShell** or **Terminal** and navigate to your project:

```powershell
# Navigate to project directory
cd "c:\Users\Karan\Documents\Sem 9\Capstrone Project\macro_tracker_ai-main"

# Initialize Git
git init
```

**Expected output**: `Initialized empty Git repository in ...`

---

## Step 3: Configure Git Identity 👤

Tell Git who you are:

```powershell
# Set your name (replace with your actual name)
git config user.name "Karan"

# Set your email (use your GitHub email)
git config user.email "your.email@example.com"
```

> **Tip**: Use the same email as your GitHub account!

---

## Step 4: Review .gitignore ✅

Your `.gitignore` has been updated to exclude:
- ✅ Large demo videos (200MB+)
- ✅ Error log files
- ✅ IDE configuration files
- ✅ Build artifacts

**Important Security Note**: 
- Your `firebase_options.dart` file contains API keys
- For public repositories, consider using environment variables instead
- For now, the Firebase keys are configured as placeholder values for most platforms

---

## Step 5: Add Files to Git 📁

Add all your project files to Git:

```powershell
# Add all files (respecting .gitignore)
git add .

# Check what will be committed
git status
```

You should see:
- ✅ Green files = will be committed
- ❌ Red files or files not listed = ignored or not staged

**Expected files to be added**:
- `README.md`
- `pubspec.yaml`
- `lib/` directory
- `android/`, `ios/`, `windows/`, etc.
- `.gitignore`

**Files that will be ignored** (won't appear):
- `Recording*.mp4` (demo videos - too large)
- `analysis_errors.txt`
- `build/` directory
- `.idea/`, `.vscode/`

---

## Step 6: Create Your First Commit 💾

```powershell
# Commit with a descriptive message
git commit -m "Initial commit: MacroMate AI nutrition tracker with Flutter + Gemini"
```

**Expected output**: `X files changed, Y insertions(+)`

---

## Step 7: Add GitHub Remote 🔗

Connect your local repository to GitHub:

```powershell
# Add remote (replace with YOUR repository URL from Step 1)
git remote add origin https://github.com/YOUR_USERNAME/MacroMate.git

# Verify remote was added
git remote -v
```

**Example**:
```powershell
git remote add origin https://github.com/karan123/MacroMate.git
```

---

## Step 8: Rename Branch to 'main' 🌿

GitHub uses `main` as the default branch name:

```powershell
# Rename branch from 'master' to 'main'
git branch -M main
```

---

## Step 9: Push to GitHub 🚀

Push your code to GitHub:

```powershell
# Push to GitHub (first time)
git push -u origin main
```

**You might be prompted for**:
- GitHub username
- Personal Access Token (if 2FA is enabled) or Password

### If you need a Personal Access Token:
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Select scopes: `repo` (full control)
4. Copy the token and use it as your password

**Expected output**:
```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
...
To https://github.com/YOUR_USERNAME/MacroMate.git
 * [new branch]      main -> main
```

---

## Step 10: Verify on GitHub ✅

1. Go to your GitHub repository: `https://github.com/YOUR_USERNAME/MacroMate`
2. **You should see**:
   - ✅ Your beautiful README with badges
   - ✅ All source code files
   - ✅ Proper folder structure
   - ✅ Commit message

**Congratulations! 🎉 Your project is now on GitHub!**

---

## 📝 Future Updates (Making Changes)

After making changes to your code locally:

```powershell
# 1. Check what changed
git status

# 2. Add changed files
git add .

# 3. Commit with descriptive message
git commit -m "Add: feature description or Fix: bug description"

# 4. Push to GitHub
git push
```

### Commit Message Examples:
```
✅ "Add: AI nutrition coach feature"
✅ "Fix: weight graph not updating immediately"
✅ "Update: README with new screenshots"
✅ "Refactor: meal planner UI improvements"
```

---

## 🎯 Optional Enhancements

### Add Demo Videos (Optional)

Your demo videos are currently ignored (200MB+). To include them:

**Option 1: Use Git LFS (Large File Storage)**
```powershell
# Install Git LFS
git lfs install

# Track MP4 files
git lfs track "*.mp4"

# Add and commit
git add .gitattributes
git add "Recording*.mp4"
git commit -m "Add: demo videos"
git push
```

**Option 2: Upload to YouTube/Drive**
- Upload videos to YouTube or Google Drive
- Update README with links instead of local files

### Add Shields/Badges

Your README already has badges! To customize them:
- Visit [shields.io](https://shields.io)
- Generate custom badges
- Add to README

### Enable GitHub Pages (for Web Version)

If you want to host the web version:
1. Build web version: `flutter build web`
2. Create `gh-pages` branch
3. Push `build/web` contents
4. Enable GitHub Pages in repository settings

---

## ❓ Troubleshooting

### 🔴 "authentication failed"
- Use Personal Access Token instead of password
- Make sure you're using the correct GitHub username

### 🔴 "remote origin already exists"
```powershell
git remote remove origin
git remote add origin YOUR_REPO_URL
```

### 🔴 "rejected - non-fast-forward"
```powershell
# Only do this for initial push if needed
git push -f origin main
```

### 🔴 "repository not found"
- Check repository URL is correct
- Make sure repository exists on GitHub
- Verify you have access to the repository

---

## 🔒 Security Checklist

Before pushing:
- ✅ No real API keys in public repository
- ✅ Firebase credentials use placeholders (for most platforms)
- ✅ `.gitignore` includes sensitive files
- ✅ No personal data or credentials

**For production**:
- Use environment variables for API keys
- Keep Firebase credentials private
- Use GitHub Secrets for CI/CD

---

## 📚 Useful Git Commands

```powershell
# View commit history
git log --oneline

# See what changed
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard local changes
git checkout -- filename

# Create a new branch
git checkout -b feature-name

# Switch branches
git checkout main

# Pull latest changes from GitHub
git pull
```

---

## 🎉 Next Steps

Now that your project is on GitHub:

1. ✅ **Add a LICENSE file** (MIT License recommended)
2. ✅ **Add topics** to your repository (flutter, ai, nutrition, dart, firebase)
3. ✅ **Create releases** when you hit milestones
4. ✅ **Share your repository** on your resume/portfolio
5. ✅ **Enable Issues** for bug tracking
6. ✅ **Set up GitHub Actions** for CI/CD (optional)

---

**Happy Coding! 🚀**

For more Git help, visit: [Git Documentation](https://git-scm.com/doc)
