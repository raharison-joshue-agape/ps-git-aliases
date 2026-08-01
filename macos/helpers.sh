# =============================================================================
#  Helpers - Shared utilities used by every Git alias function.
#  Written for Zsh (default shell on macOS) and Bash-compatible.
# =============================================================================

# -----------------------------------------------------------------------------
#  show_git_error <message>
#    Prints a red error message prefixed with ❌.
# -----------------------------------------------------------------------------
show_git_error() {
    printf "\033[31m❌ %s\033[0m\n" "$1"
}

# -----------------------------------------------------------------------------
#  show_git_success <message>
#    Prints a green success message prefixed with ✅.
# -----------------------------------------------------------------------------
show_git_success() {
    printf "\033[32m✅ %s\033[0m\n" "$1"
}

# -----------------------------------------------------------------------------
#  test_git
#    Checks that the git executable is available.
#    Returns 0 when git is installed and reachable from PATH, 1 otherwise.
#    Usage:
#        test_git || return 1
# -----------------------------------------------------------------------------
test_git() {
    if ! command -v git >/dev/null 2>&1; then
        show_git_error "Git is not installed or not available in PATH"
        return 1
    fi
    return 0
}

# -----------------------------------------------------------------------------
#  invoke_git <git args...>
#    Thin wrapper around the git executable. Git output flows normally to
#    stdout/stderr, so it can still be piped. Check $? right after the call
#    to know whether the command succeeded.
#    Usage:
#        invoke_git status
#        if [[ $? -eq 0 ]]; then show_git_success "OK"; fi
# -----------------------------------------------------------------------------
invoke_git() {
    git "$@"
}
