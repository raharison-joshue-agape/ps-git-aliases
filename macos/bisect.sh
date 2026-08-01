# =============================================================================
#  Bisect - Bug hunting with a binary search over the commit history.
#  Written for Zsh (default shell on macOS) and Bash-compatible.
# =============================================================================

# -----------------------------------------------------------------------------
#  gBisect [action] [commit]
#    Helps identify bugs using Git bisect:
#      * start          -> begin the bisect process (default)
#      * good [commit]  -> mark a commit as good (default: HEAD)
#      * bad [commit]   -> mark a commit as bad (default: HEAD)
#      * reset          -> stop the bisect process
# -----------------------------------------------------------------------------
gBisect() {
    test_git || return 1

    local action="${1:-start}"
    local commit="${2:-}"

    local git_args=(bisect "$action")
    local success_message=""

    case "$action" in
        start)
            success_message="Bisect started"
            ;;
        good)
            if [[ -n "$commit" ]]; then
                git_args+=("$commit")
            fi
            success_message="Marked as good: $commit"
            ;;
        bad)
            if [[ -n "$commit" ]]; then
                git_args+=("$commit")
            fi
            success_message="Marked as bad: $commit"
            ;;
        reset)
            success_message="Bisect reset"
            ;;
    esac

    if invoke_git "${git_args[@]}"; then
        show_git_success "$success_message"
    else
        show_git_error "Bisect operation failed: $action"
    fi
}
