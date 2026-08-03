# =============================================================================
#  Branch - Branch management, switching, merging and rebasing.
#  Written for Zsh (default shell on macOS).
# =============================================================================

# -----------------------------------------------------------------------------
#  gBranch [name]
#  gBranch -d|-D <name>
#    Manages Git branches:
#      * no argument    -> list branches
#      * <name>         -> create a branch
#      * -d <name>      -> delete a branch (safe)
#      * -D <name>      -> force delete a branch
# -----------------------------------------------------------------------------
gBranch() {
    test_git || return 1

    local type=""
    local branch_name=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|-D) type="$1"; shift ;;
            *)     branch_name="$1"; shift ;;
        esac
    done

    if [[ -z "$branch_name" ]]; then
        invoke_git branch
        return
    fi

    case "$type" in
        -d)
            if invoke_git branch -d "$branch_name"; then
                show_git_success "Branch deleted: $branch_name"
            else
                show_git_error "Failed to delete branch: $branch_name"
            fi
            ;;
        -D)
            if invoke_git branch -D "$branch_name"; then
                show_git_success "Branch force deleted: $branch_name"
            else
                show_git_error "Failed to force delete branch: $branch_name"
            fi
            ;;
        *)
            if invoke_git branch "$branch_name"; then
                show_git_success "Branch created: $branch_name"
            else
                show_git_error "Failed to create branch: $branch_name"
            fi
            ;;
    esac
}

# -----------------------------------------------------------------------------
#  gCheck [-b] <branch>
#    Checks out a branch. With -b, creates the branch if it does not exist
#    then switches to it.
# -----------------------------------------------------------------------------
gCheck() {
    test_git || return 1

    local b=0
    local branch_name=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b) b=1; shift ;;
            *)  branch_name="$1"; shift ;;
        esac
    done

    if [[ -z "$branch_name" ]]; then
        show_git_error "Usage: gCheck [-b] <branch>"
        return 1
    fi

    if (( b )); then
        if invoke_git checkout -b "$branch_name"; then
            show_git_success "Branch created and switched: $branch_name"
        else
            show_git_error "Failed to create branch: $branch_name"
        fi
    else
        if invoke_git checkout "$branch_name"; then
            show_git_success "Switched to branch: $branch_name"
        else
            show_git_error "Failed to checkout branch: $branch_name"
        fi
    fi
}

# -----------------------------------------------------------------------------
#  gSwitch <branch>
#    Switches between Git branches using `git switch`.
# -----------------------------------------------------------------------------
gSwitch() {
    test_git || return 1

    local branch_name="${1:-}"
    if [[ -z "$branch_name" ]]; then
        show_git_error "Usage: gSwitch <branch>"
        return 1
    fi

    if invoke_git switch "$branch_name"; then
        show_git_success "Switched to branch: $branch_name"
    else
        show_git_error "Failed to switch to branch: $branch_name"
    fi
}

# -----------------------------------------------------------------------------
#  gMerge <branch>
#    Merges a Git branch into the current branch.
# -----------------------------------------------------------------------------
gMerge() {
    test_git || return 1

    local branch_name="${1:-}"
    if [[ -z "$branch_name" ]]; then
        show_git_error "Usage: gMerge <branch>"
        return 1
    fi

    if invoke_git merge "$branch_name"; then
        show_git_success "Merge completed: $branch_name"
    else
        show_git_error "Merge failed: $branch_name"
    fi
}

# -----------------------------------------------------------------------------
#  gRebase <branch>
#    Rebases the current branch onto another branch.
# -----------------------------------------------------------------------------
gRebase() {
    test_git || return 1

    local branch_name="${1:-}"
    if [[ -z "$branch_name" ]]; then
        show_git_error "Usage: gRebase <branch>"
        return 1
    fi

    if invoke_git rebase "$branch_name"; then
        show_git_success "Rebased onto branch: $branch_name"
    else
        show_git_error "Rebase failed on: $branch_name"
    fi
}

# -----------------------------------------------------------------------------
#  gWorktree [add|list|remove]
#    Manages Git worktrees:
#      * list                  -> list all worktrees (default)
#      * add <path> [branch]   -> create a worktree, optionally from a new branch
#      * remove <path>         -> remove a worktree
# -----------------------------------------------------------------------------
gWorktree() {
    test_git || return 1

    local type="${1:-list}"
    local path=""
    local branch=""

    [[ $# -gt 0 ]] && shift
    path="${1:-}"
    [[ $# -gt 0 ]] && shift
    branch="${1:-}"

    case "$type" in
        list)
            invoke_git worktree list
            return
            ;;
        add)
            if [[ -z "$path" ]]; then
                show_git_error "Usage: gWorktree add <path> [branch]"
                return 1
            fi
            local git_args=(worktree add "$path")
            if [[ -n "$branch" ]]; then
                git_args+=(-b "$branch")
            fi
            if invoke_git "${git_args[@]}"; then
                show_git_success "Worktree added: $path"
            else
                show_git_error "Worktree operation failed: $type"
            fi
            ;;
        remove)
            if [[ -z "$path" ]]; then
                show_git_error "Usage: gWorktree remove <path>"
                return 1
            fi
            if invoke_git worktree remove "$path"; then
                show_git_success "Worktree removed: $path"
            else
                show_git_error "Worktree operation failed: $type"
            fi
            ;;
        *)
            show_git_error "Usage: gWorktree [add|list|remove]"
            return 1
            ;;
    esac
}

# -----------------------------------------------------------------------------
#  gMergeAbort
#    Aborts a merge that is in progress (git merge --abort).
# -----------------------------------------------------------------------------
gMergeAbort() {
    test_git || return 1

    if invoke_git merge --abort; then
        show_git_success "Merge aborted"
    else
        show_git_error "Failed to abort merge"
    fi
}

# -----------------------------------------------------------------------------
#  gMergeContinue
#    Continues a merge after resolving the conflicts (git merge --continue).
# -----------------------------------------------------------------------------
gMergeContinue() {
    test_git || return 1

    if invoke_git merge --continue; then
        show_git_success "Merge continued"
    else
        show_git_error "Failed to continue merge"
    fi
}

# -----------------------------------------------------------------------------
#  gRebaseAbort
#    Aborts a rebase that is in progress (git rebase --abort).
# -----------------------------------------------------------------------------
gRebaseAbort() {
    test_git || return 1

    if invoke_git rebase --abort; then
        show_git_success "Rebase aborted"
    else
        show_git_error "Failed to abort rebase"
    fi
}

# -----------------------------------------------------------------------------
#  gRebaseContinue
#    Continues a rebase after resolving the conflicts (git rebase --continue).
# -----------------------------------------------------------------------------
gRebaseContinue() {
    test_git || return 1

    if invoke_git rebase --continue; then
        show_git_success "Rebase continued"
    else
        show_git_error "Failed to continue rebase"
    fi
}
