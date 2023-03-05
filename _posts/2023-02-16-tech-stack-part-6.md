---
layout:     post
title:      Le Stack Technologique - Partie 6
date:       2023-02-16 22:24:00 +0100
categories: ["Général"]
---

La partie `build and publish` repose sur un outil et une plateforme. L'outil en question, il s'agit de `git` qui est un
gestionnaire de version de fichiers. Comme son principe l'indique, il s'agit de garder des fichiers et l'historique
des modifications successives dans le temps. La plateforme, il s'agit de [GitHub](https://github.com){:target="_blank"}.
Cette plateforme offre tout un écosystème autour de l'outil `git`.

<!--more-->

Et parmi cet écosystème, les [GitHub Actions](https://github.com/features/actions){:target="_blank"} est ce qui va nous 
occuper dans cet article. C'est le mécanisme que j'ai choisi pour construire et publier mon site statique sur 
[S3 d'AWS](https://aws.amazon.com/s3/){:target="_blank"} (nous reviendrons sur ça une autre fois).

Les GitHub Actions permettent d'exécuter des `workflows` où sont exécutés des `jobs` contenant des `steps`. Bam, trois
mots clés dans la même phrase. On va simplifier tout ça. En gros, un `step` représente une commande ou un script qui
effectue une ou plusieurs opérations (exemple: compiler, tester, copier des fichiers, …). Un `job`, représente un 
regroupement d'étapes. Ces étapes seront exécutées dans l'ordre et dans un tout cohérent. Et pour finir, un `workflow`
est "simplement" un fichier qui contient un ou plusieurs job et qui peut être déclenché (le workflow) en fonction 
d'événements (exemple: pousser du code, appel depuis un autre workflow, exécution manuelle, …).

Dans mon cas, j'ai deux workflows. Ces workflows se trouvent dans le répertoire de mon site statique sous 
`.github/workflows`. C'est l'emplacement réservé pour les workflows de GitHub.

- Un workflow de build: `build.yaml`
- Un workflow de publication: `publish.yaml`

# Build Workflow

Mon workflow de build est relativement simple. Il repose sur une simple commande `bundle exec jekyll build` mais une 
fois mis dans un workflow voici ce que ça donne.

~~~yaml
# C'est le nom du workflow tel qu'il apparaît dans 
# l'interface de GitHub.
name: Build

# On détermine les événements déclencheur du build.
on:
  # Lorsqu'on publie du nouveau code sur la branch
  # principale du code.
  push:
    branches: [ main ]

  # On se garde la possibilité de pouvoir déclencher 
  # à la main le workflow.
  workflow_dispatch:

# Liste des jobs, il n'y en a cas car je suis dans
# un cas simple.
jobs:
  build:
    # On choisi une architecture sur laquelle 
    # exécuter notre job.
    runs-on: ubuntu-latest
    steps:
      # Première étape, on récupère le code.
      - name: Checkout project
        uses: actions/checkout@v3

      # Deuxième étape, on configure Ruby.
      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          # Petite optimisation pour éviter
          # de devoir télécharger les dépendances
          # à chaque exécution.
          bundler-cache: true

      # Finalement, l'étape de build.
      - name: Build Site
        run: bundle exec jekyll build
        env:
          # On s'assure d'être en mode production.
          JEKYLL_ENV: production
~~~

Et s'en est terminé avec la partie de build. Facile, non ? :smiley: Une fois qu'on a les bases des workflows GitHub 
actions c'est assez facile.

# Publish Workflow

Par contre, là où tout se complique, c'est lorsqu'on veut réutiliser des workflows pour éviter de dupliquer du code ou
éviter d'exécuter du code à double ce qu'on essaie d'éviter si possible.

{% admonition danger %}
Je ne l'ai pas mentionné jusque là mais les GitHub Actions n'est pas une fonctionnalité totalement gratuite. De base, 
chaque utilisateur se voit offrir un nombre de minutes d'exécution par mois. Au delà de ce nombre de minutes, il faut 
passer au tiroir caisse.
{% endadmonition %}

Ce que je souhaitais faire à l'origine, c'est d'avoir mon workflow de build qui trigger mon workflow de publication en 
passant les fichiers buildés. Malheureusement, les GitHub Actions ne fonctionnent pas comme ça. Chaque `job` s'exécute
dans un contexte isolé et à la fin de l'exécution se contexte disparaît (c'est un peu plus subtile que ça mais pour
notre cas de figure, c'est ce qui se passe). Par conséquent, les fichiers qui sont générés par le job de build ne sont
pas disponibles directement pour le job de publish.

Deux mécanismes existent dans GitHub Actions pour contourner le problème:

- Upload/download d'artifacts
- Cache

J'ai testé la première fonctionnalité mais il me fallait plus de 10 minutes pour juste pour la partie upload. Mais
comment est-ce possible ??? Ben, c'est assez simple, mon site statique généré contient plusieurs milliers de fichiers
pour être exact, 9036 fichiers au moment de mes tests. Entre les images, leurs miniatures, les articles et tout le 
reste, ça fait beaucoup de fichiers. Sans compter que la taille des images représente plus de 1GB de données.

{% admonition bug %}
Attention, je ne souhaite pas ouvrir un débat sur le fait de stocker des images et vidéos sur `git` et `GitHub`. C'est
clairement pas l'idée la plus géniale mais à l'heure où j'écris ces lignes, c'est l'idée la plus pratique en attendant
de mieux. 

Je suis largement preneur de suggestions, idées ou concepts pour cette partie d'assets statiques qui seraient bien mieux
ailleurs que sur `git`.
{% endadmonition %}

Par conséquent, en pratique, c'est juste pas possible. Du coup, je n'ai pas encore testé le second mécanisme en posant
l'hypothèse que mes fichiers générés sont pas des plus pratiques à mettre en cache. Du coup, pour l'instant, je me suis
résolu à créer deux workflows distincts mais dont le `publish` duplique la partie `build` de l'autre workflow. Voici le 
code du workflow de publication.

~~~yaml
name: Publish

on:
  # On peut exécuter le workflow à la main
  workflow_dispatch:
    
  # Où sinon, le workflow se déclenche quand le workflow
  # de build se termine avec succès et seulement sur la 
  # branche principale.
  workflow_run:
    workflows:
      - build
    branches:
      - main
    types:
      - completed

# Quelques variables d'environnement pour configurer la 
# publication sur S3 d'AWS (nous y reviendrons).
env:
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  AWS_DEFAULT_REGION: ${{ secrets.AWS_DEFAULT_REGION }}
  AWS_S3_BUCKET_NAME: ${{ secrets.AWS_S3_BUCKET_NAME }}

jobs:
  publish:
    runs-on: ubuntu-latest
    
    # On exécute le workflow uniquement si le build s'est
    # terminé avec succès.
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    
    # On choisit d'exécuter ce job dans le contexte de 
    # l'environnement de production. Nous reviendrons
    # sur ça par la suite.
    environment: production
    steps:
      # Les trois premières étapes sont les mêmes 
      # que le job de build vu précédemment.
      - name: Checkout project
        uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true

      - name: Build Site
        run: bundle exec jekyll build
        env:
          JEKYLL_ENV: production

      # Finalement, on utilise une commande du client AWS pour publier
      # les fichiers (synchroniser serait plus correct).
      - name: "Deploy to AWS S3"
        run: |
          aws s3 sync ./_site/ s3://{% raw %}${{ secrets.AWS_S3_BUCKET_NAME }}{% endraw %} \
            --delete --cache-control max-age=604800 --size-only
~~~

Il est temps d'aborder la notion d'environnement offerte par les GitHub Actions. Ça permet de créer des contextes où 
des variables peuvent être cloisonnées (ou secrets). C'est pas ce qui m'a intéressé directement dans mon cas. Ce qui 
m'a intéressé c'était la notion d'approbation des workflows qui peuvent se configurer par environnement. 

En effet, j'ai configuré mon workflow de publication pour que je sois approbateur de mon workflow. Ainsi, quand le 
workflow de build s'exécute, se termine et qu'il déclenche le workflow de publication, celui-ci se met en attente tant
que les conditions d'approbations n'ont pas été remplies. C'est une sorte de workaround pour éviter de publier à chaque
fois que je publie des modifications sur mon site statique. Ça me donne le contrôle de quand et quoi je publie.

{%- media_cartridge -%}
{% include img.html
    image="environment-production.png"
    type="landscape"
    thumb_size="300x225"
    thumb_width="300"
    thumb_height="218"
    title="Environnement de production"
    gallery="img"
%}
{% include img.html
    image="actions-secrets.png"
    type="landscape"
    thumb_size="300x225"
    thumb_width="300"
    thumb_height="228"
    title="Les secrets configurés pour les GitHub Actions"
    gallery="img"
%}
{%- endmedia_cartridge -%}

Une fois que c'est configuré, ainsi que le workflow correctement écrit, ça nous donne la fonctionnalité de ne plus 
pouvoir déployer automatiquement. Les processus sont automatiques mais le dernier mot revient au clic que je fais sur
oui ou non pour l'exécution du workflow de publication. Je reçois une notification par email et je vois dans 
l'interface des GitHub Actions que j'ai des workflows en attente.

{%- media_cartridge -%}
{% include img.html
    image="publish-workflow-waiting.png"
    type="landscape"
    thumb_size="300x225"
    thumb_width="300"
    thumb_height="134"
    title="Écran des exécutions des workflows avec le workflow de publication en attente d'approbation"
    gallery="img"
%}
{% include img.html
    image="cancel-workflow.png"
    type="landscape"
    thumb_size="300x225"
    thumb_width="300"
    thumb_height="132"
    title="Détails du workflow de publication en attente avec possibilité d'annulation ou d'approbation"
    gallery="img"
%}

{% include img.html
    image="publish-workflow-review-1.png"
    type="landscape"
    thumb_size="300x225"
    thumb_width="300"
    thumb_height="188"
    title="Écran d'approbation du workflow de publication"
    gallery="img"
%}

{% include img.html
    image="publish-workflow-review-2.png"
    type="landscape"
    thumb_size="300x225"
    thumb_width="300"
    thumb_height="186"
    title="Exemple d'approbation"
    gallery="img"
%}
{%- endmedia_cartridge -%}

# Conclusion

Au final, le setup que j'ai mis en place pour publier mon site statique n'est pas si mal. J'aurai pu utiliser 
directement une fonctionnalité de GitHub, les [GitHub Pages](https://pages.github.com/){:target="_blank"} mais quand 
on lit leur documentation ce n'est pas vraiment fait pour mon cas d'utilisation. Je doute qu'ils contrôlent assidûment 
l'utilisation que font les gens de cette fonctionnalité. Le jour où je tiendrai un blog technique avec peu d'images en
comparaison à ce que j'ai ici, j'y penserai plus sérieusement car tout est out-of-the-box ou presque :smiley:

Dans le prochain article, nous aborderons la partie AWS S3 qui héberge mon site statique ainsi que les configurations
nécessaires pour que celui-ci soit accessible.