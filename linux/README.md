# Git Command Aliases - Linux

Kit de raccourcis Git (`g*`) pour bash sous Linux.

## Prérequis

- Linux avec bash 4.0 ou plus
- [Git](https://git-scm.com/download/linux) installé (`sudo apt install git` sur Debian/Ubuntu, `sudo pacman -S git` sur Arch, etc.)

## Installation

### 1. Copier les fichiers

Placez le dossier `linux` dans votre répertoire de configuration :

```bash
mkdir -p ~/.config/alias
cp -r linux ~/.config/alias/git-commandes/
```

### 2. Ouvrir votre fichier de configuration shell

```bash
nano ~/.bashrc
```

ou, si vous utilisez zsh :

```bash
nano ~/.zshrc
```

### 3. Importer les aliases

Ajoutez cette ligne à la fin du fichier :

```bash
. ~/.config/alias/git-commandes/linux/index.sh
```

`index.sh` charge automatiquement tous les modules. Chaque module regroupe les fonctions par thème :

| Fichier | Fonctions |
| --- | --- |
| `helpers.sh` | `test_git`, `show_git_error`, `show_git_success`, `invoke_git` |
| `docs.sh` | `gDocs` |
| `config.sh` | `gHelp`, `gConfig` |
| `repository.sh` | `gInit`, `gClone`, `gStatus`, `gClean`, `gArchive` |
| `staging.sh` | `gAdd`, `gRemove`, `gMove`, `gCommit`, `gUntrack` |
| `branch.sh` | `gBranch`, `gCheck`, `gSwitch`, `gMerge`, `gRebase`, `gWorktree`, `gMergeAbort`, `gMergeContinue`, `gRebaseAbort`, `gRebaseContinue` |
| `remote.sh` | `gRemote`, `gPush`, `gPull`, `gFetch` |
| `history.sh` | `gLog`, `gShow`, `gRestore`, `gReset`, `gRevert`, `gCherryPick`, `gReflog`, `gStash` |
| `inspect.sh` | `gDiff`, `gBlame`, `gGrep`, `gShortLog`, `gDescribe` |
| `tags.sh` | `gTag`, `gPushTag` |
| `submodule.sh` | `gSubmodule` |
| `bisect.sh` | `gBisect` |

### 4. Recharger la configuration

```bash
source ~/.bashrc
```

## Utilisation

Les raccourcis s'utilisent directement dans le terminal :

```bash
gStatus          # état du dépôt
gAdd             # stage tous les fichiers
gCommit "msg"    # création d'un commit
gPush            # push de la branche courante
gDiff -cached    # diff des changements stagés
```

## Aide intégrée

```bash
gDocs            # cheat sheet dans le terminal
gHelp commit     # aide Git pour une commande
```

## Désinstallation

- Retirez la ligne d'import de votre `~/.bashrc` (ou `~/.zshrc`)
- Supprimez le répertoire :

```bash
rm -rf ~/.config/alias/git-commandes
```

## Dépannage

- Les aliases ne fonctionnent pas → vérifiez le chemin dans la ligne d'import et rechargez votre configuration (`source ~/.bashrc`).
- `❌ Git is not installed` → installez Git (`sudo apt install git` par exemple).
- `command not found: gStatus` → les fonctions ne sont pas chargées, vérifiez que la ligne `. ~/.config/alias/git-commandes/linux/index.sh` est bien dans votre `~/.bashrc`.
