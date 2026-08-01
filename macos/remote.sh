# =============================================================================
#  Remote - Remote management, push, pull and fetch.
#  Written for Zsh (default shell on macOS) and Bash-compatible.
# =============================================================================

# -----------------------------------------------------------------------------
#  gRemote [name] [url]
#    Manages Git remotes:
#      * no arguments     -> list existing remotes (git remote -v)
#      * <name> <url>     -> add a new remote (default name: origin)
# -----------------------------------------------------------------------------
gRemote() {
    test_git || return 1

    local remote_name="${1:-origin}"
    local url="${2:-}"

    if [[ -z "$url" ]]; then
        invoke_git remote -v
        return
    fi

    if invoke_git remote add "$remote_name" "$url"; then
        show_git_success "Remote added: $remote_name -> $url"
    else
        show_git_error "Failed to manage remote: $remote_name"
    fi
}

# -----------------------------------------------------------------------------
#  gPush [remote] [branch]
#    Pushes commits to a remote repository. Without a branch, pushes the
#    current branch (default remote: origin).
# -----------------------------------------------------------------------------
gPush() {
    test_git || return 1

    local remote_name="${1:-origin}"
    local branch_name="${2:-}"

    if [[ -z "$branch_name" ]]; then
        branch_name="$(git branch --show-current)"
        if [[ -z "$branch_name" ]]; then
            show_git_error "Unable to detect current branch"
            return 1
        fi
    fi

    if invoke_git push "$remote_name" "$branch_name"; then
        show_git_success "Pushed: $remote_name/$branch_name"
    else
        show_git_error "Failed to push: $remote_name/$branch_name"
    fi
}

# -----------------------------------------------------------------------------
#  gPull [remote] [branch]
#    Pulls changes from a remote repository. Without a branch, pulls the
#    current branch (default remote: origin).
# -----------------------------------------------------------------------------
gPull() {
    test_git || return 1

    local remote_name="${1:-origin}"
    local branch_name="${2:-}"

    if [[ -z "$branch_name" ]]; then
        branch_name="$(git branch --show-current)"
        if [[ -z "$branch_name" ]]; then
            show_git_error "Unable to detect current branch"
            return 1
        fi
    fi

    if invoke_git pull "$remote_name" "$branch_name"; then
        show_git_success "Pulled: $remote_name/$branch_name"
    else
        show_git_error "Failed to pull: $remote_name/$branch_name"
    fi
}

# -----------------------------------------------------------------------------
#  gFetch [remote]
#    Fetches updates from a remote repository without merging.
#    Default remote: origin.
# -----------------------------------------------------------------------------
gFetch() {
    test_git || return 1

    local remote_name="${1:-origin}"

    if invoke_git fetch "$remote_name"; then
        show_git_success "Fetched from: $remote_name"
    else
        show_git_error "Failed to fetch from: $remote_name"
    fi
}
