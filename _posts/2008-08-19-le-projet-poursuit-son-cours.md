---
layout:     post
title:      Le projet poursuit son cours
date:       2008-08-19 15:15:11 +0200
categories: ["Projet"]
---

Voilà quelques jours que j'œuvre sur la partie cliente. Cela peut sembler étrange mais j'ai installé le kit de
développement qui est livré avec un émulateur. Ainsi, je peux déjà me faire une idée du résultat de ce que je
prépare, avant d'avoir un téléphone mobile.

<!--more-->

J'ai tout d'abord commencé par une simple application genre "Hello World" et j'ai vu que c'était simple à mettre en
oeuvre. Alors autant s'attaquer directement et concrètement à la partie cliente de mon projet.

# Prototype 1

J'ai commencé par simplement créer des images pour mes boutons, créer quelques bouts de code pour la communication
réseau, récupérer un code exemple pour pouvoir accéder au contenu présent dans une partie du téléphone (code livré
avec le SDK). Pour un premier jet, je me retrouve avec un écran de bienvenue où je ne peux cliquer que sur
"Registration", suivi d'un écran de saisie des données et enfin l'envoi des données au serveur. Je vous montre le
résultat obtenu ci-dessous (seulement pour la partie cliente). Il faut savoir que la base de données se met
correctement à jour par l'intermédiaire du serveur applicatif (EJB, Servlets, etc...)

{%- media_cartridge -%}
{% include img.html
    image="proto_1.jpg"
    type="portrait"
    title="Ecran de démarrage du premier prototype."
    gallery="img"
%}

{% include img.html
    image="proto_2.jpg"
    type="portrait"
    title="Ecran de saisie pour l'enregistrement d'un joueur."
    gallery="img"
%}

{% include img.html
    image="proto_3.jpg"
    type="portrait"
    title="Résultat de l'enregistrement dans une boîte de dialogue prédéfinie."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Comme on peut le constater, le rendu graphique n'est pas terrible. Pour un jeu, même éloigné des jeux habituels,
c'est désolant de ne pas avoir une interface plus colorée. Ceci dit, l'avantage ici c'est que je définis mes
composants, je les balance ou je veux et le reste se fait tout seul ou presque. Le placement et la disposition
c'est juste deux lignes de codes anecdotiques à mettre en place. Mais dès qu'il s'agit de sortir un petit peu du
lot et de faire quelque chose de personnalisé, c'est cuit.

Il faut savoir que jusqu'à présent, j'ai travaillé dans ce qu'ils appellent (NTT Docomo) l'High Level UI API. C'est
à dire les bouts de code de haut niveau pour construire une UI (User Interface - Interface Utilisateur). A ce
niveau, on réfléchit en termes de fonctionnalités et plus de placement et de ce genre de choses très vite galère à
gérer.

Alors je me suis ensuite, pour l'écran du choix de l'avatar, essayé à l'API dit Low Level UI. C'est à dire les
bouts de codes de bas niveau pour construire du graphisme. J'ai ainsi pris en main cette partie et je me suis
"amusé" à faire un affichage de 9 images d'avatars et le moyen de changer de page avec optimisation et mise en
cache pour éviter de retélécharger les images à chaque fois. Ceci dit, le problème majeur c'est que c'est à moi de
gérer toute la notion de navigation. C'est à dire que quand j'appuie sur le bouton gauche, je dois savoir où je
suis dans l'interface et où ça va me mener. Ce qui fait que tout le travail qui était fait précédemment ne l'est
plus et que c'est à moi de pallier aux manquements.

{%- media_cartridge -%}
{% include img.html
    image="proto_4.jpg"
    type="portrait"
    title="Choix de l'avatar première version."
    gallery="img"
%}

{% include img.html
    image="proto_5.jpg"
    type="portrait"
    title="Choix de l'avatar page suivante première version."
    gallery="img"
%}
{%- endmedia_cartridge -%}

La partie du changement/choix d'avatar me satisfait déjà pas mal. Ceci dit, il faut que je mette en oeuvre un moyen
plus efficace de gérer le changement de sélection et de gérer les événements des utilisateurs. Ca sera pour la
prochaine fois que j'y touche.

# Prototype 2

A partir de la base précédente, je me suis dit que je pouvais peut-être obtenir un résultat pas trop mal avec l'API
High Level. Et finalement je ne suis pas très convaincu par ce que j'ai fait. La customisation de l'interface est
très sommaire et pas très facile à faire. Je vous laisse admirer le résultat des deux écrans précédents pour cette
nouvelle mouture.

{%- media_cartridge -%}
{% include img.html
    image="proto_6.jpg"
    type="portrait"
    title="Ecran de bienvenue version API High Level."
    gallery="img"
%}

{% include img.html
    image="proto_7.jpg"
    type="portrait"
    title="Ecran d'enregistrement version API High Level."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Comment on peut le voir c'est pas trop mal mais pour arriver, là il m'a fallu batailler pas mal de temps. Et comme
on le voit sur le deuxième écran, ce n'est pas encore au point. Il reste encore du travail à faire si tant est que
c'est cette direction que je choisisse. A priori, je suis pas totalement convaincu par cette manière de faire qui
me laisse peu de marge de manœuvre.

# Prototype 3

Pour ce dernier prototype, j'ai pris la décision de partir avec l'API Low Level. Cette fois, je dois tout faire
moi- même, mais au moins je matrise tout. Je veux quelque chose, je le dessine moi même. Je veux un champ texte
éditable, je le dessine, je dessine le texte et je le rends éditable par un moyen quelconque. Ceci complique la
chose c'est vrai, mais au moins je fais comme je veux, mon interface.

{%- media_cartridge -%}
{% include img.html
    image="proto_8.jpg"
    type="portrait"
    title="Ecran de bienvenue du troisième prototype."
    gallery="img"
%}

{% include img.html
    image="proto_9.jpg"
    type="portrait"
    title="Ecran d'enregistrement du troisième prototype."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Le premier écran donne bien (selon moi, après les goûts et les couleurs :laughing:) et le second est pas encore tout à
fait au point. Ceci dit, on voit qu'à présent un titre peut être apparent sur l'écran et que le look &amp; feel
reste pareil que pour la page précédente (au placement près des composants qui sont n'importe comment pour le
moment :laughing:).

# Résumé

Au final, on s'apperçoit que j'ai pris trois options durant mes essais et que chacune des options a ses avantages
et inconvénients. Malheureusement (ou heureusement, dépend du point de vue) pour moi, la voie qui me semble la plus
appropriée, est celle qui est la plus compliquée et la plus longue, c'est à dire de tout faire soi-même. J'ai tenté
de faire quelques recherches mais le problème, c'est que beaucoup de ressources sont uniquement en japonais ce qui
les rend inaccessibles pour moi actuellement. Comme je dois avancer dans mon projet, il m'aparaît nécessaire de
prendre une décision et celle-ci repose sur mes expérimentations de ces jours. Ainsi, je vais opter pour la voie du
troisième prototype.

# Divers

Voici une image d'un champ de saisie de texte activé. En effet, le mobile s'occupe nativement de la saisie du
moment que l'on configure quelques petits trucs. C'est vraiment intéressant mais c'est sûr que ça casse le look
&amp; feel général. Toutefois, impossible de voir comment modifier ça. Je suis obligé de faire un compromis pour
cette partie là. Ca reste acceptable :wink:

{%- media_cartridge -%}
{% include img.html
    image="proto_10.jpg"
    type="portrait"
    title="Ecran de saisie gérée nativement par le mobile."
    gallery="img"
%}
{%- endmedia_cartridge -%}
