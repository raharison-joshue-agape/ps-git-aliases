# =============================================================================
#  Docs - In-terminal cheat sheet listing every Git alias command.
# =============================================================================

<#
.SYNOPSIS
    Displays a formatted cheat sheet of all available Git alias commands.

.DESCRIPTION
    Groups the commands by theme (config, repository, staging, branches,
    remotes, history, tags, advanced) so you can quickly find the alias
    you are looking for.

.EXAMPLE
    gDocs
#>
function gDocs {
    $colCommandWidth = 45
    $colDescWidth    = 75

    $sections = [ordered]@{
        "Config & Help" = @(
            @{ Command = "gHelp [cmd]"; Description = "Show Git help or help for a specific command" }
            @{ Command = "gConfig [field] [value] [-g|-l|-s]"; Description = "Get or set Git configuration (global by default)" }
        )
        "Repository" = @(
            @{ Command = "gInit [-c] [message]"; Description = "Initialize a repository with optional initial commit" }
            @{ Command = "gClone <url> [folder]"; Description = "Clone a repository from a URL" }
            @{ Command = "gClone <branch> <url> [folder]"; Description = "Clone a specific branch into a folder" }
            @{ Command = "gStatus"; Description = "Show the current repository status" }
            @{ Command = "gClean [-force] [-dry]"; Description = "Remove untracked files (preview by default, -force deletes)" }
        )
        "Working Tree & Commits" = @(
            @{ Command = "gAdd [file]"; Description = "Stage a file or all files" }
            @{ Command = "gRemove <file>"; Description = "Remove a tracked file from the repository" }
            @{ Command = "gMove <old> <new>"; Description = "Rename or move a tracked file" }
            @{ Command = "gCommit [-a|-u|--amend] <message>"; Description = "Create or modify a commit" }
        )
        "Branches" = @(
            @{ Command = "gBranch"; Description = "List all branches" }
            @{ Command = "gBranch <name>"; Description = "Create a new branch" }
            @{ Command = "gBranch -d|-D <name>"; Description = "Delete a local branch" }
            @{ Command = "gCheck <branch>"; Description = "Switch to a branch using checkout" }
            @{ Command = "gCheck -b <branch>"; Description = "Create and switch to a new branch" }
            @{ Command = "gSwitch <branch>"; Description = "Switch branches using git switch" }
            @{ Command = "gMerge <branch>"; Description = "Merge a branch into the current branch" }
            @{ Command = "gRebase <branch>"; Description = "Reapply commits onto a new base branch" }
        )
        "Remotes" = @(
            @{ Command = "gRemote"; Description = "List configured remotes" }
            @{ Command = "gRemote <name> <url>"; Description = "Add a new remote repository" }
            @{ Command = "gPush [remote] [branch]"; Description = "Push commits to a remote repository" }
            @{ Command = "gPull [remote] [branch]"; Description = "Pull and merge changes from a remote" }
            @{ Command = "gFetch [remote]"; Description = "Fetch updates without merging" }
        )
        "History & Recovery" = @(
            @{ Command = "gLog"; Description = "Show full commit history" }
            @{ Command = "gLog oneline|graph|stat|patch|pretty|all"; Description = "Show commit history in different formats" }
            @{ Command = "gShow <commit>"; Description = "Show details of a commit" }
            @{ Command = "gRestore [-staged] <file>"; Description = "Restore a file from working tree or staging area" }
            @{ Command = "gReset <file>"; Description = "Unstage a file" }
            @{ Command = "gReset <commit> <file>"; Description = "Reset a file to a specific commit" }
            @{ Command = "gReset -h <commit|HEAD>"; Description = "Perform a hard reset (destructive)" }
            @{ Command = "gReset -s <commit>"; Description = "Perform a soft reset (keep changes)" }
            @{ Command = "gRevert <commit>"; Description = "Revert a commit by creating a new one" }
            @{ Command = "gCherryPick <commit>"; Description = "Apply a specific commit onto current branch" }
            @{ Command = "gReflog"; Description = "Show HEAD history (reflog)" }
            @{ Command = "gStash"; Description = "Temporarily save working directory changes" }
            @{ Command = "gStash list|pop|apply|drop|clear [index]"; Description = "Manage stash entries" }
        )
        "Tags" = @(
            @{ Command = "gTag"; Description = "List all tags" }
            @{ Command = "gTag create <name>"; Description = "Create a lightweight tag" }
            @{ Command = "gTag annotate <name> <msg>"; Description = "Create an annotated tag with message" }
            @{ Command = "gTag delete <name>"; Description = "Delete a local tag" }
            @{ Command = "gTag show <name>"; Description = "Show tag details" }
            @{ Command = "gPushTag [remote] [tag]"; Description = "Push a tag or all tags to a remote" }
        )
        "Advanced" = @(
            @{ Command = "gBisect start|good|bad|reset [commit]"; Description = "Find bugs using binary search in commit history" }
        )
    }

    $separator = "=" * ($colCommandWidth + $colDescWidth)
    $line      = "-" * ($colCommandWidth + $colDescWidth)

    Write-Host ""
    Write-Host "  Git Command Aliases - Cheat Sheet" -ForegroundColor Cyan
    Write-Host $separator
    Write-Host ""

    foreach ($section in $sections.Keys) {
        Write-Host "  $section" -ForegroundColor Yellow
        Write-Host $line

        $headerCommand = "COMMAND".PadRight($colCommandWidth)
        $headerDesc    = "DESCRIPTION".PadRight($colDescWidth)
        Write-Host "$headerCommand$headerDesc"
        Write-Host $line

        foreach ($cmd in $sections[$section]) {
            $cmdName = $cmd.Command.PadRight($colCommandWidth)
            $cmdDesc = $cmd.Description.PadRight($colDescWidth)
            Write-Host "$cmdName$cmdDesc"
        }
        Write-Host ""
    }
}
