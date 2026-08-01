# Git Command Aliases - Linux

A collection of Git shortcuts (`g*`) for bash on Linux.

## Prerequisites

- Linux with bash 4.0 or later
- [Git](https://git-scm.com/download/linux) installed (`sudo apt install git` on Debian/Ubuntu, `sudo pacman -S git` on Arch, etc.)

## Installation

### 1. Copy the files

Place the `linux` folder in your configuration directory:

```bash
mkdir -p ~/.config/alias
cp -r linux ~/.config/alias/git-commandes/
```

### 2. Open your shell configuration file

```bash
nano ~/.bashrc
```

or, if you use zsh:

```bash
nano ~/.zshrc
```

### 3. Import the aliases

Add this line at the end of the file:

```bash
. ~/.config/alias/git-commandes/linux/index.sh
```

`index.sh` automatically loads all modules. Each module groups functions by theme:

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

### 4. Reload your configuration

```bash
source ~/.bashrc
```

## Usage

The shortcuts are used directly in the terminal:

```bash
gStatus          # repository status
gAdd             # stage all files
gCommit "msg"    # create a commit
gPush            # push the current branch
gDiff -cached    # diff of staged changes
```

## Built-in help

```bash
gDocs            # in-terminal cheat sheet
gHelp commit     # Git help for a command
```

## Uninstall

- Remove the import line from your `~/.bashrc` (or `~/.zshrc`)
- Delete the directory:

```bash
rm -rf ~/.config/alias/git-commandes
```

## Troubleshooting

- Aliases don't work → check the path in the import line and reload your configuration (`source ~/.bashrc`).
- `❌ Git is not installed` → install Git (`sudo apt install git`, for example).
- `command not found: gStatus` → the functions are not loaded, make sure the line `. ~/.config/alias/git-commandes/linux/index.sh` is present in your `~/.bashrc`.
