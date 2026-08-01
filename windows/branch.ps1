# =============================================================================
#  Branch - Branch management, switching, merging and rebasing.
# =============================================================================

<#
.SYNOPSIS
    Manages Git branches.

.DESCRIPTION
      * no argument    -> list branches
      * <name>         -> create a branch
      * -d <name>      -> delete a branch (safe)
      * -D <name>      -> force delete a branch

.PARAMETER type
    Delete mode: -d (safe) or -D (force).

.PARAMETER branch_name
    Name of the branch to create or delete.

.EXAMPLE
    gBranch
    gBranch feature-login
    gBranch -d feature-login
    gBranch -D feature-login
#>
function gBranch {
    param(
        [ValidateSet("-d", "-D")]
        [string]$type,

        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if (-not $branch_name) {
        Invoke-Git -Arguments @("branch")
        return
    }

    switch ($type) {
        "-d" {
            if (Invoke-Git -Arguments @("branch", "-d", $branch_name)) {
                Show-GitSuccess "Branch deleted: $branch_name"
            } else {
                Show-GitError "Failed to delete branch: $branch_name"
            }
        }
        "-D" {
            if (Invoke-Git -Arguments @("branch", "-D", $branch_name)) {
                Show-GitSuccess "Branch force deleted: $branch_name"
            } else {
                Show-GitError "Failed to force delete branch: $branch_name"
            }
        }
        default {
            if (Invoke-Git -Arguments @("branch", $branch_name)) {
                Show-GitSuccess "Branch created: $branch_name"
            } else {
                Show-GitError "Failed to create branch: $branch_name"
            }
        }
    }
}

<#
.SYNOPSIS
    Checks out a Git branch.

.DESCRIPTION
    Switches to an existing branch, or creates and switches to a new one
    when -b is used.

.PARAMETER b
    Create the branch if it does not exist, then switch to it.

.PARAMETER branch_name
    Name of the branch to check out.

.EXAMPLE
    gCheck main
    gCheck -b feature-login
#>
function gCheck {
    param(
        [switch]$b,
        [Parameter(Mandatory = $true)]
        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if ($b) {
        if (Invoke-Git -Arguments @("checkout", "-b", $branch_name)) {
            Show-GitSuccess "Branch created and switched: $branch_name"
        } else {
            Show-GitError "Failed to create branch: $branch_name"
        }
    } else {
        if (Invoke-Git -Arguments @("checkout", $branch_name)) {
            Show-GitSuccess "Switched to branch: $branch_name"
        } else {
            Show-GitError "Failed to checkout branch: $branch_name"
        }
    }
}

<#
.SYNOPSIS
    Switches between Git branches using `git switch`.

.PARAMETER branch_name
    Name of the branch to switch to.

.EXAMPLE
    gSwitch main
#>
function gSwitch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if (Invoke-Git -Arguments @("switch", $branch_name)) {
        Show-GitSuccess "Switched to branch: $branch_name"
    } else {
        Show-GitError "Failed to switch to branch: $branch_name"
    }
}

<#
.SYNOPSIS
    Merges a Git branch into the current branch.

.PARAMETER branch_name
    Branch to merge into the current branch.

.EXAMPLE
    gMerge feature-login
#>
function gMerge {
    param(
        [Parameter(Mandatory = $true)]
        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if (Invoke-Git -Arguments @("merge", $branch_name)) {
        Show-GitSuccess "Merge completed: $branch_name"
    } else {
        Show-GitError "Merge failed: $branch_name"
    }
}

<#
.SYNOPSIS
    Rebases the current branch onto another branch.

.PARAMETER branch_name
    Branch to rebase onto.

.EXAMPLE
    gRebase main
#>
function gRebase {
    param(
        [Parameter(Mandatory = $true)]
        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if (Invoke-Git -Arguments @("rebase", $branch_name)) {
        Show-GitSuccess "Rebased onto branch: $branch_name"
    } else {
        Show-GitError "Rebase failed on: $branch_name"
    }
}
