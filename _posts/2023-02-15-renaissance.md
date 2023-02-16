---
layout:     post
title:      Le blog renait
date:       2023-02-15 22:42:00 +0100
categories: ["Général"]
---

Il y a plus de dix ans, mon blog sur mes aventures japonaises voyait son dernier article publié. Depuis, plus un seul 
article, ni un seul commentaire. Le calme plat.

<!--more-->

Avec les années, mon blog vieillissait et voyait son obsolescence programmée arriver à petit feu. Mon blog étant basé
sur WordPress, il m'était obligatoire de faire les maintenances techniqes pour éviter les problèmes. Malheureusement,
cette maintenance prend du temps. Il faut mettre à jour le code, adapter les plugins utilisés, recoder des bouts. Et 
surtout, par moment, décider de désactiver telle ou telle fonction par incompatibilité entre WordPress et les plugins
utilisés.

C'est sans compter également la partie design du site qui a vieillit mais qui ne suis pas non plus très bien l'évolution
des plugins utilisés dans le site. Je pense notament aux galeries d'images, aux medias inclus dans les pages, les vidéos
tout en flash alors que cette technologie n'est plus disponible.

Enfin bref, vous l'aurez compris. Un site, ça s'entretien comme une voiture, une maison, ou n'importe quel autre chose
si l'on souhaite pouvoir le conserver dans la durée. Et c'est ce que je n'ai pas fait avec assiduité avec ce blog.

Un autre problème qui commençait à se faire sentir est la conservation de la donnée. J'entends par là, les contenus, les
récits, les images et tout ce qui fait les souvenirs qui me tiennent à coeur présents sur mon blog. J'inclus bien 
entendu également les commentaires de mes lecteurs.

Je ne risquais pas forcément de perdre réellement les textes mais je risquais tout de même de ne plus pouvoir les 
utiliser facilement. C'est nettement moins pratique de lire des textes dans une base de données que dans une page HTML
sur Internet.

Ça fait déjà plusieurs années que je me pose régulièrement la question de comment je vais faire cette transition de ce
blog dynamique basé sur WordPress à une solution plus statique me permettant de continuer à profiter des contenus.

Depuis quelques années également, un mouvement de mode s'articule autour de ce qu'on appelle les site statiques et les 
générateurs de sites statiques. L'idée qui se cache derrière est de stocker des documents textuels des articles et de 
compiler le site en entier ce qui produit de "bêtes" pages HTML qu'il suffit de servir via un serveur web.

Un des grands, très grands, avantages que je vois à cette stratégie versus un site dynamique, c'est que tous les 
contenus sont stockés dans de "bêtes" fichiers textes. Ainsi, la matière première du site reste toujours dans un format
de données facile à exploiter. Il est peu probable que dans 30-40 ans ou plus on ne puisse plus lire de simples fichiers
textes. Ce qui n'est pas forcément le cas pour une base de données si on ne suit pas l'évolution technologique.

Bien sûr que la génération du site statique actuel repose sur des technos d'aujourd'hui et que je ne sais pas de quoi
demain sera fait. Les standards CSS, HTML et JavaScript évoluant sans cesse, il est très probable que dans quelques
années, mon site statique sera également en perte de vitesse avec des technos qui ne fonctionneront plus si facilement.
Toutefois, mes articles et medias relatifs étant stockés en format brut seront beaucoup plus facile à ré-exploiter dans
d'autres solutions du moment. Ils resteront au pire facilement lisible même sans un enrobage graphique conséquent.

Sur ces belles paroles, je vous laissse sur de vieux souvenirs d'il y a plus de dix ans.

{%- media_cartridge -%}
{% include img.html
    image="japan-site-2008-main.png"
    type="landscape"
    thumb_size="300x225"
    title="Home page"
    gallery="img"
    show_legend="yes"
%}

{% include img.html
    image="japan-site-2008-post.png"
    type="landscape"
    thumb_size="300x225"
    title="Article"
    gallery="img"
    show_legend="yes"
%}
{%- endmedia_cartridge -%}
