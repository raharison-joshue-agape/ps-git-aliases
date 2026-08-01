# Git Command Aliases - Windows

Kit de raccourcis Git (`g*`) pour PowerShell sous Windows.

## Prérequis

- Windows 10 ou 11
- PowerShell 5.1 ou plus (Windows PowerShell ou PowerShell 7)
- [Git for Windows](https://git-scm.com/download/win) installé et ajouté au PATH

## Installation

### 1. Copier les fichiers

Placez le dossier `windows` dans votre répertoire de configuration :

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\alias" -Force
Copy-Item -Path "windows" -Destination "$HOME\.config\alias\git-commandes\" -Recurse
```

### 2. Vérifier le profil PowerShell

```powershell
Test-Path $PROFILE
```

- `True` → le profil existe, passez à l'étape 4.
- `False` → créez-le :

```powershell
New-Item -Path $PROFILE -ItemType File -Force
```

### 3. Ouvrir le profil

```powershell
notepad $PROFILE
```

ou avec VS Code :

```powershell
code $PROFILE
```

### 4. Importer les aliases

Ajoutez cette ligne à votre profil :

```powershell
. "$HOME\.config\alias\git-commandes\windows\index.ps1"
```

`index.ps1` charge automatiquement tous les modules. Chaque module regroupe les fonctions par thème :

| Fichier | Fonctions |
| --- | --- |
| `helpers.ps1` | `Test-Git`, `Show-GitError`, `Show-GitSuccess`, `Invoke-Git` |
| `docs.ps1` | `gDocs` |
| `config.ps1` | `gHelp`, `gConfig` |
| `repository.ps1` | `gInit`, `gClone`, `gStatus`, `gClean`, `gArchive` |
| `staging.ps1` | `gAdd`, `gRemove`, `gMove`, `gCommit`, `gUntrack` |
| `branch.ps1` | `gBranch`, `gCheck`, `gSwitch`, `gMerge`, `gRebase`, `gWorktree`, `gMergeAbort`, `gMergeContinue`, `gRebaseAbort`, `gRebaseContinue` |
| `remote.ps1` | `gRemote`, `gPush`, `gPull`, `gFetch` |
| `history.ps1` | `gLog`, `gShow`, `gRestore`, `gReset`, `gRevert`, `gCherryPick`, `gReflog`, `gStash` |
| `inspect.ps1` | `gDiff`, `gBlame`, `gGrep`, `gShortLog`, `gDescribe` |
| `tags.ps1` | `gTag`, `gPushTag` |
| `submodule.ps1` | `gSubmodule` |
| `bisect.ps1` | `gBisect` |

### 5. Recharger le profil

```powershell
. $PROFILE
```

## Utilisation

Les raccourcis s'utilisent directement dans le terminal :

```powershell
gStatus        # état du dépôt
gAdd -a        # stage tous les fichiers
gCommit "msg"  # création d'un commit
gPush          # push de la branche courante
gDiff -cached  # diff des changements stagés
```

## Aide intégrée

```powershell
gDocs                 # cheat sheet dans le terminal
Get-Help gCommit      # documentation d'une fonction
```

Chaque fonction dispose d'une aide commentée (`Get-Help`) décrivant ses paramètres et des exemples.

## Désinstallation

- Retirez la ligne d'import de votre profil : `$PROFILE`
- Supprimez le répertoire :

```powershell
Remove-Item -Path "$HOME\.config\alias\git-commandes" -Recurse -Force
```

## Dépannage

- Les aliases ne fonctionnent pas → vérifiez le chemin dans la ligne d'import et recharger le profil.
- `❌ Git is not installed` → installez Git for Windows et redémarrez PowerShell.
- Profil introuvable → vérifiez que `$PROFILE` existe (`Test-Path $PROFILE`).
