# =============================================================================
#  Tags - Tag management and tag pushing.
#  Equivalent of windows/tags.ps1 for bash.
# =============================================================================

# -----------------------------------------------------------------------------
#  gTag [type] [name] [message]
#    Manages Git tags:
#      * no argument            -> list all tags
#      * create <name>          -> create a lightweight tag
#      * annotate <name> <msg>  -> create an annotated tag
#      * delete <name>          -> delete a local tag
#      * show <name>            -> show tag details
# -----------------------------------------------------------------------------
gTag() {
    test_git || return 1

    local type="${1:-list}"
    local name=""
    local message=""

    [[ $# -gt 0 ]] && shift
    name="${1:-}"
    [[ $# -gt 0 ]] && shift
    message="${1:-}"

    local git_args=()
    local success_message=""

    case "$type" in
        list)
            invoke_git tag
            return
            ;;
        create)
            if [[ -z "$name" ]]; then
                show_git_error "Usage: gTag create <tag_name>"
                return 1
            fi
            git_args=(tag "$name")
            success_message="Tag created: $name"
            ;;
        annotate)
            if [[ -z "$name" || -z "$message" ]]; then
                show_git_error "Usage: gTag annotate <tag_name> <message>"
                return 1
            fi
            git_args=(tag -a "$name" -m "$message")
            success_message="Annotated tag created: $name"
            ;;
        delete)
            if [[ -z "$name" ]]; then
                show_git_error "Usage: gTag delete <tag_name>"
                return 1
            fi
            git_args=(tag -d "$name")
            success_message="Tag deleted: $name"
            ;;
        show)
            if [[ -z "$name" ]]; then
                show_git_error "Usage: gTag show <tag_name>"
                return 1
            fi
            invoke_git show "$name"
            return
            ;;
        *)
            invoke_git tag
            return
            ;;
    esac

    if invoke_git "${git_args[@]}"; then
        show_git_success "$success_message"
    else
        show_git_error "Tag operation failed: $type"
    fi
}

# -----------------------------------------------------------------------------
#  gPushTag [remote] [tag]
#    Pushes Git tags to a remote repository (default remote: origin).
#      * no tag  -> push every local tag
#      * <tag>   -> push a single tag
# -----------------------------------------------------------------------------
gPushTag() {
    test_git || return 1

    local remote_name="${1:-origin}"
    local tag_name="${2:-}"

    if [[ -z "$tag_name" ]]; then
        if invoke_git push "$remote_name" --tags; then
            show_git_success "All tags pushed to $remote_name"
        else
            show_git_error "Failed to push tag"
        fi
    else
        if invoke_git push "$remote_name" "$tag_name"; then
            show_git_success "Tag pushed: $tag_name -> $remote_name"
        else
            show_git_error "Failed to push tag"
        fi
    fi
}
