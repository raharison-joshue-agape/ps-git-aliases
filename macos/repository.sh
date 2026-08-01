# =============================================================================
#  Repository - Init, clone, status and clean operations.
#  Written for Zsh (default shell on macOS) and Bash-compatible.
# =============================================================================

# -----------------------------------------------------------------------------
#  gInit [-c] [message]
#    Initializes a new Git repository. With -c, also stages every file and
#    creates an initial commit (message defaults to "Initial commit").
# -----------------------------------------------------------------------------
gInit() {
    test_git || return 1

    local c=0
    local message="Initial commit"
    local first=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c) c=1; shift ;;
            *)
                if [[ -z "$first" ]]; then
                    first="$1"
                fi
                shift
                ;;
        esac
    done

    if [[ -n "$first" ]]; then
        message="$first"
    fi

    if ! invoke_git init; then
        show_git_error "Failed to initialize Git repository"
        return 1
    fi

    if (( ! c )); then
        show_git_success "Repository initialized successfully"
        return 0
    fi

    if ! invoke_git add .; then
        show_git_error "Failed to stage files (git add)"
        return 1
    fi

    if ! invoke_git commit -m "$message"; then
        show_git_error "Failed to create commit"
        return 1
    fi

    show_git_success "Repository initialized and committed: $message"
}

# -----------------------------------------------------------------------------
#  gClone <url> [folder]
#  gClone <branch> <url> [folder]
#    Clones a repository. When the first argument is not a URL, it is treated
#    as a branch to clone (`git clone -b <branch> <url> [folder]`).
# -----------------------------------------------------------------------------
gClone() {
    test_git || return 1

    local arg1="${1:-}"
    local arg2="${2:-}"
    local arg3="${3:-}"

    local url=""
    local folder=""
    local branch=""

    # Detects URLs (https, ssh, git@, scp-like, file://) and existing local
    # directory paths (native way to clone a local repository).
    if [[ "$arg1" =~ ^(https?://|git@|ssh://|file://|[[:alnum:]_.-]+@[[:alnum:]_.-]+:) ]] || [[ -d "$arg1" ]]; then
        url="$arg1"
        folder="$arg2"
    else
        branch="$arg1"
        url="$arg2"
        folder="$arg3"
    fi

    if [[ -z "$url" ]]; then
        show_git_error "Invalid usage:"
        printf "  gClone <url>\n"
        printf "  gClone <url> [folder]\n"
        printf "  gClone <branch> <url> [folder]\n"
        return 1
    fi

    local git_args=(clone)
    if [[ -n "$branch" ]]; then
        git_args+=(-b "$branch")
    fi
    git_args+=("$url")
    if [[ -n "$folder" ]]; then
        git_args+=("$folder")
    fi

    if invoke_git "${git_args[@]}"; then
        show_git_success "Repository cloned successfully"
    else
        show_git_error "Failed to clone repository"
    fi
}

# -----------------------------------------------------------------------------
#  gStatus
#    Displays the current Git repository status.
# -----------------------------------------------------------------------------
gStatus() {
    test_git || return 1
    invoke_git status
}

# -----------------------------------------------------------------------------
#  gClean [-force] [-dry]
#    Removes untracked files. By default (and with -dry) this is a safe
#    preview. Use -force to actually delete the untracked files.
# -----------------------------------------------------------------------------
gClean() {
    test_git || return 1

    local force=0
    local dry=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -force) force=1; shift ;;
            -dry)   dry=1; shift ;;
            *)      shift ;;
        esac
    done

    local git_args=(clean)
    if (( force )); then git_args+=(-f); fi
    if (( dry )); then git_args+=(-n); fi

    # Default to a safe preview so `gClean` alone never deletes anything.
    if (( ! force && ! dry )); then
        git_args+=(-n)
    fi

    if invoke_git "${git_args[@]}"; then
        show_git_success "Executed: git ${git_args[*]}"
    else
        show_git_error "Failed to execute git clean"
    fi
}

# -----------------------------------------------------------------------------
#  gArchive <output> [ref]
#    Creates an archive (zip, tar, ...) of a commit or branch. The format is
#    guessed from the output file extension. Default ref is HEAD.
# -----------------------------------------------------------------------------
gArchive() {
    test_git || return 1

    local output="${1:-}"
    local ref="${2:-HEAD}"

    if [[ -z "$output" ]]; then
        show_git_error "Usage: gArchive <output> [ref]"
        return 1
    fi

    if invoke_git archive -o "$output" "$ref"; then
        show_git_success "Archive created: $output"
    else
        show_git_error "Failed to create archive"
    fi
}
