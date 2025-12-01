# 🤝 How to Contribute to Fundo

First off, thanks for taking the time to contribute! 🎉

This document explains **how** we work together on GitHub. Since we are a team, we need to follow these rules so we don't break each other's code.

## 🚫 The Golden Rule

**NEVER push directly to the `main` branch.** All code must go through a **Pull Request (PR)** and be approved by the lead.

## 🌿 Branching Strategy

We use a specific naming convention for our branches.

|Branch Name|Who uses it?|Purpose|
|---|---|---|
|`main`|**Project Manager Only**|The "Production" code. It must _always_ work.|
|`dev`|**Everyone**|The integration branch. We merge our features here to test them together.|
|`feat/feature-name`|**Developers**|For new features (e.g., `feat/login-screen`, `feat/gemini-chat`).|
|`fix/bug-name`|**Developers**|For fixing bugs (e.g., `fix/map-crash`).|
|`docs/doc-name`|**Writers**|For documentation only (e.g., `docs/update-readme`).|

## 📝 Step-by-Step Workflow

### 1. Start a New Task

Before you start coding, make sure your local code is up to date.

```
# 1. Switch to the development branch
git checkout dev

# 2. Download the latest changes from teammates
git pull origin dev

# 3. Create your new branch (Use a clear name!)
git checkout -b feat/add-transaction-screen
```

### 2. Write Your Code

- Follow the **Project Structure** guide.
- Keep your methods short.
- **Do not** comment out large blocks of code; just delete them. Git remembers history.

### 3. Save Your Changes (Commit)

We use **Conventional Commits**. This makes our history readable. Format: `type(scope): message`

**Examples:**

- ✅ `feat(auth): implement google sign in`
- ✅ `fix(map): crash when location permission denied`
- ✅ `style(home): change balance card color to green`
- ✅ `docs(readme): add setup instructions`

```
git add .
git commit -m "feat(auth): add login screen ui"
```

### 4. Send to GitHub (Push)

```
git push origin feat/add-transaction-screen
```

### 5. Open a Pull Request (PR)

1. Go to our GitHub Repository.
2. You will see a yellow banner saying **"feat/add-transaction-screen had recent pushes"**. Click **"Compare & pull request"**.
3. **Title:** Describe what you did briefly.
4. **Description:**
    - What does this do?
    - **Screenshots/Video:** (MANDATORY for UI changes) - Show us it works!
5. **Reviewers:** Select **zelebwr** (or another lead).
6. Click **Create Pull Request**.

## 👮 Code Review Checklist

Before you submit your PR, ask yourself:

- [ ] Did I run `flutter analyze` to check for errors?
- [ ] Did I format my code? (Right-click -> Format Document).
- [ ] Did I test this on an **Android Emulator**? (iOS is bonus).
- [ ] Did I remove `print()` statements used for debugging?
- [ ] Did I add **Screenshots** to the PR description?

## 🆘 Help! I'm Stuck!

If you have a Git conflict or don't know where to put a file:

1. Check `docs/PROJECT_STRUCTURE.md`.
2. Ask in the **WhatsApp Group Chat**.
3. **Do not** force push or delete things if you are unsure.