# Git Command Aliases — Windows

A curated collection of `g*` shortcuts that wrap everyday Git operations for PowerShell on Windows.

## Overview

Instead of typing long, repetitive Git commands, you use short, memorable aliases that map one-to-one to Git subcommands:

```powershell
gStatus          # git status
gAdd -a          # git add -A
gCommit "msg"    # git commit -m "msg"
gPush            # git push
```

The aliases are organized into themed modules that load automatically from a single entry point, so only one line needs to be added to your PowerShell profile. Every function ships with comment-based help discoverable through `Get-Help`.

## Prerequisites

| Requirement | Details |
| --- | --- |
| Operating system | Windows 10 or 11 |
| Shell | Windows PowerShell 5.1+ or PowerShell 7 |
| Git | [Git for Windows](https://git-scm.com/download/win) installed and available in `PATH` |

## Installation

### 1. Copy the module to your config directory

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\alias" -Force
Copy-Item -Path "windows" -Destination "$HOME\.config\alias\git-commandes\" -Recurse
```

### 2. Check whether a PowerShell profile exists

```powershell
Test-Path $PROFILE
```

- `True` → your profile already exists; continue to step 4.
- `False` → create it first:

```powershell
New-Item -Path $PROFILE -ItemType File -Force
```

### 3. Open your profile

```powershell
notepad $PROFILE
```

or with Visual Studio Code:

```powershell
code $PROFILE
```

### 4. Import the aliases

Append the following line to your profile:

```powershell
. "$HOME\.config\alias\git-commandes\windows\index.ps1"
```

`index.ps1` is the entry point. It dot-sources every module located in its own directory, so the shortcuts work no matter where the project has been copied to.

### 5. Reload your profile

```powershell
. $PROFILE
```

## Module reference

Each module groups functions by topic:

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

## Usage

Aliases behave like ordinary PowerShell commands and accept the same arguments as the underlying Git commands:

```powershell
gStatus             # repository status
gAdd -a             # stage all changes
gCommit "msg"       # commit staged changes
gPush               # push the current branch
gDiff -cached       # review staged changes
gLog -graph         # commit history as a graph
```

## Built-in help

| Command | Description |
| --- | --- |
| `gDocs` | Print an in-terminal cheat sheet of every available alias |
| `gHelp [cmd]` | Open the Git manual for a specific command |
| `Get-Help <function>` | Show comment-based documentation for any alias, including parameters and examples |

```powershell
gDocs
Get-Help gCommit
```

## Uninstall

1. Remove the import line from `$PROFILE`.
2. Delete the directory:

```powershell
Remove-Item -Path "$HOME\.config\alias\git-commandes" -Recurse -Force
```

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Aliases are unavailable | Verify the import path in `$PROFILE`, then reload with `. $PROFILE`. |
| `❌ Git is not installed` | Install [Git for Windows](https://git-scm.com/download/win) and restart PowerShell. |
| Profile not found | Confirm `$PROFILE` exists with `Test-Path $PROFILE`, creating it if necessary. |

## Contributing

See the [repository README](../README.md) for the full project overview, feature set, and contribution guidelines.
