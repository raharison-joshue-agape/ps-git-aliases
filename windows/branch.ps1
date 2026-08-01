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
            Invoke-Git -Arguments @("branch", "-d", $branch_name)
            if ($LASTEXITCODE -eq 0) {
                Show-GitSuccess "Branch deleted: $branch_name"
            } else {
                Show-GitError "Failed to delete branch: $branch_name"
            }
        }
        "-D" {
            Invoke-Git -Arguments @("branch", "-D", $branch_name)
            if ($LASTEXITCODE -eq 0) {
                Show-GitSuccess "Branch force deleted: $branch_name"
            } else {
                Show-GitError "Failed to force delete branch: $branch_name"
            }
        }
        default {
            Invoke-Git -Arguments @("branch", $branch_name)
            if ($LASTEXITCODE -eq 0) {
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
        Invoke-Git -Arguments @("checkout", "-b", $branch_name)
        if ($LASTEXITCODE -eq 0) {
            Show-GitSuccess "Branch created and switched: $branch_name"
        } else {
            Show-GitError "Failed to create branch: $branch_name"
        }
    } else {
        Invoke-Git -Arguments @("checkout", $branch_name)
        if ($LASTEXITCODE -eq 0) {
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

    Invoke-Git -Arguments @("switch", $branch_name)
    if ($LASTEXITCODE -eq 0) {
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

    Invoke-Git -Arguments @("merge", $branch_name)
    if ($LASTEXITCODE -eq 0) {
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

    Invoke-Git -Arguments @("rebase", $branch_name)
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Rebased onto branch: $branch_name"
    } else {
        Show-GitError "Rebase failed on: $branch_name"
    }
}

<#
.SYNOPSIS
    Manages Git worktrees.

.DESCRIPTION
      * list                  -> list all worktrees
      * add <path> [branch]   -> create a worktree, optionally from a new branch
      * remove <path>         -> remove a worktree

.PARAMETER type
    Worktree operation: add, list or remove.

.PARAMETER path
    Filesystem path of the worktree to add or remove.

.PARAMETER branch
    Branch to create in the new worktree (only used with add).

.EXAMPLE
    gWorktree
    gWorktree add ../feature-login
    gWorktree add ../feature-login feature-login
    gWorktree remove ../feature-login
#>
function gWorktree {
    param(
        [ValidateSet("add", "list", "remove")]
        [string]$type = "list",

        [string]$path,
        [string]$branch
    )

    if (-not (Test-Git)) { return }

    switch ($type) {
        "list" {
            Invoke-Git -Arguments @("worktree", "list")
            return
        }

        "add" {
            if (-not $path) {
                Show-GitError "Usage: gWorktree add <path> [branch]"
                return
            }
            $gitArgs = @("worktree", "add", $path)
            if ($branch) { $gitArgs += @("-b", $branch) }
            $successMessage = "Worktree added: $path"
        }

        "remove" {
            if (-not $path) {
                Show-GitError "Usage: gWorktree remove <path>"
                return
            }
            $gitArgs        = @("worktree", "remove", $path)
            $successMessage = "Worktree removed: $path"
        }
    }

    Invoke-Git -Arguments $gitArgs
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess $successMessage
    } else {
        Show-GitError "Worktree operation failed: $type"
    }
}

<#
.SYNOPSIS
    Aborts a merge that is in progress (git merge --abort).

.EXAMPLE
    gMergeAbort
#>
function gMergeAbort {
    if (-not (Test-Git)) { return }

    Invoke-Git -Arguments @("merge", "--abort")
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Merge aborted"
    } else {
        Show-GitError "Failed to abort merge"
    }
}

<#
.SYNOPSIS
    Continues a merge after resolving the conflicts (git merge --continue).

.EXAMPLE
    gMergeContinue
#>
function gMergeContinue {
    if (-not (Test-Git)) { return }

    Invoke-Git -Arguments @("merge", "--continue")
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Merge continued"
    } else {
        Show-GitError "Failed to continue merge"
    }
}

<#
.SYNOPSIS
    Aborts a rebase that is in progress (git rebase --abort).

.EXAMPLE
    gRebaseAbort
#>
function gRebaseAbort {
    if (-not (Test-Git)) { return }

    Invoke-Git -Arguments @("rebase", "--abort")
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Rebase aborted"
    } else {
        Show-GitError "Failed to abort rebase"
    }
}

<#
.SYNOPSIS
    Continues a rebase after resolving the conflicts (git rebase --continue).

.EXAMPLE
    gRebaseContinue
#>
function gRebaseContinue {
    if (-not (Test-Git)) { return }

    Invoke-Git -Arguments @("rebase", "--continue")
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Rebase continued"
    } else {
        Show-GitError "Failed to continue rebase"
    }
}
