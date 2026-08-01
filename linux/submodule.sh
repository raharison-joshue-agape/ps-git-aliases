# =============================================================================
#  Submodule - Manage Git submodules.
#  Equivalent of windows/submodule.ps1 for bash.
# =============================================================================

# -----------------------------------------------------------------------------
#  gSubmodule [type] [url] [path]
#    Manages Git submodules (default: status):
#      * add <url> [path]        -> register a new submodule
#      * init                    -> initialize registered submodules
#      * update                  -> fetch and check out the recorded commit
#      * sync                    -> sync submodule URLs with remote config
#      * status                  -> show submodule status
# -----------------------------------------------------------------------------
gSubmodule() {
    test_git || return 1

    local type="${1:-status}"
    local url=""
    local path=""

    [[ $# -gt 0 ]] && shift
    url="${1:-}"
    [[ $# -gt 0 ]] && shift
    path="${1:-}"

    local git_args=()
    local success_message=""

    case "$type" in
        add)
            if [[ -z "$url" ]]; then
                show_git_error "Usage: gSubmodule add <url> [path]"
                return 1
            fi
            git_args=(submodule add "$url")
            if [[ -n "$path" ]]; then
                git_args+=("$path")
            fi
            success_message="Submodule added: $url"
            ;;
        init)
            git_args=(submodule init)
            success_message="Submodules initialized"
            ;;
        update)
            git_args=(submodule update)
            success_message="Submodules updated"
            ;;
        sync)
            git_args=(submodule sync)
            success_message="Submodules synced"
            ;;
        *)
            invoke_git submodule status
            return
            ;;
    esac

    if invoke_git "${git_args[@]}"; then
        show_git_success "$success_message"
    else
        show_git_error "Submodule operation failed: $type"
    fi
}
