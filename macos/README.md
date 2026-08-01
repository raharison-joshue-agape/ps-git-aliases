# Git Command Aliases — macOS

A curated collection of `g*` shortcuts that wrap everyday Git operations for Zsh on macOS.

## Overview

Instead of typing long, repetitive Git commands, you use short, memorable aliases that map one-to-one to Git subcommands:

```bash
gStatus          # git status
gAdd file.txt    # git add file.txt
gCommit "msg"    # git commit -m "msg"
gPush            # git push
```

The aliases are organized into themed modules that load automatically from a single entry point, so only one line needs to be added to your shell configuration.

## Prerequisites

| Requirement | Details |
| --- | --- |
| Shell | Zsh 5.x (the default shell on macOS since Catalina) or Bash |
| Git | Installed via [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/) or [Homebrew](https://brew.sh/) |

Install Git if it is missing:

```bash
# Xcode Command Line Tools (recommended)
xcode-select --install

# or via Homebrew
brew install git
```

> **Note for Bash users:** the scripts are fully Bash-compatible. macOS ships Bash 3.2 for licensing reasons, which is too old for these scripts — install a current Bash via Homebrew (`brew install bash`) and use `/opt/homebrew/bin/bash` in your shell configuration.

## Installation

### 1. Copy the module to your config directory

```bash
mkdir -p ~/.config/alias
cp -r macos ~/.config/alias/git-commandes/
```

### 2. Open your shell configuration

```bash
nano ~/.zshrc        # Zsh (default)
nano ~/.bash_profile # Bash
```

### 3. Import the aliases

Append the following line to the end of the file:

```bash
. ~/.config/alias/git-commandes/macos/index.sh
```

`index.sh` is the entry point. It sources every module located in its own directory, so the shortcuts work no matter where the project has been copied to.

### 4. Reload your shell

```bash
source ~/.zshrc      # or: source ~/.bash_profile
```

## Module reference

Each module groups functions by topic:

| File | Functions |
| --- | --- |
| `helpers.sh` | `test_git`, `show_git_error`, `show_git_success`, `invoke_git` |
| `docs.sh` | `gDocs` |
| `config.sh` | `gHelp`, `gConfig` |
| `repository.sh` | `gInit`, `gClone`, `gStatus`, `gClean`, `gArchive` |
| `staging.sh` | `gAdd`, `gRemove`, `gMove`, `gCommit`, `gUntrack` |
| `branch.sh` | `gBranch`, `gCheck`, `gSwitch`, `gMerge`, `gRebase`, `gWorktree`, `gMergeAbort`, `gMergeContinue`, `gRebaseAbort`, `gRebaseContinue` |
| `remote.sh` | `gRemote`, `gPush`, `gPull`, `gFetch` |
| `history.sh` | `gLog`, `gShow`, `gRestore`, `gReset`, `gRevert`, `gCherryPick`, `gReflog`, `gStash` |
| `inspect.sh` | `gDiff`, `gBlame`, `gGrep`, `gShortLog`, `gDescribe` |
| `tags.sh` | `gTag`, `gPushTag` |
| `submodule.sh` | `gSubmodule` |
| `bisect.sh` | `gBisect` |

## Usage

Aliases behave like ordinary shell commands and accept the same arguments as the underlying Git commands:

```bash
gStatus             # repository status
gAdd                # stage all changes
gCommit "msg"       # commit staged changes
gPush               # push the current branch
gDiff --cached      # review staged changes
gLog --graph        # commit history as a graph
```

## Built-in help

| Command | Description |
| --- | --- |
| `gDocs` | Print an in-terminal cheat sheet of every available alias |
| `gHelp [cmd]` | Open the Git manual for a specific command |

```bash
gDocs
gHelp commit
```

## Uninstall

1. Remove the import line from `~/.zshrc` (or `~/.bash_profile`).
2. Delete the directory:

```bash
rm -rf ~/.config/alias/git-commandes
```

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Aliases are unavailable | Verify the import path is correct, then reload with `source ~/.zshrc`. |
| `❌ Git is not installed` | Run `xcode-select --install` (or `brew install git`) and restart your shell. |
| `command not found: gStatus` | The functions were not loaded. Confirm that `. ~/.config/alias/git-commandes/macos/index.sh` appears in `~/.zshrc` and that the file exists at that path. |
| `bad option` or parse errors | macOS ships an outdated Bash 3.2 — use Zsh, or install a modern Bash via Homebrew. |

## Contributing

See the [repository README](../README.md) for the full project overview, feature set, and contribution guidelines.
