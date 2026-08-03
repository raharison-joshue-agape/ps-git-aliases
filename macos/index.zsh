# =============================================================================
#  Git Command Aliases (macOS) - Entry point
# =============================================================================
#  Sources every grouped module so all `g*` functions become available
#  once this file is loaded from your shell configuration.
#
#  Written for Zsh (the default shell on macOS since Catalina).
#
#  Usage in ~/.zshrc:
#      . ~/.config/alias/git-commandes/macos/index.zsh
#
#  File layout:
#      helpers.zsh    test_git / show_git_error / show_git_success / invoke_git
#      docs.zsh       gDocs
#      config.zsh     gHelp, gConfig
#      repository.zsh gInit, gClone, gStatus, gClean, gArchive
#      staging.zsh    gAdd, gRemove, gMove, gCommit, gUntrack
#      branch.zsh     gBranch, gCheck, gSwitch, gMerge, gRebase, gWorktree,
#                     gMergeAbort, gMergeContinue, gRebaseAbort, gRebaseContinue
#      remote.zsh     gRemote, gPush, gPull, gFetch
#      history.zsh    gLog, gShow, gRestore, gReset, gRevert,
#                     gCherryPick, gReflog, gStash
#      inspect.zsh    gDiff, gBlame, gGrep, gShortLog, gDescribe
#      tags.zsh       gTag, gPushTag
#      submodule.zsh  gSubmodule
#      bisect.zsh     gBisect
# =============================================================================

# The directory containing this index.zsh, so the modules are found
# regardless of where the project was copied. `:A` resolves the path
# to an absolute one and `:h` strips the last path component.
GIT_COMMANDES_DIR="${0:A:h}"

g_commandes_modules=(
    helpers.zsh
    docs.zsh
    config.zsh
    repository.zsh
    staging.zsh
    branch.zsh
    remote.zsh
    history.zsh
    inspect.zsh
    tags.zsh
    submodule.zsh
    bisect.zsh
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
