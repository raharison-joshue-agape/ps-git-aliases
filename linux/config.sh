# =============================================================================
#  Config - Git help and configuration helpers.
#  Equivalent of windows/config.ps1 for bash.
# =============================================================================

# -----------------------------------------------------------------------------
#  gHelp [cmd]
#    Shows Git help. Without arguments displays the general help, with a
#    command name (commit, push, ...) the help of that specific subcommand.
# -----------------------------------------------------------------------------
gHelp() {
    test_git || return 1

    if [[ -n "${1:-}" ]]; then
        invoke_git help "$1"
    else
        invoke_git help
    fi
}

# -----------------------------------------------------------------------------
#  gConfig [field] [value] [-g|-l|-s]
#    Reads or writes Git configuration using friendly field names.
#      * no field     -> list all values (global scope by default)
#      * field only   -> get the current value
#      * field+value  -> set the value
#
#    field is one of: name, email, editor, ui, autocrlf, defaultbranch,
#    pager, merge, rebase, credentialhelper, signingkey.
#    -g global (default), -l local repository, -s system-wide.
# -----------------------------------------------------------------------------
gConfig() {
    test_git || return 1

    local field=""
    local value=""
    local level="global"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -g) level="global"; shift ;;
            -l) level="local"; shift ;;
            -s) level="system"; shift ;;
            *)
                if [[ -z "$field" ]]; then
                    field="$1"
                else
                    value="$1"
                fi
                shift
                ;;
        esac
    done

    local key=""
    case "$field" in
        name)             key="user.name" ;;
        email)            key="user.email" ;;
        editor)           key="core.editor" ;;
        ui)               key="color.ui" ;;
        autocrlf)         key="core.autocrlf" ;;
        defaultbranch)    key="init.defaultBranch" ;;
        pager)            key="core.pager" ;;
        merge)            key="merge.tool" ;;
        rebase)           key="pull.rebase" ;;
        credentialhelper) key="credential.helper" ;;
        signingkey)       key="user.signingkey" ;;
        "")               key="" ;;
        *)                key="" ;;
    esac

    # No field -> list every value for the selected scope
    if [[ -z "$field" ]]; then
        invoke_git config "--$level" --list
        return
    fi

    # Unknown field -> friendly error (the PowerShell version uses ValidateSet)
    if [[ -z "$key" ]]; then
        show_git_error "Invalid field: $field"
        return 1
    fi

    # Field without value -> get the current value
    if [[ -z "$value" ]]; then
        invoke_git config "--$level" --get "$key"
        return
    fi

    # Field with value -> set the new value
    if invoke_git config "--$level" "$key" "$value"; then
        show_git_success "($level) $key = $value"
    else
        show_git_error "Failed to set ($level) $key"
    fi
}
