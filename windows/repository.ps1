# =============================================================================
#  Repository - Init, clone, status and clean operations.
# =============================================================================

<#
.SYNOPSIS
    Initializes a new Git repository.

.DESCRIPTION
    Creates a Git repository and optionally stages every file and creates
    an initial commit.

.PARAMETER c
    When set, also runs `git add .` and creates an initial commit.

.PARAMETER message
    Commit message used with -c (default: "Initial commit").

.EXAMPLE
    gInit
    gInit -c
    gInit -c "My first commit"
#>
function gInit {
    param(
        [switch]$c,
        [string]$message = "Initial commit"
    )

    if (-not (Test-Git)) { return }

    if (-not (Invoke-Git -Arguments @("init"))) {
        Show-GitError "Failed to initialize Git repository"
        return
    }

    if (-not $c) {
        Show-GitSuccess "Repository initialized successfully"
        return
    }

    if (-not (Invoke-Git -Arguments @("add", "."))) {
        Show-GitError "Failed to stage files (git add)"
        return
    }

    if (-not (Invoke-Git -Arguments @("commit", "-m", $message))) {
        Show-GitError "Failed to create commit"
        return
    }

    Show-GitSuccess "Repository initialized and committed: $message"
}

<#
.SYNOPSIS
    Clones a Git repository.

.DESCRIPTION
    Accepts either `gClone <url> [folder]` or, when the first argument is
    not a URL, `gClone <branch> <url> [folder]` to clone a specific branch.

.PARAMETER arg1
    The URL (or the branch name when a URL is given in arg2).

.PARAMETER arg2
    The destination folder, or the URL when arg1 is a branch.

.PARAMETER arg3
    The destination folder when a branch is used.

.EXAMPLE
    gClone https://github.com/user/repo.git
    gClone https://github.com/user/repo.git my-folder
    gClone main https://github.com/user/repo.git my-folder
#>
function gClone {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$arg1,

        [Parameter(Position = 1)]
        [string]$arg2,

        [Parameter(Position = 2)]
        [string]$arg3
    )

    if (-not (Test-Git)) { return }

    $isUrl = $arg1 -match '^(https?://|git@|ssh://|[\w.-]+@[\w.-]+:)'

    if ($isUrl) {
        $url    = $arg1
        $folder = $arg2
        $branch = $null
    } else {
        $branch = $arg1
        $url    = $arg2
        $folder = $arg3
    }

    if (-not $url) {
        Show-GitError "Invalid usage:"
        Write-Host "  gClone <url>"
        Write-Host "  gClone <url> [folder]"
        Write-Host "  gClone <branch> <url> [folder]"
        return
    }

    $gitArgs = @("clone")
    if ($branch) { $gitArgs += @("-b", $branch) }
    $gitArgs += $url
    if ($folder) { $gitArgs += $folder }

    if (Invoke-Git -Arguments $gitArgs) {
        Show-GitSuccess "Repository cloned successfully"
    } else {
        Show-GitError "Failed to clone repository"
    }
}

<#
.SYNOPSIS
    Displays the current Git repository status.

.EXAMPLE
    gStatus
#>
function gStatus {
    if (-not (Test-Git)) { return }
    Invoke-Git -Arguments @("status")
}

<#
.SYNOPSIS
    Removes untracked files from the working directory.

.DESCRIPTION
    By default (and with -dry) this is a safe dry run that only shows what
    would be removed. Use -force to actually delete the untracked files.

.PARAMETER force
    Actually delete the untracked files (destructive).

.PARAMETER dry
    Preview only, show what would be removed (default).

.EXAMPLE
    gClean
    gClean -dry
    gClean -force
#>
function gClean {
    param(
        [switch]$force,
        [switch]$dry
    )

    if (-not (Test-Git)) { return }

    $gitArgs = @("clean")

    if ($force) { $gitArgs += "-f" }
    if ($dry)   { $gitArgs += "-n" }

    # Default to a safe preview so `gClean` alone never deletes anything.
    if (-not $force -and -not $dry) { $gitArgs += "-n" }

    if (Invoke-Git -Arguments $gitArgs) {
        Show-GitSuccess "Executed: git $($gitArgs -join ' ')"
    } else {
        Show-GitError "Failed to execute git clean"
    }
}
