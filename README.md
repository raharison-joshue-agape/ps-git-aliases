<div align="center">

# 🚀 Git Command Aliases

### Raccourcis Git pour **Bash (Linux)**, **Zsh (macOS)** et **PowerShell (Windows)**

Suite d'aliases `g*` qui simplifient et accélèrent vos workflows Git directement en ligne de commande.

---

[![GitHub stars](https://img.shields.io/github/stars/raharison-joshue-agape/ps-git-aliases?style=for-the-badge&logo=github&logoColor=white&color=gold)](https://github.com/raharison-joshue-agape/ps-git-aliases/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/raharison-joshue-agape/ps-git-aliases?style=for-the-badge&logo=github&logoColor=white&color=blue)](https://github.com/raharison-joshue-agape/ps-git-aliases/forks)
[![GitHub issues](https://img.shields.io/github/issues/raharison-joshue-agape/ps-git-aliases?style=for-the-badge&logo=github&logoColor=white&color=red)](https://github.com/raharison-joshue-agape/ps-git-aliases/issues)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Zsh](https://img.shields.io/badge/Zsh-5.x-F15A24?style=for-the-badge&logo=zsh&logoColor=white)](https://www.zsh.org/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/)
[![Linux](https://img.shields.io/badge/Linux-ready-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![macOS](https://img.shields.io/badge/macOS-ready-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Windows](https://img.shields.io/badge/Windows-ready-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Git](https://img.shields.io/badge/Git-requis-F05032?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)
[![Repo size](https://img.shields.io/github/repo-size/raharison-joshue-agape/ps-git-aliases?style=for-the-badge&logo=github&logoColor=white)]()

</div>

---

## 📑 Table des matières

- [✨ Fonctionnalités](#-fonctionnalités)
- [🛠️ Stack technique](#️-stack-technique)
- [🏗️ Architecture](#️-architecture)
- [⚡ Démarrage rapide](#-démarrage-rapide)
- [🖥️ Linux / Bash](#️-linux--bash)
- [🍎 macOS / Zsh](#-macos--zsh)
- [🪟 Windows / PowerShell](#-windows--powershell)
- [🔧 Référence des commandes](#-référence-des-commandes)
- [📖 Aide intégrée](#-aide-intégrée)
- [🔌 Modules](#-modules)
- [📂 Structure du projet](#-structure-du-projet)
- [🧹 Désinstallation](#-désinstallation)
- [🛟 Dépannage](#-dépannage)
- [📄 Licence](#-licence)

---

## ✨ Fonctionnalités

| | |
|---|---|
| ⚡ **Aliases `g*`** | Des dizaines de raccourcis vers les commandes Git essentielles, identiques sur les trois plateformes |
| 🧩 **Architecture modulaire** | Modules thématiques (dépôt, branches, remotes, historique...) chargés depuis un point d'entrée unique |
| 🐧 **Linux / Bash** | Scripts `.sh` compatibles bash 4.0+ et zsh |
| 🍎 **macOS / Zsh** | Scripts `.sh` natifs zsh (et bash), shell par défaut de macOS depuis Catalina |
| 🪟 **Windows / PowerShell** | Scripts `.ps1` compatibles Windows PowerShell 5.1+ et PowerShell 7 |
| 🛡️ **Vérification de Git** | Disponibilité de git contrôlée avant chaque appel, avec arrêt propre si absent |
| ✅ **Feedback clair** | Messages de succès (`✅`) et d'erreur (`❌`) pour chaque opération |
| 📖 **Cheat sheet intégrée** | `gDocs` affiche la liste complète des commandes groupées par thème |
| 🧠 **Aide contextuelle** | `gHelp [cmd]` sur les trois plateformes, `Get-Help` en plus côté PowerShell |

---

## 🛠️ Stack technique

| Domaine | Technologie |
|---|---|
| **Shell Linux** | [Bash](https://www.gnu.org/software/bash/) 4.0+ (ou [Zsh](https://www.zsh.org/)) |
| **Shell macOS** | [Zsh](https://www.zsh.org/) 5.x (shell par défaut) ou Bash 4.0+ |
| **Shell Windows** | [Windows PowerShell](https://learn.microsoft.com/powershell/) 5.1+ ou [PowerShell 7](https://learn.microsoft.com/powershell/) |
| **VCS** | [Git](https://git-scm.com/) (toute version moderne) |
| **Format** | Scripts shell / PowerShell — **aucune dépendance externe** |
| **Point d'entrée** | `index.sh` / `index.ps1` (chargement automatique des modules) |
| **Couche utilitaire** | `helpers.sh` / `helpers.ps1` (vérification, exécution, messages) |
| **Documentation** | Cheat sheet intégrée (`gDocs`) + aide Git (`gHelp`) |

---

## 🏗️ Architecture

L'implémentation suit une **architecture modulaire en couches**, chaque couche ayant une responsabilité unique :

```
 Terminal / Shell de l'utilisateur
      │      (~/.bashrc | ~/.zshrc | $PROFILE)
      ▼
┌────────────────────────────┐
│    index.sh / index.ps1    │  Point d'entrée — charge tous les modules
└────────────┬───────────────┘
             ▼
┌────────────────────────────┐
│  Modules thématiques       │  repository.sh, staging.sh, branch.sh,
│                            │  remote.sh, history.sh, inspect.sh, ...
└────────────┬───────────────┘
             ▼
┌────────────────────────────┐
│    helpers.sh / helpers.ps1│  test_git, invoke_git / Test-Git, Invoke-Git,
│                            │  messages de succès et d'erreur
└────────────┬───────────────┘
             ▼
             Git
```

- **`index.sh` / `index.ps1`** : source l'ensemble des modules situés dans son propre répertoire, quel que soit l'endroit où le projet a été copié.
- **Modules thématiques** : chacun expose les fonctions publiques `g*` d'un domaine Git.
- **Helpers** : portent la logique transversale (disponibilité de Git, exécution, feedback coloré).
- Les trois implémentations (`linux/`, `macos/` et `windows/`) sont **fonctionnellement équivalentes** : mêmes commandes, mêmes options, mêmes comportements.

---

## ⚡ Démarrage rapide

### Prérequis

- **Git** installé et accessible depuis le terminal — voir [git-scm.com](https://git-scm.com/downloads)
- **Linux** : bash 4.0+ (ou zsh)
- **macOS** : zsh 5.x (shell par défaut) ou bash 4.0+
- **Windows** : Windows 10/11 avec Windows PowerShell 5.1+ ou PowerShell 7

Puis suivez les étapes correspondant à votre plateforme ci-dessous.

---

## 🖥️ Linux / Bash

### 1. Copier les fichiers dans votre répertoire de configuration

```bash
mkdir -p ~/.config/alias
cp -r linux ~/.config/alias/git-commandes/
```

### 2. Ouvrir votre fichier de configuration shell

```bash
nano ~/.bashrc        # Bash
nano ~/.zshrc         # Zsh
```

### 3. Importer les aliases

Ajoutez cette ligne à la fin du fichier :

```bash
. ~/.config/alias/git-commandes/linux/index.sh
```

### 4. Recharger votre configuration

```bash
source ~/.bashrc      # ou : source ~/.zshrc
```

---

## 🍎 macOS / Zsh

### 1. Copier les fichiers dans votre répertoire de configuration

```bash
mkdir -p ~/.config/alias
cp -r macos ~/.config/alias/git-commandes/
```

### 2. Ouvrir votre fichier de configuration shell

```bash
nano ~/.zshrc         # Zsh (shell par défaut)
nano ~/.bash_profile  # Bash
```

### 3. Importer les aliases

Ajoutez cette ligne à la fin du fichier :

```bash
. ~/.config/alias/git-commandes/macos/index.sh
```

### 4. Recharger votre configuration

```bash
source ~/.zshrc       # ou : source ~/.bash_profile
```

> 💡 Si Git est absent : `xcode-select --install` (Xcode Command Line Tools) ou `brew install git`.
> ⚠️ Le Bash fourni par macOS (3.2) est trop ancien — utilisez Zsh ou installez un Bash moderne via Homebrew.

---

## 🪟 Windows / PowerShell

### 1. Copier les fichiers dans votre répertoire de configuration

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\alias" -Force
Copy-Item -Path "windows" -Destination "$HOME\.config\alias\git-commandes\" -Recurse
```

### 2. Vérifier que votre profil PowerShell existe

```powershell
Test-Path $PROFILE
```

- `True` → votre profil existe, passez à l'étape 4.
- `False` → créez-le :

```powershell
New-Item -Path $PROFILE -ItemType File -Force
```

### 3. Ouvrir votre profil

```powershell
notepad $PROFILE      # ou : code $PROFILE
```

### 4. Importer les aliases

Ajoutez cette ligne à votre profil :

```powershell
. "$HOME\.config\alias\git-commandes\windows\index.ps1"
```

### 5. Recharger votre profil

```powershell
. $PROFILE
```

---

## 🔧 Référence des commandes

Les aliases se comportent comme des commandes natives et acceptent les mêmes arguments que les commandes Git sous-jacentes.

### Exemples rapides

```bash
# Linux (Bash) / macOS (Zsh)
gStatus             # état du dépôt
gAdd                # stager tous les changements
gCommit "msg"       # créer un commit
gPush               # pousser la branche courante
gDiff --cached      # revoir les changements stagés
```

```powershell
# Windows (PowerShell)
gStatus             # état du dépôt
gAdd -a             # stager tous les changements
gCommit "msg"       # créer un commit
gPush               # pousser la branche courante
gDiff -cached       # revoir les changements stagés
```

### 🔑 Config & Aide

| Commande | Description |
|---|---|
| `gHelp [cmd]` | Affiche l'aide de Git, ou d'une commande spécifique |
| `gConfig [field] [value] [-g\|-l\|-s]` | Lit ou écrit la configuration Git (global par défaut) |

### 📦 Dépôt — Repository

| Commande | Description |
|---|---|
| `gInit [-c] [message]` | Initialise un dépôt (avec commit initial optionnel) |
| `gClone <url> [folder]` | Clone un dépôt depuis une URL |
| `gClone <branch> <url> [folder]` | Clone une branche spécifique dans un dossier |
| `gStatus` | Affiche l'état du dépôt |
| `gArchive <output> [ref]` | Crée une archive zip/tar d'un commit ou d'une branche |
| `gClean [-force] [-dry]` | Supprime les fichiers non suivis (aperçu par défaut, `-force` supprime) |

### 📝 Staging & Commits

| Commande | Description |
|---|---|
| `gAdd [file]` | Stage un fichier ou tous les fichiers |
| `gRemove <file>` | Supprime un fichier suivi du dépôt |
| `gMove <old> <new>` | Renomme ou déplace un fichier suivi |
| `gUntrack <file>` | Arrête de suivre un fichier sans le supprimer |
| `gCommit [-a\|-u\|--amend] <message>` | Crée ou modifie un commit |

### 🌿 Branches

| Commande | Description |
|---|---|
| `gBranch` | Liste toutes les branches |
| `gBranch <name>` | Crée une nouvelle branche |
| `gBranch -d\|-D <name>` | Supprime une branche locale |
| `gCheck <branch>` | Bascule sur une branche (checkout) |
| `gCheck -b <branch>` | Crée et bascule sur une nouvelle branche |
| `gSwitch <branch>` | Bascule de branche (`git switch`) |
| `gMerge <branch>` | Fusionne une branche dans la branche courante |
| `gMergeAbort` | Annule une fusion en cours |
| `gMergeContinue` | Reprend une fusion après résolution des conflits |
| `gRebase <branch>` | Rejoue des commits sur une nouvelle base |
| `gRebaseAbort` | Annule un rebase en cours |
| `gRebaseContinue` | Reprend un rebase après résolution des conflits |
| `gWorktree [add\|list\|remove]` | Gère plusieurs répertoires de travail |

### 🌐 Remotes

| Commande | Description |
|---|---|
| `gRemote` | Liste les remotes configurés |
| `gRemote <name> <url>` | Ajoute un nouveau remote |
| `gPush [remote] [branch]` | Pousse les commits vers un remote |
| `gPull [remote] [branch]` | Tire et fusionne les changements d'un remote |
| `gFetch [remote]` | Récupère les mises à jour sans fusionner |

### 🕘 Historique & Récupération

| Commande | Description |
|---|---|
| `gLog` | Affiche l'historique complet |
| `gLog oneline\|graph\|stat\|patch\|pretty\|all` | Historique dans différents formats |
| `gShow <commit>` | Affiche les détails d'un commit |
| `gRestore [-staged] <file>` | Restaure un fichier depuis le working tree ou la zone de staging |
| `gReset <file>` | Désstage un fichier |
| `gReset <commit> <file>` | Réinitialise un fichier à un commit précis |
| `gReset -h <commit\|HEAD>` | Hard reset *(destructif)* |
| `gReset -s <commit>` | Soft reset (garde les changements) |
| `gRevert <commit>` | Annule un commit en créant un nouveau |
| `gCherryPick <commit>` | Applique un commit précis sur la branche courante |
| `gReflog` | Affiche l'historique de HEAD (reflog) |
| `gStash` | Sauvegarde temporairement les changements |
| `gStash list\|pop\|apply\|drop\|clear [index]` | Gère les entrées du stash |

### 🔍 Inspecter

| Commande | Description |
|---|---|
| `gDiff [-cached] [-stat] [file]` | Affiche les changements du working tree ou stagés |
| `gBlame <file> [-line n]` | Affiche l'auteur de chaque ligne d'un fichier |
| `gGrep <pattern> [-i]` | Recherche dans les fichiers suivis |
| `gShortLog [-summary] [-email] [-all]` | Résume les commits groupés par auteur |
| `gDescribe [ref]` | Affiche le tag le plus proche atteignable |

### 🏷️ Tags

| Commande | Description |
|---|---|
| `gTag` | Liste tous les tags |
| `gTag create <name>` | Crée un tag léger |
| `gTag annotate <name> <msg>` | Crée un tag annoté avec message |
| `gTag delete <name>` | Supprime un tag local |
| `gTag show <name>` | Affiche les détails d'un tag |
| `gPushTag [remote] [tag]` | Pousse un tag, ou tous les tags, vers un remote |

### 📦 Sous-modules

| Commande | Description |
|---|---|
| `gSubmodule add <url> [path]` | Enregistre un nouveau sous-module |
| `gSubmodule init\|update\|sync\|status` | Gère les sous-modules enregistrés |

### 🧪 Avancé

| Commande | Description |
|---|---|
| `gBisect start\|good\|bad\|reset [commit]` | Recherche binaire d'un bug dans l'historique |

---

## 📖 Aide intégrée

| Commande | Description |
|---|---|
| `gDocs` | Affiche la cheat sheet complète de toutes les commandes, groupées par thème |
| `gHelp [cmd]` | Ouvre le manuel Git d'une commande spécifique |
| `Get-Help <fonction>` | *(PowerShell)* Documentation comment-based de n'importe quel alias |

```bash
gDocs
gHelp commit
```

```powershell
gDocs
Get-Help gCommit
```

> 💡 Chaque fonction PowerShell possède une aide comment-based (`Get-Help`) décrivant ses paramètres et fournissant des exemples.

---

## 🔌 Modules

Chaque module regroupe les fonctions d'un même thème. Les trois plateformes sont strictement alignées :

| Fichier (Linux / macOS / Windows) | Fonctions |
|---|---|
| `helpers.sh` / `helpers.sh` / `helpers.ps1` | `test_git`, `show_git_error`, `show_git_success`, `invoke_git` / idem / `Test-Git`, `Show-GitError`, `Show-GitSuccess`, `Invoke-Git` |
| `docs.sh` / `docs.sh` / `docs.ps1` | `gDocs` |
| `config.sh` / `config.sh` / `config.ps1` | `gHelp`, `gConfig` |
| `repository.sh` / `repository.sh` / `repository.ps1` | `gInit`, `gClone`, `gStatus`, `gClean`, `gArchive` |
| `staging.sh` / `staging.sh` / `staging.ps1` | `gAdd`, `gRemove`, `gMove`, `gCommit`, `gUntrack` |
| `branch.sh` / `branch.sh` / `branch.ps1` | `gBranch`, `gCheck`, `gSwitch`, `gMerge`, `gRebase`, `gWorktree`, `gMergeAbort`, `gMergeContinue`, `gRebaseAbort`, `gRebaseContinue` |
| `remote.sh` / `remote.sh` / `remote.ps1` | `gRemote`, `gPush`, `gPull`, `gFetch` |
| `history.sh` / `history.sh` / `history.ps1` | `gLog`, `gShow`, `gRestore`, `gReset`, `gRevert`, `gCherryPick`, `gReflog`, `gStash` |
| `inspect.sh` / `inspect.sh` / `inspect.ps1` | `gDiff`, `gBlame`, `gGrep`, `gShortLog`, `gDescribe` |
| `tags.sh` / `tags.sh` / `tags.ps1` | `gTag`, `gPushTag` |
| `submodule.sh` / `submodule.sh` / `submodule.ps1` | `gSubmodule` |
| `bisect.sh` / `bisect.sh` / `bisect.ps1` | `gBisect` |

---

## 📂 Structure du projet

```
git-commandes/
├── linux/                    # Implémentation Bash pour Linux
│   ├── index.sh              # Point d'entrée (charge tous les modules)
│   ├── helpers.sh            # Utilitaires partagés (test, invoke, messages)
│   ├── docs.sh               # Cheat sheet intégrée
│   ├── config.sh             # gHelp, gConfig
│   ├── repository.sh         # gInit, gClone, gStatus, gClean, gArchive
│   ├── staging.sh            # gAdd, gRemove, gMove, gCommit, gUntrack
│   ├── branch.sh             # gBranch, gCheck, gSwitch, gMerge, gRebase...
│   ├── remote.sh             # gRemote, gPush, gPull, gFetch
│   ├── history.sh            # gLog, gShow, gRestore, gReset, gStash...
│   ├── inspect.sh            # gDiff, gBlame, gGrep, gShortLog, gDescribe
│   ├── tags.sh               # gTag, gPushTag
│   ├── submodule.sh          # gSubmodule
│   ├── bisect.sh             # gBisect
│   └── README.md             # Guide d'installation Linux
├── macos/                    # Implémentation Zsh pour macOS
│   ├── index.sh              # Point d'entrée (charge tous les modules)
│   ├── helpers.sh            # Utilitaires partagés (test, invoke, messages)
│   ├── docs.sh               # Cheat sheet intégrée
│   ├── config.sh             # gHelp, gConfig
│   ├── repository.sh         # gInit, gClone, gStatus, gClean, gArchive
│   ├── staging.sh            # gAdd, gRemove, gMove, gCommit, gUntrack
│   ├── branch.sh             # gBranch, gCheck, gSwitch, gMerge, gRebase...
│   ├── remote.sh             # gRemote, gPush, gPull, gFetch
│   ├── history.sh            # gLog, gShow, gRestore, gReset, gStash...
│   ├── inspect.sh            # gDiff, gBlame, gGrep, gShortLog, gDescribe
│   ├── tags.sh               # gTag, gPushTag
│   ├── submodule.sh          # gSubmodule
│   ├── bisect.sh             # gBisect
│   └── README.md             # Guide d'installation macOS
├── windows/                  # Implémentation PowerShell pour Windows
│   ├── index.ps1             # Point d'entrée (charge tous les modules)
│   ├── helpers.ps1           # Utilitaires partagés (Test-Git, Invoke-Git...)
│   ├── docs.ps1              # Cheat sheet intégrée
│   ├── config.ps1            # gHelp, gConfig
│   ├── repository.ps1        # gInit, gClone, gStatus, gClean, gArchive
│   ├── staging.ps1           # gAdd, gRemove, gMove, gCommit, gUntrack
│   ├── branch.ps1            # gBranch, gCheck, gSwitch, gMerge, gRebase...
│   ├── remote.ps1            # gRemote, gPush, gPull, gFetch
│   ├── history.ps1           # gLog, gShow, gRestore, gReset, gStash...
│   ├── inspect.ps1           # gDiff, gBlame, gGrep, gShortLog, gDescribe
│   ├── tags.ps1              # gTag, gPushTag
│   ├── submodule.ps1         # gSubmodule
│   ├── bisect.ps1            # gBisect
│   └── README.md             # Guide d'installation Windows
└── README.md                 # Ce fichier
```

---

## 🧹 Désinstallation

### Linux

1. Supprimez la ligne d'import de `~/.bashrc` (ou `~/.zshrc`).
2. Supprimez le répertoire :

```bash
rm -rf ~/.config/alias/git-commandes
```

### macOS

1. Supprimez la ligne d'import de `~/.zshrc` (ou `~/.bash_profile`).
2. Supprimez le répertoire :

```bash
rm -rf ~/.config/alias/git-commandes
```

### Windows

1. Supprimez la ligne d'import de `$PROFILE`.
2. Supprimez le répertoire :

```powershell
Remove-Item -Path "$HOME\.config\alias\git-commandes" -Recurse -Force
```

---

## 🛟 Dépannage

| Symptôme | Solution |
|---|---|
| Les aliases ne fonctionnent pas | Vérifiez le chemin dans la ligne d'import, puis rechargez : `source ~/.bashrc` (Linux), `source ~/.zshrc` (macOS) ou `. $PROFILE` (Windows) |
| `❌ Git is not installed` | Installez Git (`sudo apt install git` sous Debian/Ubuntu, `xcode-select --install` ou `brew install git` sous macOS, Git for Windows sous Windows) et redémarrez votre terminal |
| `command not found: gStatus` | Les fonctions ne sont pas chargées : confirmez la présence de la ligne d'import correspondant à votre plateforme dans votre fichier de configuration |
| `Module not found: ...` (jaune) | Un fichier de module est absent — réinstallez le dossier `linux/`, `macos/` ou `windows/` en entier |
| Erreurs de syntaxe sur macOS | Le Bash 3.2 fourni par macOS est obsolète — utilisez Zsh, ou installez un Bash moderne via Homebrew |
| `Get-Help` ne retourne rien | Rechargez le profil (`. $PROFILE`) pour que les fonctions soient définies |

---

## 📄 Licence

Ce projet est **open source**. Vous pouvez l'utiliser, le modifier et le partager librement.

---

<div align="center">

**Fait avec ❤️ par [Joshué Agapé](https://github.com/raharison-joshue-agape)**

</div>
