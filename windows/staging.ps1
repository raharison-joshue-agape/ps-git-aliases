# =============================================================================
#  Staging - Working directory and commit operations.
# =============================================================================

<#
.SYNOPSIS
    Stages files in the Git repository.

.DESCRIPTION
    Without a file argument it stages every change (git add .), otherwise
    it stages the given file or path.

.PARAMETER file
    File or path to stage. When omitted, all changes are staged.

.EXAMPLE
    gAdd
    gAdd src/main.ps1
#>
function gAdd {
    param([string]$file)

    if (-not (Test-Git)) { return }

    $target = if ($file) { $file } else { "." }

    if (Invoke-Git -Arguments @("add", $target)) {
        Show-GitSuccess "Successfully added: $target"
    } else {
        Show-GitError "Failed to add files: $target"
    }
}

<#
.SYNOPSIS
    Removes a file from the Git repository.

.DESCRIPTION
    Uses `git rm` so the deletion is also staged.

.PARAMETER file
    File to remove from the repository.

.EXAMPLE
    gRemove obsolete.txt
#>
function gRemove {
    param([string]$file)

    if (-not (Test-Git)) { return }

    if (-not $file) {
        Show-GitError "Usage: gRemove <file>"
        return
    }

    if (Invoke-Git -Arguments @("rm", $file)) {
        Show-GitSuccess "File removed: $file"
    } else {
        Show-GitError "Failed to remove file: $file"
    }
}

<#
.SYNOPSIS
    Moves or renames a file inside a Git repository.

.DESCRIPTION
    Uses `git mv` so Git keeps tracking the change correctly.

.PARAMETER old
    Current path of the file.

.PARAMETER new
    Destination path or new name.

.EXAMPLE
    gMove README.txt README.md
#>
function gMove {
    param([string]$old, [string]$new)

    if (-not (Test-Git)) { return }

    if (-not $old -or -not $new) {
        Show-GitError "Usage: gMove <old> <new>"
        return
    }

    if (Invoke-Git -Arguments @("mv", $old, $new)) {
        Show-GitSuccess "File moved: $old -> $new"
    } else {
        Show-GitError "Failed to move file: $old -> $new"
    }
}

<#
.SYNOPSIS
    Creates Git commits with different options.

.DESCRIPTION
      * gCommit <message>          -> normal commit
      * gCommit -a <message>       -> commit with all tracked changes
      * gCommit -u <message>       -> shortcut for --amend
      * gCommit --amend <message>  -> amend the last commit

.PARAMETER type
    Commit mode: -a (all tracked), -u (amend shortcut) or --amend.

.PARAMETER message
    The commit message (mandatory).

.EXAMPLE
    gCommit "Fix typo in login"
    gCommit -a "Stage everything and commit"
    gCommit --amend "Reword last commit"
#>
function gCommit {
    param(
        [ValidateSet("-a", "-u", "--amend")]
        [string]$type,

        [Parameter(Mandatory = $true, Position = 0)]
        [string]$message
    )

    if (-not (Test-Git)) { return }

    switch ($type) {
        "-a"      { $gitArgs = @("commit", "-a", "-m", $message) }
        "-u"      { $gitArgs = @("commit", "--amend", "-m", $message) }
        "--amend" { $gitArgs = @("commit", "--amend", "-m", $message) }
        default   { $gitArgs = @("commit", "-m", $message) }
    }

    if (Invoke-Git -Arguments $gitArgs) {
        Show-GitSuccess "Commit created: $message"
    } else {
        Show-GitError "Failed to create commit"
    }
}
