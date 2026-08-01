# =============================================================================
#  Remote - Remote management, push, pull and fetch.
# =============================================================================

<#
.SYNOPSIS
    Manages Git remotes.

.DESCRIPTION
      * no arguments     -> list existing remotes
      * <name> <url>     -> add a new remote (default name: origin)

.PARAMETER remote_name
    Name of the remote (default: origin).

.PARAMETER url
    URL of the remote repository to add.

.EXAMPLE
    gRemote
    gRemote origin https://github.com/user/repo.git
#>
function gRemote {
    param(
        [string]$remote_name = "origin",
        [string]$url
    )

    if (-not (Test-Git)) { return }

    if (-not $url) {
        Invoke-Git -Arguments @("remote", "-v")
        return
    }

    Invoke-Git -Arguments @("remote", "add", $remote_name, $url)
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Remote added: $remote_name -> $url"
    } else {
        Show-GitError "Failed to manage remote: $remote_name"
    }
}

<#
.SYNOPSIS
    Pushes commits to a remote repository.

.DESCRIPTION
    Without a branch, pushes the current branch to the given remote.

.PARAMETER remote_name
    Name of the remote (default: origin).

.PARAMETER branch_name
    Branch to push. When omitted, the current branch is used.

.EXAMPLE
    gPush
    gPush origin main
#>
function gPush {
    param(
        [string]$remote_name = "origin",
        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if (-not $branch_name) {
        $branch_name = git branch --show-current
        if (-not $branch_name) {
            Show-GitError "Unable to detect current branch"
            return
        }
    }

    Invoke-Git -Arguments @("push", $remote_name, $branch_name)
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Pushed: $remote_name/$branch_name"
    } else {
        Show-GitError "Failed to push: $remote_name/$branch_name"
    }
}

<#
.SYNOPSIS
    Pulls changes from a remote repository.

.DESCRIPTION
    Without a branch, pulls the current branch from the given remote.

.PARAMETER remote_name
    Name of the remote (default: origin).

.PARAMETER branch_name
    Branch to pull. When omitted, the current branch is used.

.EXAMPLE
    gPull
    gPull origin main
#>
function gPull {
    param(
        [string]$remote_name = "origin",
        [string]$branch_name
    )

    if (-not (Test-Git)) { return }

    if (-not $branch_name) {
        $branch_name = git branch --show-current
        if (-not $branch_name) {
            Show-GitError "Unable to detect current branch"
            return
        }
    }

    Invoke-Git -Arguments @("pull", $remote_name, $branch_name)
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Pulled: $remote_name/$branch_name"
    } else {
        Show-GitError "Failed to pull: $remote_name/$branch_name"
    }
}

<#
.SYNOPSIS
    Fetches updates from a remote repository without merging.

.PARAMETER remote_name
    Name of the remote to fetch from (default: origin).

.EXAMPLE
    gFetch
    gFetch origin
#>
function gFetch {
    param(
        [string]$remote_name = "origin"
    )

    if (-not (Test-Git)) { return }

    Invoke-Git -Arguments @("fetch", $remote_name)
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess "Fetched from: $remote_name"
    } else {
        Show-GitError "Failed to fetch from: $remote_name"
    }
}
