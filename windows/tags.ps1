# =============================================================================
#  Tags - Tag management and tag pushing.
# =============================================================================

<#
.SYNOPSIS
    Manages Git tags.

.DESCRIPTION
      * no argument            -> list all tags
      * create <name>          -> create a lightweight tag
      * annotate <name> <msg>  -> create an annotated tag
      * delete <name>          -> delete a local tag
      * show <name>            -> show tag details

.PARAMETER type
    Tag operation: list, create, annotate, delete or show.

.PARAMETER name
    Name of the tag to create, delete or show.

.PARAMETER message
    Message used when creating an annotated tag.

.EXAMPLE
    gTag
    gTag create v1.0.0
    gTag annotate v1.0.0 "Release 1.0.0"
    gTag delete v1.0.0
    gTag show v1.0.0
#>
function gTag {
    param(
        [ValidateSet("list", "create", "annotate", "delete", "show")]
        [string]$type,

        [string]$name,
        [string]$message
    )

    if (-not (Test-Git)) { return }

    switch ($type) {
        "list" {
            Invoke-Git -Arguments @("tag")
            return
        }

        "create" {
            if (-not $name) {
                Show-GitError "Usage: gTag create <tag_name>"
                return
            }
            $gitArgs        = @("tag", $name)
            $successMessage = "Tag created: $name"
        }

        "annotate" {
            if (-not $name -or -not $message) {
                Show-GitError "Usage: gTag annotate <tag_name> <message>"
                return
            }
            $gitArgs        = @("tag", "-a", $name, "-m", $message)
            $successMessage = "Annotated tag created: $name"
        }

        "delete" {
            if (-not $name) {
                Show-GitError "Usage: gTag delete <tag_name>"
                return
            }
            $gitArgs        = @("tag", "-d", $name)
            $successMessage = "Tag deleted: $name"
        }

        "show" {
            if (-not $name) {
                Show-GitError "Usage: gTag show <tag_name>"
                return
            }
            Invoke-Git -Arguments @("show", $name)
            return
        }

        default {
            Invoke-Git -Arguments @("tag")
            return
        }
    }

    Invoke-Git -Arguments $gitArgs
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess $successMessage
    } else {
        Show-GitError "Tag operation failed: $type"
    }
}

<#
.SYNOPSIS
    Pushes Git tags to a remote repository.

.DESCRIPTION
      * no tag  -> push every local tag
      * <tag>   -> push a single tag

.PARAMETER remote_name
    Name of the remote (default: origin).

.PARAMETER tag_name
    Tag to push. When omitted, all tags are pushed.

.EXAMPLE
    gPushTag
    gPushTag v1.0.0
#>
function gPushTag {
    param(
        [string]$remote_name = "origin",
        [string]$tag_name
    )

    if (-not (Test-Git)) { return }

    if (-not $tag_name) {
        $gitArgs        = @("push", $remote_name, "--tags")
        $successMessage = "All tags pushed to $remote_name"
    } else {
        $gitArgs        = @("push", $remote_name, $tag_name)
        $successMessage = "Tag pushed: $tag_name -> $remote_name"
    }

    Invoke-Git -Arguments $gitArgs
    if ($LASTEXITCODE -eq 0) {
        Show-GitSuccess $successMessage
    } else {
        Show-GitError "Failed to push tag"
    }
}
