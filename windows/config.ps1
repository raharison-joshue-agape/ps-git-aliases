# =============================================================================
#  Config - Git help and configuration helpers.
# =============================================================================

<#
.SYNOPSIS
    Shows Git help.

.DESCRIPTION
    Without arguments displays the general Git help. With a command name
    (commit, push, ...) it displays the help of that specific Git subcommand.

.PARAMETER cmd
    Optional Git subcommand to get help for.

.EXAMPLE
    gHelp
    gHelp commit
#>
function gHelp {
    param([string]$cmd)

    if (-not (Test-Git)) { return }

    if ($cmd) {
        & git help $cmd
    } else {
        & git help
    }
}

<#
.SYNOPSIS
    Reads or writes Git configuration using friendly field names.

.DESCRIPTION
    Small wrapper around `git config`:
      * no field     -> list all values (global scope by default)
      * field only   -> get the current value
      * field+value  -> set the value

.PARAMETER field
    A friendly field name among: name, email, editor, ui, autocrlf,
    defaultbranch, pager, merge, rebase, credentialhelper, signingkey.

.PARAMETER value
    The value to set. Omit it to read the current value.

.PARAMETER g
    Use the global scope (default).

.PARAMETER l
    Use the local repository scope.

.PARAMETER s
    Use the system-wide scope.

.EXAMPLE
    gConfig
    gConfig name
    gConfig name "Ada Lovelace"
    gConfig autocrlf true -l
#>
function gConfig {
    param(
        [Parameter(Position = 0)]
        [ValidateSet("name", "email", "editor", "ui", "autocrlf",
            "defaultbranch", "pager", "merge", "rebase",
            "credentialhelper", "signingkey")]
        [string]$field,

        [Parameter(Position = 1)]
        [string]$value,

        [switch]$g,
        [switch]$l,
        [switch]$s
    )

    if (-not (Test-Git)) { return }

    $level = "global"
    if ($l) { $level = "local" }
    elseif ($s) { $level = "system" }

    $map = @{
        name             = "user.name"
        email            = "user.email"
        editor           = "core.editor"
        ui               = "color.ui"
        autocrlf         = "core.autocrlf"
        defaultbranch    = "init.defaultBranch"
        pager            = "core.pager"
        merge            = "merge.tool"
        rebase           = "pull.rebase"
        credentialhelper = "credential.helper"
        signingkey       = "user.signingkey"
    }

    # No field -> list every value for the selected scope
    if (-not $field) {
        Invoke-Git -Arguments @("config", "--$level", "--list")
        return
    }

    $key = $map[$field]

    # Field without value -> get the current value
    if (-not $value) {
        Invoke-Git -Arguments @("config", "--$level", "--get", $key)
        return
    }

    # Field with value -> set the new value
    if (Invoke-Git -Arguments @("config", "--$level", $key, $value)) {
        Show-GitSuccess "($level) $key = $value"
    } else {
        Show-GitError "Failed to set ($level) $key"
    }
}
