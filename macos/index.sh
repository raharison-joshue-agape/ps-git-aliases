# =============================================================================
#  Git Command Aliases (macOS) - Entry point
# =============================================================================
#  Sources every grouped module so all `g*` functions become available
#  once this file is loaded from your shell configuration.
#
#  Written for Zsh (the default shell on macOS since Catalina) and
#  fully compatible with Bash 4.0+.
#
#  Usage in ~/.zshrc (or ~/.bash_profile):
#      . ~/.config/alias/git-commandes/macos/index.sh
#
#  File layout:
#      helpers.sh    test_git / show_git_error / show_git_success / invoke_git
#      docs.sh       gDocs
#      config.sh     gHelp, gConfig
#      repository.sh gInit, gClone, gStatus, gClean, gArchive
#      staging.sh    gAdd, gRemove, gMove, gCommit, gUntrack
#      branch.sh     gBranch, gCheck, gSwitch, gMerge, gRebase, gWorktree,
#                    gMergeAbort, gMergeContinue, gRebaseAbort, gRebaseContinue
#      remote.sh     gRemote, gPush, gPull, gFetch
#      history.sh    gLog, gShow, gRestore, gReset, gRevert,
#                    gCherryPick, gReflog, gStash
#      inspect.sh    gDiff, gBlame, gGrep, gShortLog, gDescribe
#      tags.sh       gTag, gPushTag
#      submodule.sh  gSubmodule
#      bisect.sh     gBisect
# =============================================================================

# The directory containing this index.sh, so the modules are found
# regardless of where the project was copied.
GIT_COMMANDES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

g_commandes_modules=(
    helpers.sh
    docs.sh
    config.sh
    repository.sh
    staging.sh
    branch.sh
    remote.sh
    history.sh
    inspect.sh
    tags.sh
    submodule.sh
    bisect.sh
)

for g_commandes_module in "${g_commandes_modules[@]}"; do
    if [[ -f "$GIT_COMMANDES_DIR/$g_commandes_module" ]]; then
        # shellcheck source=/dev/null
        . "$GIT_COMMANDES_DIR/$g_commandes_module"
    else
        printf "\033[33mModule not found: %s\033[0m\n" "$g_commandes_module"
    fi
done

unset g_commandes_module g_commandes_modules
