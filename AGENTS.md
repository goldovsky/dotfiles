# AGENTS.md

## Rôle

Dotfiles d'un poste de travail Linux : Alacritty + tmux + bash, Neovim et
VS Code comme éditeurs, et un « docker-mode » tmux pour travailler dans un
conteneur de dev. Dépôt personnel, mono-utilisateur, sans CI.

À lire selon le besoin, pas systématiquement :

| Document | Quand le lire |
|---|---|
| `README.md` | installer le dépôt, comprendre la table des packages |
| `tmux/README.md` | toucher à tmux : sessionizer, docker-mode, scripts, `local.tmux` |
| `keyd/README.md` | toucher au clavier : capslock, rangée AZERTY, séquence de panique |
| `vscode/README.md` | comprendre pourquoi VS Code est copié et non symlinké |
| `TODO.md` | chantiers ouverts et décisions déjà tranchées — **à lire avant de proposer** une idée, plusieurs y sont déjà écartées avec leur raison |

## Surface

Quel package vise quoi, et par quel mécanisme. C'est la table de routage : une
modification se fait **dans le dépôt**, jamais dans la cible.

| Package | Cible | Méthode |
|---|---|---|
| `alacritty`, `fastfetch`, `ghostty`, `nvim`, `starship` | `~/.config/<pkg>/` | stow |
| `tmux` | `~/.tmux.conf`, `~/.config/tmux/` | stow |
| `opencode` | `~/.config/opencode/{opencode.jsonc,AGENTS.md}` | stow `--no-folding` |
| `shell` | `~/.bashrc`, `~/.zshrc`, `~/.config/shell/{bash,common}` | symlink manuel |
| `keyd` | `/etc/keyd/default.conf` | `keyd/install.sh` (sudo) |
| `vscode` | répertoire de profil VS Code | copie **live → dépôt** via `code-sync` |

## Invariants

- **Le dépôt doit être à `~/git/dotfiles`.** Trois fichiers y codent le chemin
  en dur : `alacritty/.config/alacritty/alacritty.toml:6`,
  `ghostty/.config/ghostty/config:10`, `shell/common/themes/generate-colors.sh:19`.
  Ailleurs, les imports de couleurs ne résolvent plus rien.
- **Ne jamais lancer `stow -t ~ shell`.** La structure est `shell/<shell>/…`,
  donc stow créerait `~/bash`, `~/zsh` et `~/common` au lieu des cibles voulues.
  Ces liens sont faits à la main. Rendre `shell/` stow-compatible est un
  chantier ouvert (`TODO.md`).
- **Fichiers générés, à ne jamais éditer à la main** :
  `shell/common/themes/outputs/*`, le bloc sous `# AUTO-GENERATED` de
  `starship/.config/starship/starship.toml:192`, et
  `~/.config/opencode/themes/custom.json`. La source est
  `shell/common/themes/presets/<preset>.json` ; on édite le preset puis on
  relance `theme <preset>`.
- **VS Code va du live vers le dépôt, jamais l'inverse.** Les réglages
  s'éditent dans l'éditeur, qui fait autorité ; le chemin du profil contient un
  hash non portable, donc un symlink stow est impossible.
- **conda reste hors de `~/.bashrc`.** `conda init` écrit dans ce fichier et a
  déjà remplacé le symlink silencieusement. Son init vit dans `~/.bashrc_local`.
- **`opencode` se stow avec `--no-folding`.** opencode écrit `node_modules/`,
  des lockfiles et `themes/custom.json` dans son dossier ; replié en symlink,
  tout atterrirait dans le dépôt.
- **Le package `opencode` ne contient ni modèle, ni provider, ni MCP, ni nom
  de client.** Ces valeurs vivent dans la couche mission (`OPENCODE_CONFIG_DIR`,
  dépôt d'équipe) et la couche machine (`OPENCODE_CONFIG`,
  `~/.config/opencode-local/`), exportées par `~/.bashrc_work`. Les
  credentials sont dans `~/.secrets/`, lus via `{file:…}`.
- **Dépôt public : `bin/leak-check.sh` doit passer.** Les noms de client à
  refuser sont dans `~/.config/dotfiles/leak-patterns`, jamais dans le dépôt.
- **Rien de secret n'est commité.** Les valeurs propres à la machine vivent
  dehors et ne sont sourcées que si présentes : `~/.bashrc_local`,
  `~/.bashrc_work`, `~/.zshrc_work`, `~/.config/tmux/local.tmux`,
  `shell/common/zb.conf` (gitignoré, a un `.example`).

## Pièges

- **`.stow-global-ignore` à la racine n'est lu par personne.** GNU Stow lit
  `~/.stow-global-ignore` (dans le home) ou `.stow-local-ignore` à la racine de
  *chaque package*. Le fichier présent ici est donc inerte : ce qu'il prétend
  exclure (`.config/alacritty/themes/`, `.config/starship/archive/`) est en
  réalité symlinké. Ne pas s'appuyer dessus pour raisonner sur l'état réel ;
  demander à stow via `stow -n -v`.
- **`stow --adopt` écrase le contenu du dépôt par le fichier du home**, il ne
  fusionne pas. À n'utiliser que si la version du home est bien celle à garder,
  et toujours sur un arbre git propre pour pouvoir lire le diff ensuite.
- **`batcat` et `fdfind`** : sur Debian/Ubuntu, `bat` et `fd` portent ces noms.
  Sonder les deux, comme le fait `shell/common/scripts/zb.sh:6`.

- **Pen réécrit `~/.config/opencode/opencode.json`** via « Settings → MCP »,
  avec un chemin `/tmp/.mount_Pen-*` qui meurt au relancement. Ne pas
  l'utiliser : pencil est déclaré dans la couche machine et pointe vers le shim
  `~/.local/opt/pen/pen-mcp-server`. `dotcheck` signale ce fichier s'il
  réapparaît.

## Validation

```bash
bin/dotfiles-check.sh          # lecture seule, exit 1 si dérive
bin/dotfiles-check.sh --quiet  # seulement les problèmes
bin/leak-check.sh --all        # secrets et noms de client dans les fichiers suivis
```

Vérifie l'emplacement du dépôt, les 6 packages stow (via `stow -n -v`), les
symlinks manuels, keyd, la fraîcheur des fichiers de thème (régénération en
répertoire temporaire puis diff), la dérive VS Code, les fichiers machine-local
les couches opencode (variables d'env, `opencode.json` parasite, hook et
leak-check) et les dépendances.

**Ce qu'il ne prouve pas** : qu'une config est *correcte*, que les plugins tmux
ou nvim sont installés, ni qu'un shell démarre réellement. Il compare des
fichiers et des liens. Un avertissement (`?`) ne fait pas échouer la commande,
une erreur (`!`) oui.

Pas de `--fix` volontairement : chaque correction est une commande unique
(`stow -t ~ <pkg>`, `theme <preset>`, `code-sync`) et mérite d'être lancée en
connaissance de cause.

## Conventions

- **Ne jamais commiter sans demande explicite du développeur.** Pas
  d'exception, même si le travail semble terminé et l'arbre propre.
- Commits conventionnels avec scope : `feat(tmux):`, `fix(starship):`,
  `docs:`, `perf:`, `refactor:`, `chore:`.
- Conversation en français ; fichiers, commentaires et commits en anglais.
- Scripts : `#!/usr/bin/env bash`, `set -euo pipefail`, et un en-tête de
  commentaire donnant le rôle, l'usage et **la raison d'être** du script —
  voir `shell/common/scripts/code-sync.sh` ou
  `tmux/.config/tmux/scripts/sessionizer.sh`.
- Écrire pourquoi, pas quoi. Les commentaires de ce dépôt documentent des
  décisions et des pièges rencontrés ; un commentaire qui paraphrase le code
  n'apporte rien.
- Toute modification de la surface, d'un invariant ou de la commande de
  validation doit être répercutée dans ce fichier **dans le même commit**.
