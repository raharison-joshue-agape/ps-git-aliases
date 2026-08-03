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
| Shell | Zsh 5.x (the default shell on macOS since Catalina) |
| Git | Installed via [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/) or [Homebrew](https://brew.sh/) |

Install Git if it is missing:

```bash
# Xcode Command Line Tools (recommended)
xcode-select --install

# or via Homebrew
brew install git
```

> **Note:** the scripts are written for Zsh and are not Bash-compatible.

## Installation

### 1. Copy the module to your config directory

```bash
mkdir -p ~/.config/alias
cp -r macos ~/.config/alias/git-commandes/
```

### 2. Open your shell configuration

```bash
nano ~/.zshrc
```

### 3. Import the aliases

Append the following line to the end of the file:

```bash
. ~/.config/alias/git-commandes/macos/index.zsh
```

`index.zsh` is the entry point. It sources every module located in its own directory, so the shortcuts work no matter where the project has been copied to.

### 4. Reload your shell

```bash
source ~/.zshrc
```

## Module reference

Each module groups functions by topic:

| File | Functions |
| --- | --- |
| `helpers.zsh` | `test_git`, `show_git_error`, `show_git_success`, `invoke_git` |
| `docs.zsh` | `gDocs` |
| `config.zsh` | `gHelp`, `gConfig` |
| `repository.zsh` | `gInit`, `gClone`, `gStatus`, `gClean`, `gArchive` |
| `staging.zsh` | `gAdd`, `gRemove`, `gMove`, `gCommit`, `gUntrack` |
| `branch.zsh` | `gBranch`, `gCheck`, `gSwitch`, `gMerge`, `gRebase`, `gWorktree`, `gMergeAbort`, `gMergeContinue`, `gRebaseAbort`, `gRebaseContinue` |
| `remote.zsh` | `gRemote`, `gPush`, `gPull`, `gFetch` |
| `history.zsh` | `gLog`, `gShow`, `gRestore`, `gReset`, `gRevert`, `gCherryPick`, `gReflog`, `gStash` |
| `inspect.zsh` | `gDiff`, `gBlame`, `gGrep`, `gShortLog`, `gDescribe` |
| `tags.zsh` | `gTag`, `gPushTag` |
| `submodule.zsh` | `gSubmodule` |
| `bisect.zsh` | `gBisect` |

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

1. Remove the import line from `~/.zshrc`.
2. Delete the directory:

```bash
rm -rf ~/.config/alias/git-commandes
```

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Aliases are unavailable | Verify the import path is correct, then reload with `source ~/.zshrc`. |
| `❌ Git is not installed` | Run `xcode-select --install` (or `brew install git`) and restart your shell. |
| `command not found: gStatus` | The functions were not loaded. Confirm that `. ~/.config/alias/git-commandes/macos/index.zsh` appears in `~/.zshrc` and that the file exists at that path. |
| Parse errors when sourcing | The scripts are Zsh-only — make sure they are loaded from `~/.zshrc`, not `~/.bash_profile`. |

## Contributing

See the [repository README](../README.md) for the full project overview, feature set, and contribution guidelines.
