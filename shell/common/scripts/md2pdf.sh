#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Utilisation : md2pdf <fichier.md>

Convertit un fichier Markdown en PDF (même nom, extension .pdf),
via pandoc + lualatex, avec la police Lato et des marges style français.

Exemple : md2pdf neurotide8.md
EOF
}

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

input="$1"

if [ ! -f "$input" ]; then
  echo "Erreur : fichier introuvable — $input" >&2
  exit 1
fi

if ! command -v lualatex >/dev/null 2>&1 || ! kpsewhich luaotfload-main.lua >/dev/null 2>&1; then
  echo "Erreur : composants LuaLaTeX manquants (fontspec/luaotfload)." >&2
  echo "Répare avec :  sudo apt install texlive-luatex" >&2
  exit 1
fi

if ! kpsewhich hyph-fr.tex >/dev/null 2>&1; then
  echo "Erreur : support de la langue française manquant (babel/hyphenation)." >&2
  echo "Répare avec :  sudo apt install texlive-lang-french" >&2
  exit 1
fi

output="${input%.md}.pdf"

pandoc "$input" -o "$output" \
  --pdf-engine=lualatex                              \
  -V lang=fr                                         \
  -V papersize=a4                   \
  -V mainfont="Lato"                \
  -V fontsize=11pt                  \
  -V geometry:margin=1.5cm          \
  -V geometry:top=2cm               \
  -V geometry:bottom=2.3cm

echo "OK : $output"
