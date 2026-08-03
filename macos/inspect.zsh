# =============================================================================
#  Inspect - Diff, blame, grep, shortlog and describe.
#  Written for Zsh (default shell on macOS).
# =============================================================================

# -----------------------------------------------------------------------------
#  gDiff [-cached] [-stat] [file]
#    Shows Git diffs:
#      * no argument        -> diff of the working tree
#      * -cached            -> diff of the staged changes
#      * -stat              -> summary of changed files only
#      * <file>             -> diff limited to one file (combine with -cached)
# -----------------------------------------------------------------------------
gDiff() {
    test_git || return 1

    local git_args=(diff)
    local file=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -cached) git_args+=(--cached); shift ;;
            -stat)   git_args+=(--stat); shift ;;
            *)       file="$1"; shift ;;
        esac
    done

    if [[ -n "$file" ]]; then
        git_args+=("$file")
    fi

    invoke_git "${git_args[@]}"
}

# -----------------------------------------------------------------------------
#  gBlame <file> [-line n]
#    Shows who last modified each line of a file (git blame). With -line,
#    only the annotations for the given line are shown.
# -----------------------------------------------------------------------------
gBlame() {
    test_git || return 1

    local file=""
    local line=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -line) line="$2"; shift 2 ;;
            *)     file="$1"; shift ;;
        esac
    done

    if [[ -z "$file" ]]; then
        show_git_error "Usage: gBlame <file> [-line n]"
        return 1
    fi

    local git_args=(blame)
    if (( line > 0 )); then
        git_args+=(-L "$line,$line")
    fi
    git_args+=("$file")

    invoke_git "${git_args[@]}"
}

# -----------------------------------------------------------------------------
#  gGrep <pattern> [-i]
#    Searches the tracked files of the repository (git grep). With -i,
#    the search ignores case.
# -----------------------------------------------------------------------------
gGrep() {
    test_git || return 1

    local pattern=""
    local i=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i) i=1; shift ;;
            *)  pattern="$1"; shift ;;
        esac
    done

    if [[ -z "$pattern" ]]; then
        show_git_error "Usage: gGrep <pattern> [-i]"
        return 1
    fi

    local git_args=(grep)
    if (( i )); then
        git_args+=(-i)
    fi
    git_args+=("$pattern")

    invoke_git "${git_args[@]}"
}

# -----------------------------------------------------------------------------
#  gShortLog [-summary] [-email] [-all]
#    Summarizes the commits grouped by author (git shortlog):
#      * -summary  -> only the commit count per author
#      * -email    -> also show each author's email
#      * -all      -> include branches that are not checked out
# -----------------------------------------------------------------------------
gShortLog() {
    test_git || return 1

    local summary=0
    local email=0
    local all=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -summary) summary=1; shift ;;
            -email)   email=1; shift ;;
            -all)     all=1; shift ;;
            *)        shift ;;
        esac
    done

    # A revision range is required: `git shortlog` without one reads stdin.
    local revision="HEAD"
    if (( all )); then
        revision="--all"
    fi

    local git_args=(shortlog "$revision")
    if (( summary )); then git_args+=(-s); fi
    if (( email )); then git_args+=(-e); fi

    invoke_git "${git_args[@]}"
}

# -----------------------------------------------------------------------------
#  gDescribe [ref]
#    Shows the closest reachable tag relative to a commit (git describe).
#    Default ref: HEAD.
# -----------------------------------------------------------------------------
gDescribe() {
    test_git || return 1
    invoke_git describe "${1:-HEAD}"
}
