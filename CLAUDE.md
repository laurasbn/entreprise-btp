# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**entreprise-btp** — outils fichiers pour l'entreprise du bâtiment (file tools for a construction company).

This repository is in its early stages. No build system, framework, or language stack has been established yet.

## Language

The project is French-language: comments, variable names, documentation, and commit messages should be written in French unless a specific technical standard dictates otherwise.


## ⚠️ TÂCHE URGENTE — À faire dès que atelierpaca.fr est actif

**Remplacer toutes les URLs `laurasbn.github.io/entreprise-btp/` par `atelierpaca.fr`** dans TOUS les fichiers HTML du repo (index.html + 42 pages SEO).

Concerne les balises suivantes dans chaque fichier :
- `<link rel="canonical" href="...">`
- - `<meta property="og:url" content="...">`
  - - `<meta property="og:image" content="...">`
    - - `<meta name="twitter:image" content="...">`
      - - JSON-LD : champs `"url"`, `"@id"` et `"image"`
       
        - **Commande terminal à exécuter (depuis le dossier du repo) :**
        - ```
          sed -i 's|https://laurasbn.github.io/entreprise-btp/|https://atelierpaca.fr/|g' *.html
          ```
          Puis : `git add . && git commit -m "Fix URLs : laurasbn -> atelierpaca.fr" && git push`
