# =============================================================================
#  Inspect - Diff, blame, grep, shortlog and describe.
# =============================================================================

<#
.SYNOPSIS
    Shows Git diffs.

.DESCRIPTION
      * no argument        -> diff of the working tree
      * -cached            -> diff of the staged changes
      * -stat              -> summary of changed files only
      * <file>             -> diff limited to one file (combine with -cached)

.PARAMETER file
    Optional file or path to restrict the diff to.

.PARAMETER cached
    Show the diff of the staged (index) changes.

.PARAMETER stat
    Show only a summary of changed files and line counts.

.EXAMPLE
    gDiff
    gDiff -cached
    gDiff -stat
    gDiff src/main.ps1 -cached
#>
function gDiff {
    param(
        [string]$file,
        [switch]$cached,
        [switch]$stat
    )

    if (-not (Test-Git)) { return }

    $gitArgs = @("diff")
    if ($cached) { $gitArgs += "--cached" }
    if ($stat)   { $gitArgs += "--stat" }
    if ($file)   { $gitArgs += $file }

    Invoke-Git -Arguments $gitArgs
}

<#
.SYNOPSIS
    Shows who last modified each line of a file (git blame).

.DESCRIPTION
    With -line, only the annotations for the given line are shown.

.PARAMETER file
    File to annotate.

.PARAMETER line
    Optional line number to restrict the blame output to.

.EXAMPLE
    gBlame src/main.ps1
    gBlame src/main.ps1 -line 42
#>
function gBlame {
    param(
        [Parameter(Mandatory = $true)]
        [string]$file,

        [int]$line
    )

    if (-not (Test-Git)) { return }

    $gitArgs = @("blame")
    if ($line -gt 0) { $gitArgs += @("-L", "$line,$line") }
    $gitArgs += $file

    Invoke-Git -Arguments $gitArgs
}

<#
.SYNOPSIS
    Searches the tracked files of the repository (git grep).

.PARAMETER pattern
    Text or regular expression to look for.

.PARAMETER i
    Ignore case.

.EXAMPLE
    gGrep "TODO"
    gGrep "password" -i
#>
function gGrep {
    param(
        [Parameter(Mandatory = $true)]
        [string]$pattern,

        [switch]$i
    )

    if (-not (Test-Git)) { return }

    $gitArgs = @("grep")
    if ($i) { $gitArgs += "-i" }
    $gitArgs += $pattern

    Invoke-Git -Arguments $gitArgs
}

<#
.SYNOPSIS
    Summarizes the commits grouped by author (git shortlog).

.DESCRIPTION
      * -summary  -> only the commit count per author
      * -email    -> also show each author's email
      * -all      -> include branches that are not checked out

.PARAMETER summary
    Show only the number of commits per author.

.PARAMETER email
    Display author email addresses.

.PARAMETER all
    Include all branches and remote-tracking branches.

.EXAMPLE
    gShortLog
    gShortLog -summary
    gShortLog -summary -email -all
#>
function gShortLog {
    param(
        [switch]$summary,
        [switch]$email,
        [switch]$all
    )

    if (-not (Test-Git)) { return }

    # A revision range is required: `git shortlog` without one reads stdin.
    $revision = if ($all) { "--all" } else { "HEAD" }
    $gitArgs  = @("shortlog", $revision)
    if ($summary) { $gitArgs += "-s" }
    if ($email)   { $gitArgs += "-e" }

    Invoke-Git -Arguments $gitArgs
}

<#
.SYNOPSIS
    Shows the closest reachable tag relative to a commit (git describe).

.PARAMETER ref
    Commit reference to describe (default: HEAD).

.EXAMPLE
    gDescribe
    gDescribe 4c2f1a9
#>
function gDescribe {
    param([string]$ref = "HEAD")

    if (-not (Test-Git)) { return }
    Invoke-Git -Arguments @("describe", $ref)
}
