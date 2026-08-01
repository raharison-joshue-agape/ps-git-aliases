# =============================================================================
#  Submodule - Manage Git submodules.
# =============================================================================

<#
.SYNOPSIS
    Manages Git submodules.

.DESCRIPTION
      * status                  -> show submodule status
      * add <url> [path]        -> register a new submodule
      * init                    -> initialize registered submodules
      * update                  -> fetch and check out the recorded commit
      * sync                    -> sync submodule URLs with remote config

.PARAMETER type
    Submodule operation: add, init, update, sync or status.

.PARAMETER url
    Repository URL of the submodule (only used with add).

.PARAMETER path
    Destination folder of the submodule (only used with add).

.EXAMPLE
    gSubmodule
    gSubmodule add https://github.com/user/lib.git lib
    gSubmodule init
    gSubmodule update
    gSubmodule sync
#>
function gSubmodule {
    param(
        [ValidateSet("add", "init", "update", "sync", "status")]
        [string]$type = "status",

        [string]$url,
        [string]$path
    )

    if (-not (Test-Git)) { return }

    switch ($type) {
        "add" {
            if (-not $url) {
                Show-GitError "Usage: gSubmodule add <url> [path]"
                return
            }
            $gitArgs = @("submodule", "add", $url)
            if ($path) { $gitArgs += $path }
            $successMessage = "Submodule added: $url"
        }

        "init" {
            $gitArgs        = @("submodule", "init")
            $successMessage = "Submodules initialized"
        }

        "update" {
            $gitArgs        = @("submodule", "update")
            $successMessage = "Submodules updated"
        }

        "sync" {
            $gitArgs        = @("submodule", "sync")
            $successMessage = "Submodules synced"
        }

        default {
            Invoke-Git -Arguments @("submodule", "status")
            return
        }
    }

    Invoke-Git -Arguments $gitArgs
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess $successMessage
    } else {
        Show-GitError "Submodule operation failed: $type"
    }
}
