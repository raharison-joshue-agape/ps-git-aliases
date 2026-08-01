# Git Command Aliases - Windows

A collection of Git shortcuts (`g*`) for PowerShell on Windows.

## Prerequisites

- Windows 10 or 11
- PowerShell 5.1 or later (Windows PowerShell or PowerShell 7)
- [Git for Windows](https://git-scm.com/download/win) installed and added to PATH

## Installation

### 1. Copy the files

Place the `windows` folder in your configuration directory:

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\alias" -Force
Copy-Item -Path "windows" -Destination "$HOME\.config\alias\git-commandes\" -Recurse
```

### 2. Check your PowerShell profile

```powershell
Test-Path $PROFILE
```

- `True` → your profile exists, go to step 4.
- `False` → create it:

```powershell
New-Item -Path $PROFILE -ItemType File -Force
```

### 3. Open your profile

```powershell
notepad $PROFILE
```

or with VS Code:

```powershell
code $PROFILE
```

### 4. Import the aliases

Add this line to your profile:

```powershell
. "$HOME\.config\alias\git-commandes\windows\index.ps1"
```

`index.ps1` automatically loads all modules. Each module groups functions by theme:

| File | Functions |
| --- | --- |
| `helpers.ps1` | `Test-Git`, `Show-GitError`, `Show-GitSuccess`, `Invoke-Git` |
| `docs.ps1` | `gDocs` |
| `config.ps1` | `gHelp`, `gConfig` |
| `repository.ps1` | `gInit`, `gClone`, `gStatus`, `gClean`, `gArchive` |
| `staging.ps1` | `gAdd`, `gRemove`, `gMove`, `gCommit`, `gUntrack` |
| `branch.ps1` | `gBranch`, `gCheck`, `gSwitch`, `gMerge`, `gRebase`, `gWorktree`, `gMergeAbort`, `gMergeContinue`, `gRebaseAbort`, `gRebaseContinue` |
| `remote.ps1` | `gRemote`, `gPush`, `gPull`, `gFetch` |
| `history.ps1` | `gLog`, `gShow`, `gRestore`, `gReset`, `gRevert`, `gCherryPick`, `gReflog`, `gStash` |
| `inspect.ps1` | `gDiff`, `gBlame`, `gGrep`, `gShortLog`, `gDescribe` |
| `tags.ps1` | `gTag`, `gPushTag` |
| `submodule.ps1` | `gSubmodule` |
| `bisect.ps1` | `gBisect` |

### 5. Reload your profile

```powershell
. $PROFILE
```

## Usage

The shortcuts are used directly in the terminal:

```powershell
gStatus        # repository status
gAdd -a        # stage all files
gCommit "msg"  # create a commit
gPush          # push the current branch
gDiff -cached  # diff of staged changes
```

## Built-in help

```powershell
gDocs                 # in-terminal cheat sheet
Get-Help gCommit      # documentation of a function
```

Every function has comment-based help (`Get-Help`) describing its parameters and providing examples.

## Uninstall

- Remove the import line from your profile: `$PROFILE`
- Delete the directory:

```powershell
Remove-Item -Path "$HOME\.config\alias\git-commandes" -Recurse -Force
```

## Troubleshooting

- Aliases don't work → check the path in the import line and reload your profile.
- `❌ Git is not installed` → install Git for Windows and restart PowerShell.
- Profile not found → check that `$PROFILE` exists (`Test-Path $PROFILE`).
