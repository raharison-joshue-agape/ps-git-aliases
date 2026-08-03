# =============================================================================
#  Staging - Working directory and commit operations.
#  Written for Zsh (default shell on macOS).
# =============================================================================

# -----------------------------------------------------------------------------
#  gAdd [file]
#    Stages files. Without a file argument it stages every change
#    (git add .), otherwise it stages the given file or path.
# -----------------------------------------------------------------------------
gAdd() {
    test_git || return 1

    local target="${1:-.}"

    if invoke_git add "$target"; then
        show_git_success "Successfully added: $target"
    else
        show_git_error "Failed to add files: $target"
    fi
}

# -----------------------------------------------------------------------------
#  gRemove <file>
#    Removes a file from the Git repository using `git rm` (deletion staged).
# -----------------------------------------------------------------------------
gRemove() {
    test_git || return 1

    local file="${1:-}"
    if [[ -z "$file" ]]; then
        show_git_error "Usage: gRemove <file>"
        return 1
    fi

    if invoke_git rm "$file"; then
        show_git_success "File removed: $file"
    else
        show_git_error "Failed to remove file: $file"
    fi
}

# -----------------------------------------------------------------------------
#  gUntrack <file>
#    Stops tracking a file without deleting it from disk (git rm --cached).
# -----------------------------------------------------------------------------
gUntrack() {
    test_git || return 1

    local file="${1:-}"
    if [[ -z "$file" ]]; then
        show_git_error "Usage: gUntrack <file>"
        return 1
    fi

    if invoke_git rm --cached "$file"; then
        show_git_success "File untracked (kept on disk): $file"
    else
        show_git_error "Failed to untrack file: $file"
    fi
}

# -----------------------------------------------------------------------------
#  gMove <old> <new>
#    Moves or renames a file using `git mv` so Git keeps tracking the change.
# -----------------------------------------------------------------------------
gMove() {
    test_git || return 1

    local old="${1:-}"
    local new="${2:-}"
    if [[ -z "$old" || -z "$new" ]]; then
        show_git_error "Usage: gMove <old> <new>"
        return 1
    fi

    if invoke_git mv "$old" "$new"; then
        show_git_success "File moved: $old -> $new"
    else
        show_git_error "Failed to move file: $old -> $new"
    fi
}

# -----------------------------------------------------------------------------
#  gCommit [-a|-u|--amend] <message>
#    Creates Git commits with different options:
#      * gCommit <message>          -> normal commit
#      * gCommit -a <message>       -> commit with all tracked changes
#      * gCommit -u <message>       -> shortcut for --amend
#      * gCommit --amend <message>  -> amend the last commit
# -----------------------------------------------------------------------------
gCommit() {
    test_git || return 1

    local git_args=(commit)

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -a)      git_args+=(-a); shift ;;
            -u)      git_args+=(--amend); shift ;;
            --amend) git_args+=(--amend); shift ;;
            *)       break ;;
        esac
    done

    local message="${1:-}"
    if [[ -z "$message" ]]; then
        show_git_error "Usage: gCommit [-a|-u|--amend] <message>"
        return 1
    fi

    git_args+=(-m "$message")

    if invoke_git "${git_args[@]}"; then
        show_git_success "Commit created: $message"
    else
        show_git_error "Failed to create commit"
    fi
}
