#!/usr/bin/env bash
# Wraps neurology-note.html (the published Artifact source) into a standalone page you can open directly in a browser.
set -euo pipefail
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%%}[hidden]{display:none!important}</style>\n</head>\n<body>\n'
  cat neurology-note.html
  printf '\n</body>\n</html>\n'
} > index.html
echo "Built index.html"
