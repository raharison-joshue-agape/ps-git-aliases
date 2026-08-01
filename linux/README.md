# Git Command Aliases — Linux

A curated collection of `g*` shortcuts that wrap everyday Git operations for Bash on Linux.

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
| Shell | Bash 4.0+ (or Zsh) |
| Git | Any modern release — see [git-scm.com](https://git-scm.com/download/linux) |

Install Git if it is missing:

```bash
# Debian / Ubuntu
sudo apt install git

# Arch Linux
sudo pacman -S git
```

## Installation

### 1. Copy the module to your config directory

```bash
mkdir -p ~/.config/alias
cp -r linux ~/.config/alias/git-commandes/
```

### 2. Open your shell configuration

```bash
nano ~/.bashrc      # Bash
nano ~/.zshrc       # Zsh
```

### 3. Import the aliases

Append the following line to the end of the file:

```bash
. ~/.config/alias/git-commandes/linux/index.sh
```

`index.sh` is the entry point. It sources every module located in its own directory, so the shortcuts work no matter where the project has been copied to.

### 4. Reload your shell

```bash
source ~/.bashrc    # or: source ~/.zshrc
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

1. Remove the import line from `~/.bashrc` (or `~/.zshrc`).
2. Delete the directory:

```bash
rm -rf ~/.config/alias/git-commandes
```

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Aliases are unavailable | Verify the import path is correct, then reload with `source ~/.bashrc`. |
| `❌ Git is not installed` | Install Git (e.g. `sudo apt install git`) and restart your shell. |
| `command not found: gStatus` | The functions were not loaded. Confirm that `. ~/.config/alias/git-commandes/linux/index.sh` appears in `~/.bashrc` and that the file exists at that path. |

## Contributing

See the [repository README](../README.md) for the full project overview, feature set, and contribution guidelines.
