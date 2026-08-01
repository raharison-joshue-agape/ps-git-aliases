# =============================================================================
#  Helpers - Shared utilities used by every Git alias function.
# =============================================================================

<#
.SYNOPSIS
    Checks that the git executable is available.

.DESCRIPTION
    Returns $true when git is installed and reachable from PATH.
    Otherwise prints an error message and returns $false so the caller
    can abort early instead of running a broken command.

.EXAMPLE
    if (-not (Test-Git)) { return }
#>
function Test-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Show-GitError "Git is not installed or not available in PATH"
        return $false
    }
    return $true
}

<#
.SYNOPSIS
    Prints a red error message prefixed with ❌.

.PARAMETER Message
    The error text to display.

.EXAMPLE
    Show-GitError "Failed to clone repository"
#>
function Show-GitError {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )
    Write-Host "❌ $Message" -ForegroundColor Red
}

<#
.SYNOPSIS
    Prints a green success message prefixed with ✅.

.PARAMETER Message
    The success text to display.

.EXAMPLE
    Show-GitSuccess "Repository initialized successfully"
#>
function Show-GitSuccess {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )
    Write-Host "✅ $Message" -ForegroundColor Green
}

<#
.SYNOPSIS
    Runs a git command with the given arguments.

.DESCRIPTION
    Thin wrapper around the git executable. Git output flows normally to
    the pipeline, so it can still be piped. Check $LASTEXITCODE right after
    the call to know whether the command succeeded (native executables
    never throw in PowerShell, so try/catch alone is unreliable).

.PARAMETER Arguments
    Arguments passed to git, e.g. @("status") or @("add", ".").

.EXAMPLE
    Invoke-Git -Arguments @("status")
    if ($LASTEXITCODE -eq 0) { Show-GitSuccess "OK" }
#>
function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )
    & git @Arguments
}
