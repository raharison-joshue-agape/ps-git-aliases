# =============================================================================
#  History - Log, show, restore, reset, revert, cherry-pick, reflog and stash.
#  Written for Zsh (default shell on macOS).
# =============================================================================

# -----------------------------------------------------------------------------
#  gLog [type]
#    Displays Git commit history in different formats. `type` is one of:
#    oneline, graph, stat, patch, pretty, all. Without it, a plain log.
# -----------------------------------------------------------------------------
gLog() {
    test_git || return 1

    case "${1:-}" in
        oneline) invoke_git log --oneline ;;
        graph)   invoke_git log --oneline --graph --all ;;
        stat)    invoke_git log --stat ;;
        patch)   invoke_git log -p ;;
        pretty)  invoke_git log --pretty=format:"%h - %an, %ar : %s" ;;
        all)     invoke_git log --oneline --graph --decorate --all ;;
        *)       invoke_git log ;;
    esac
}

# -----------------------------------------------------------------------------
#  gShow <commit>
#    Shows the details of a specific commit (hash, branch or tag).
# -----------------------------------------------------------------------------
gShow() {
    test_git || return 1

    local commit="${1:-}"
    if [[ -z "$commit" ]]; then
        show_git_error "Usage: gShow <commit>"
        return 1
    fi

    invoke_git show "$commit"
}

# -----------------------------------------------------------------------------
#  gRestore [-staged] <file>
#    Restores files from the staging area or the working directory:
#      * gRestore <file>          -> discard working directory changes
#      * gRestore -staged <file>  -> unstage the file
# -----------------------------------------------------------------------------
gRestore() {
    test_git || return 1

    local staged=0
    local file=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -staged) staged=1; shift ;;
            *)       file="$1"; shift ;;
        esac
    done

    if [[ -z "$file" ]]; then
        show_git_error "Usage: gRestore [-staged] <file>"
        return 1
    fi

    if (( staged )); then
        if invoke_git restore --staged "$file"; then
            show_git_success "File unstaged: $file"
        else
            show_git_error "Failed to unstage file: $file"
        fi
    else
        if invoke_git restore "$file"; then
            show_git_success "File restored: $file"
        else
            show_git_error "Failed to restore file: $file"
        fi
    fi
}

# -----------------------------------------------------------------------------
#  gReset [-h|-s] <arg1> [arg2]
#    Resets Git state:
#      * -h <commit>        -> hard reset (destructive)
#      * -s <commit>        -> soft reset (keep changes)
#      * <file>             -> unstage the file
#      * <commit> <file>    -> reset the file to a specific commit
# -----------------------------------------------------------------------------
gReset() {
    test_git || return 1

    local h=0
    local s=0
    local first=""
    local second=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h) h=1; shift ;;
            -s) s=1; shift ;;
            *)
                if [[ -z "$first" ]]; then
                    first="$1"
                elif [[ -z "$second" ]]; then
                    second="$1"
                fi
                shift
                ;;
        esac
    done

    if (( h && s )); then
        show_git_error "Use either -h or -s, not both"
        return 1
    fi

    local ok=1
    local msg=""

    if (( h )); then
        invoke_git reset --hard "$first"
        ok=$?
        msg="Hard reset to: $first"
    elif (( s )); then
        invoke_git reset --soft "$first"
        ok=$?
        msg="Soft reset to: $first"
    elif [[ -n "$first" && -n "$second" ]]; then
        invoke_git reset "$first" -- "$second"
        ok=$?
        msg="File reset: $second -> $first"
    elif [[ -n "$first" ]]; then
        invoke_git reset HEAD -- "$first"
        ok=$?
        msg="Unstaged: $first"
    else
        show_git_error "Invalid usage"
        return 1
    fi

    if (( ok == 0 )); then
        show_git_success "$msg"
    else
        show_git_error "Reset operation failed"
    fi
}

# -----------------------------------------------------------------------------
#  gRevert <commit>
#    Reverts a commit by creating a new commit that undoes it.
# -----------------------------------------------------------------------------
gRevert() {
    test_git || return 1

    local commit="${1:-}"
    if [[ -z "$commit" ]]; then
        show_git_error "Usage: gRevert <commit>"
        return 1
    fi

    if invoke_git revert "$commit"; then
        show_git_success "Commit reverted: $commit"
    else
        show_git_error "Failed to revert commit: $commit"
    fi
}

# -----------------------------------------------------------------------------
#  gCherryPick <commit>
#    Applies a specific commit using cherry-pick.
# -----------------------------------------------------------------------------
gCherryPick() {
    test_git || return 1

    local commit="${1:-}"
    if [[ -z "$commit" ]]; then
        show_git_error "Usage: gCherryPick <commit>"
        return 1
    fi

    if invoke_git cherry-pick "$commit"; then
        show_git_success "Cherry-picked commit: $commit"
    else
        show_git_error "Failed to cherry-pick commit: $commit"
    fi
}

# -----------------------------------------------------------------------------
#  gReflog
#    Shows the Git reflog history, useful for recovering commits no longer
#    referenced by any branch.
# -----------------------------------------------------------------------------
gReflog() {
    test_git || return 1
    invoke_git reflog
}

# -----------------------------------------------------------------------------
#  gStash [type] [index]
#    Manages Git stash entries:
#      * no argument    -> save the current changes
#      * list           -> list saved stashes
#      * pop [index]    -> apply and remove the latest stash
#      * apply [index]  -> apply a stash without removing it
#      * drop [index]   -> delete a stash
#      * clear          -> remove every stash
#    index defaults to 0.
# -----------------------------------------------------------------------------
gStash() {
    test_git || return 1

    local type="${1:-}"
    local index="${2:-0}"
    local target="stash@{$index}"
    local success_message=""

    case "$type" in
        list)  invoke_git stash list ;;
        pop)   success_message="Stash popped: $index";  invoke_git stash pop "$target" ;;
        apply) success_message="Stash applied: $index"; invoke_git stash apply "$target" ;;
        drop)  success_message="Stash dropped: $index"; invoke_git stash drop "$target" ;;
        clear) success_message="All stashes cleared";   invoke_git stash clear ;;
        *)     success_message="Changes stashed";       invoke_git stash ;;
    esac

    if [[ $? -eq 0 ]]; then
        if [[ -n "$success_message" ]]; then
            show_git_success "$success_message"
        fi
    else
        show_git_error "Stash operation failed: $type"
    fi
}
