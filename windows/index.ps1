# =============================================================================
#  Git Command Aliases - Entry point
# =============================================================================
#  Dot-sources every grouped module so all `g*` functions become available
#  once this file is loaded from your PowerShell profile.
#
#  Usage in $PROFILE:
#      . "$HOME\.config\alias\git-commandes\windows\index.ps1"
#
#  File layout:
#      helpers.ps1    Test-Git / Show-GitError / Show-GitSuccess / Invoke-Git
#      docs.ps1       gDocs
#      config.ps1     gHelp, gConfig
#      repository.ps1 gInit, gClone, gStatus, gClean, gArchive
#      staging.ps1    gAdd, gRemove, gMove, gCommit, gUntrack
#      branch.ps1     gBranch, gCheck, gSwitch, gMerge, gRebase, gWorktree,
#                     gMergeAbort, gMergeContinue, gRebaseAbort, gRebaseContinue
#      remote.ps1     gRemote, gPush, gPull, gFetch
#      history.ps1    gLog, gShow, gRestore, gReset, gRevert,
#                     gCherryPick, gReflog, gStash
#      inspect.ps1    gDiff, gBlame, gGrep, gShortLog, gDescribe
#      tags.ps1       gTag, gPushTag
#      submodule.ps1  gSubmodule
#      bisect.ps1     gBisect
# =============================================================================

# $PSScriptRoot = the directory containing this index.ps1, so the modules
# are found regardless of where the project was copied.
$moduleDir = $PSScriptRoot

$modules = @(
    "helpers.ps1"
    "docs.ps1"
    "config.ps1"
    "repository.ps1"
    "staging.ps1"
    "branch.ps1"
    "remote.ps1"
    "history.ps1"
    "inspect.ps1"
    "tags.ps1"
    "submodule.ps1"
    "bisect.ps1"
)

foreach ($module in $modules) {
    $path = Join-Path $moduleDir $module
    if (Test-Path -LiteralPath $path) {
        . $path
    } else {
        Write-Host "Module not found: $module" -ForegroundColor Yellow
    }
}
