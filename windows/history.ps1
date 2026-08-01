# =============================================================================
#  History - Log, show, restore, reset, revert, cherry-pick, reflog and stash.
# =============================================================================

<#
.SYNOPSIS
    Displays Git commit history in different formats.

.PARAMETER type
    View mode: oneline, graph, stat, patch, pretty or all.

.EXAMPLE
    gLog
    gLog oneline
    gLog graph
    gLog pretty
#>
function gLog {
    param(
        [ValidateSet("oneline", "graph", "stat", "patch", "pretty", "all")]
        [string]$type
    )

    if (-not (Test-Git)) { return }

    switch ($type) {
        "oneline" { $gitArgs = @("log", "--oneline") }
        "graph"   { $gitArgs = @("log", "--oneline", "--graph", "--all") }
        "stat"    { $gitArgs = @("log", "--stat") }
        "patch"   { $gitArgs = @("log", "-p") }
        "pretty"  { $gitArgs = @("log", "--pretty=format:%h - %an, %ar : %s") }
        "all"     { $gitArgs = @("log", "--oneline", "--graph", "--decorate", "--all") }
        default   { $gitArgs = @("log") }
    }

    Invoke-Git -Arguments $gitArgs
}

<#
.SYNOPSIS
    Shows the details of a specific commit.

.PARAMETER commit
    Commit reference (hash, branch or tag).

.EXAMPLE
    gShow 4c2f1a9
#>
function gShow {
    param(
        [Parameter(Mandatory = $true)]
        [string]$commit
    )

    if (-not (Test-Git)) { return }
    Invoke-Git -Arguments @("show", $commit)
}

<#
.SYNOPSIS
    Restores files from the staging area or the working directory.

.DESCRIPTION
      * gRestore <file>          -> discard working directory changes
      * gRestore -staged <file>  -> unstage the file

.PARAMETER staged
    Unstage the file instead of restoring the working tree.

.PARAMETER file
    File to restore or unstage.

.EXAMPLE
    gRestore main.ps1
    gRestore -staged main.ps1
#>
function gRestore {
    param(
        [switch]$staged,
        [Parameter(Mandatory = $true)]
        [string]$file
    )

    if (-not (Test-Git)) { return }

    if ($staged) {
        if (Invoke-Git -Arguments @("restore", "--staged", $file)) {
            Show-GitSuccess "File unstaged: $file"
        } else {
            Show-GitError "Failed to unstage file: $file"
        }
    } else {
        if (Invoke-Git -Arguments @("restore", $file)) {
            Show-GitSuccess "File restored: $file"
        } else {
            Show-GitError "Failed to restore file: $file"
        }
    }
}

<#
.SYNOPSIS
    Resets Git state.

.DESCRIPTION
      * -h <commit>        -> hard reset (destructive)
      * -s <commit>        -> soft reset (keep changes)
      * <file>             -> unstage the file
      * <commit> <file>    -> reset the file to a specific commit

.PARAMETER h
    Perform a hard reset (discards changes).

.PARAMETER s
    Perform a soft reset (keeps changes staged).

.PARAMETER arg1
    A commit reference, or a file to unstage.

.PARAMETER arg2
    A file to reset when arg1 is a commit.

.EXAMPLE
    gReset -h HEAD~1
    gReset -s 3d92b7a
    gReset main.ps1
    gReset 3d92b7a main.ps1
#>
function gReset {
    param(
        [switch]$h,
        [switch]$s,
        [string]$arg1,
        [string]$arg2
    )

    if (-not (Test-Git)) { return }

    if ($h -and $s) {
        Show-GitError "Use either -h or -s, not both"
        return
    }

    if ($h) {
        $ok  = Invoke-Git -Arguments @("reset", "--hard", $arg1)
        $msg = "Hard reset to: $arg1"
    }
    elseif ($s) {
        $ok  = Invoke-Git -Arguments @("reset", "--soft", $arg1)
        $msg = "Soft reset to: $arg1"
    }
    elseif ($arg1 -and $arg2) {
        $ok  = Invoke-Git -Arguments @("reset", $arg1, "--", $arg2)
        $msg = "File reset: $arg2 -> $arg1"
    }
    elseif ($arg1) {
        $ok  = Invoke-Git -Arguments @("reset", "HEAD", "--", $arg1)
        $msg = "Unstaged: $arg1"
    }
    else {
        Show-GitError "Invalid usage"
        return
    }

    if ($ok) { Show-GitSuccess $msg } else { Show-GitError "Reset operation failed" }
}

<#
.SYNOPSIS
    Reverts a commit by creating a new commit that undoes it.

.PARAMETER commit
    Commit reference to revert.

.EXAMPLE
    gRevert 4c2f1a9
#>
function gRevert {
    param(
        [Parameter(Mandatory = $true)]
        [string]$commit
    )

    if (-not (Test-Git)) { return }

    if (Invoke-Git -Arguments @("revert", $commit)) {
        Show-GitSuccess "Commit reverted: $commit"
    } else {
        Show-GitError "Failed to revert commit: $commit"
    }
}

<#
.SYNOPSIS
    Applies a specific commit using cherry-pick.

.PARAMETER commit
    Commit reference to cherry-pick onto the current branch.

.EXAMPLE
    gCherryPick 4c2f1a9
#>
function gCherryPick {
    param(
        [Parameter(Mandatory = $true)]
        [string]$commit
    )

    if (-not (Test-Git)) { return }

    if (Invoke-Git -Arguments @("cherry-pick", $commit)) {
        Show-GitSuccess "Cherry-picked commit: $commit"
    } else {
        Show-GitError "Failed to cherry-pick commit: $commit"
    }
}

<#
.SYNOPSIS
    Shows the Git reflog history.

.DESCRIPTION
    Useful for recovering commits that are no longer referenced by any
    branch.

.EXAMPLE
    gReflog
#>
function gReflog {
    if (-not (Test-Git)) { return }
    Invoke-Git -Arguments @("reflog")
}

<#
.SYNOPSIS
    Manages Git stash entries.

.DESCRIPTION
      * no argument    -> save the current changes
      * list           -> list saved stashes
      * pop [index]    -> apply and remove the latest stash
      * apply [index]  -> apply a stash without removing it
      * drop [index]   -> delete a stash
      * clear          -> remove every stash

.PARAMETER type
    Stash operation: list, pop, apply, drop or clear.

.PARAMETER index
    Stash index used by pop/apply/drop (default: 0).

.EXAMPLE
    gStash
    gStash list
    gStash pop
    gStash apply 1
#>
function gStash {
    param(
        [ValidateSet("list", "pop", "apply", "drop", "clear")]
        [string]$type,

        [int]$index = 0
    )

    if (-not (Test-Git)) { return }

    $target = "stash@{$index}"

    $successMessage = $null
    switch ($type) {
        "list"  { $gitArgs = @("stash", "list") }
        "pop"   { $gitArgs = @("stash", "pop", $target); $successMessage = "Stash popped: $index" }
        "apply" { $gitArgs = @("stash", "apply", $target); $successMessage = "Stash applied: $index" }
        "drop"  { $gitArgs = @("stash", "drop", $target); $successMessage = "Stash dropped: $index" }
        "clear" { $gitArgs = @("stash", "clear"); $successMessage = "All stashes cleared" }
        default { $gitArgs = @("stash"); $successMessage = "Changes stashed" }
    }

    if (Invoke-Git -Arguments $gitArgs) {
        if ($successMessage) { Show-GitSuccess $successMessage }
    } else {
        Show-GitError "Stash operation failed: $type"
    }
}
