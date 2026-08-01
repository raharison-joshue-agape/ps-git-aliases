# =============================================================================
#  Bisect - Bug hunting with a binary search over the commit history.
# =============================================================================

<#
.SYNOPSIS
    Helps identify bugs using Git bisect.

.DESCRIPTION
      * start          -> begin the bisect process
      * good [commit]  -> mark a commit as good (default: HEAD)
      * bad [commit]   -> mark a commit as bad (default: HEAD)
      * reset          -> stop the bisect process

.PARAMETER action
    Bisect action: start, good, bad or reset.

.PARAMETER commit
    Commit reference to mark as good or bad.

.EXAMPLE
    gBisect start
    gBisect bad
    gBisect good
    gBisect good 4c2f1a9
    gBisect reset
#>
function gBisect {
    param(
        [ValidateSet("start", "good", "bad", "reset")]
        [string]$action = "start",

        [string]$commit
    )

    if (-not (Test-Git)) { return }

    switch ($action) {
        "start" {
            $gitArgs        = @("bisect", "start")
            $successMessage = "Bisect started"
        }

        "good" {
            $gitArgs = @("bisect", "good")
            if ($commit) { $gitArgs += $commit }
            $successMessage = "Marked as good: $commit"
        }

        "bad" {
            $gitArgs = @("bisect", "bad")
            if ($commit) { $gitArgs += $commit }
            $successMessage = "Marked as bad: $commit"
        }

        "reset" {
            $gitArgs        = @("bisect", "reset")
            $successMessage = "Bisect reset"
        }
    }

    if (Invoke-Git -Arguments $gitArgs) {
        Show-GitSuccess $successMessage
    } else {
        Show-GitError "Bisect operation failed: $action"
    }
}
