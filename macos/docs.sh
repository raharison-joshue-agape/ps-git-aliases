# =============================================================================
#  Docs - In-terminal cheat sheet listing every Git alias command.
#  Written for Zsh (default shell on macOS) and Bash-compatible.
# =============================================================================

# -----------------------------------------------------------------------------
#  gDocs
#    Displays a formatted cheat sheet of all available Git alias commands,
#    grouped by theme (config, repository, staging, branches, remotes,
#    history, tags, advanced).
# -----------------------------------------------------------------------------
gDocs() {
    local col_command_width=45
    local col_desc_width=75
    local width=$((col_command_width + col_desc_width))

    # Build the separator lines ("=" and "-") to the full table width.
    # Command substitution is used instead of printf -v so the code stays
    # compatible with Zsh.
    local separator
    local line
    separator="$(printf '%*s' "$width" '')"
    separator="${separator// /=}"
    line="$(printf '%*s' "$width" '')"
    line="${line// /-}"

    printf "\n"
    printf "\033[36m  Git Command Aliases - Cheat Sheet\033[0m\n"
    printf "%s\n" "$separator"
    printf "\n"

    local entry
    while IFS= read -r entry; do
        # A line without "|" is a section header.
        if [[ "$entry" != *"|"* ]]; then
            printf "\033[33m  %s\033[0m\n" "$entry"
            printf "%s\n" "$line"
            printf "%-${col_command_width}s%-${col_desc_width}s\n" "COMMAND" "DESCRIPTION"
            printf "%s\n" "$line"
        else
            # Split on the LAST "|": command names may themselves contain "|"
            # (e.g. `gConfig [field] [value] [-g|-l|-s]`), descriptions never do.
            printf "%-${col_command_width}s%-${col_desc_width}s\n" "${entry%|*}" "${entry##*|}"
        fi
    done <<'CHEATSHEET'
Config & Help
gHelp [cmd]|Show Git help or help for a specific command
gConfig [field] [value] [-g|-l|-s]|Get or set Git configuration (global by default)
Repository
gInit [-c] [message]|Initialize a repository with optional initial commit
gClone <url> [folder]|Clone a repository from a URL
gClone <branch> <url> [folder]|Clone a specific branch into a folder
gStatus|Show the current repository status
gArchive <output> [ref]|Create a zip/tar archive of a commit or branch
gClean [-force] [-dry]|Remove untracked files (preview by default, -force deletes)
Working Tree & Commits
gAdd [file]|Stage a file or all files
gRemove <file>|Remove a tracked file from the repository
gMove <old> <new>|Rename or move a tracked file
gUntrack <file>|Stop tracking a file without deleting it
gCommit [-a|-u|--amend] <message>|Create or modify a commit
Branches
gBranch|List all branches
gBranch <name>|Create a new branch
gBranch -d|-D <name>|Delete a local branch
gCheck <branch>|Switch to a branch using checkout
gCheck -b <branch>|Create and switch to a new branch
gSwitch <branch>|Switch branches using git switch
gMerge <branch>|Merge a branch into the current branch
gMergeAbort|Abort an in-progress merge
gMergeContinue|Continue a merge after resolving conflicts
gRebase <branch>|Reapply commits onto a new base branch
gRebaseAbort|Abort an in-progress rebase
gRebaseContinue|Continue a rebase after resolving conflicts
gWorktree [add|list|remove]|Manage multiple working directories
Remotes
gRemote|List configured remotes
gRemote <name> <url>|Add a new remote repository
gPush [remote] [branch]|Push commits to a remote repository
gPull [remote] [branch]|Pull and merge changes from a remote
gFetch [remote]|Fetch updates without merging
History & Recovery
gLog|Show full commit history
gLog oneline|graph|stat|patch|pretty|all|Show commit history in different formats
gShow <commit>|Show details of a commit
gRestore [-staged] <file>|Restore a file from working tree or staging area
gReset <file>|Unstage a file
gReset <commit> <file>|Reset a file to a specific commit
gReset -h <commit|HEAD>|Perform a hard reset (destructive)
gReset -s <commit>|Perform a soft reset (keep changes)
gRevert <commit>|Revert a commit by creating a new one
gCherryPick <commit>|Apply a specific commit onto current branch
gReflog|Show HEAD history (reflog)
gStash|Temporarily save working directory changes
gStash list|pop|apply|drop|clear [index]|Manage stash entries
Inspect
gDiff [-cached] [-stat] [file]|Show working tree or staged changes
gBlame <file> [-line n]|Show the author of each line of a file
gGrep <pattern> [-i]|Search inside tracked files
gShortLog [-summary] [-email] [-all]|Summarize commits grouped by author
gDescribe [ref]|Show the closest reachable tag from a commit
Submodules
gSubmodule add <url> [path]|Register a new submodule
gSubmodule init|update|sync|status|Manage registered submodules
Tags
gTag|List all tags
gTag create <name>|Create a lightweight tag
gTag annotate <name> <msg>|Create an annotated tag with message
gTag delete <name>|Delete a local tag
gTag show <name>|Show tag details
gPushTag [remote] [tag]|Push a tag or all tags to a remote
Advanced
gBisect start|good|bad|reset [commit]|Find bugs using binary search in commit history
CHEATSHEET

    printf "\n"
}
