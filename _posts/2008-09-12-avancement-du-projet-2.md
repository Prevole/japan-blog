---
layout:     post
title:      Avancement du projet
date:       2008-09-12 16:42:06 +0200
categories: ["Projet"]
image:      /assets/images/posts/2008-09-12-avancement-du-projet-2/wui_7.jpg
---

Voilà quelques temps que je n'ai pas parlé du projet et pour cause. Il n y avait pas vraiment lieu de le faire.
J'ai passé une partie du temps à faire des recherches sur mon problème de localisation, une partie sur les
possibilités d'une application web et puis une autre sur le recommencement de la partie cliente. Et oui, tout ce
que j'avais fait durant une semaine j'ai pu le mettre aux oubliettes pour partir sur un client web.

<!--more-->

Comme vous pouvez vous en douter, ça veut dire que je me suis pris quelques semaines de retard dans les dents. A
vrai dire je pense que j'en suis en tout cas à trois, et je pense que de base mon planning était un peu trop
optimiste. Du coup, je suis en train de revoir le cadre de certains cas d'utilisation pour rendre plus réaliste le
développement dans le temps imparti.

Passons ces quelques considérations et faisons un tour de ce qui est actuellement réalisé. Concrètement, je dispose
d'une quarantaine de cas d'utilisation et j'en ai complétement implémenté quatre à ce jour. C'est vraiment peu,
mais il faut comprendre que forcément avec mes quelques déboires, les choses n'ont pu aller dans le bon sens dès le
départ. Ceci dit, je commence à prendre mon rythme de croisière. J'ai déjà posé les grandes lignes et je commence à
entrer dans les détails.

Les cas d'utilisation implémentés sont les suivants :

- Démarrage du jeu
- Enregistrement de l'utilisateur
- Choix de l'avatar (partie comprise dans le cas d'utilisation précédent)
- Connexion du joueur au jeu
- Premier dialogue lors de la première connexion pour proposer une première quête.
- Proposition de quête dans un dialogue

Les cas d'utilisation en cours d'implémentation sont les suivants :

- Dialogue avec des personnages non joueur
- Localisation du joueur
- Affichage des éléments proches du joueur

Ca donne une petite idée de ce qui se passe dans le développement et ce qui se cache un petit peu derrière. Autant
le dire tout de suite, je ne vais pas étaler ici des schémas de base de données ou de conception objet. La partie
serveur prend du temps à faire et ne se voit pas. C'est toujours frustrant car souvent se cachent de jolies choses
pour les initiés :laughing:

A présent, je vous propose une visite guidée du client web. Les captures ont été prises sur l'émulateur que
j'utilise pour le développement. Comme je le disais, je ne peux pas faire un design de la mort qui tue (toute
manière j'en suis incapable, j'ai pas la fibre graphiste :laughing:) car les balises iXHTML à disposition sont
maigres mais suffisantes pour un rendu minimal et suffisamment satisfaisant.

Première capture, l'arrivée sur la page d'accueil qui offre le choix entre la connexion (par défaut) et
l'enregistrement de l'utilisateur.

{%- media_cartridge -%}
{% include img.html
    image="wui_1.jpg"
    type="portrait"
    title="Ecran d'accueil."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Pour cette petite présentation, j'ai passé directement par la case enregistrement où j'ai été amené à indiquer mon
nickname et mon mot de passe. A priori, les caractères japonais seront acceptés. La base de données est configurées
pour; l'échange de données entre le client et le serveur également. Je n'ai pas pu tester car je n'ai pas de
clavier me le permettant. Toutefois, j'ai fait un copier/coller de caractères trouvés sur le net et ça fonctionnait
très bien, sauf que dans phpmyadmin ça sortait bizarre mais pas au niveau du retour au client. Donc je pars de
l'hypothèse que ce point est bon.

{%- media_cartridge -%}
{% include img.html
    image="wui_2.jpg"
    type="portrait"
    title="Ecran d'enregistrement."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Vient le choix de l'avatar. Cet écran a été réalisé de manière à pouvoir être utilisé en dehors du processus
d'enregistrement de l'utilisateur. Il est indépendant de ce processus en d'autres termes. Un choix de neuf avatars
par page est proposé avec possibilité de changer de page.

{%- media_cartridge -%}
{% include img.html
    image="wui_3.jpg"
    type="portrait"
    title="Ecran du choix de l'avatar."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Une fois choisi et cliqué sur "Finish", on se retrouve sur un écran de confirmation qui nous invite à poursuivre.
Il n'est pas tout à fait fini mais s'inscrit dans un cadre générique d'affichage de message d'erreur, d'information
ou d'avertissement. Cet affichage est donc relativement générique.

{%- media_cartridge -%}
{% include img.html
    image="wui_4.jpg"
    type="portrait"
    title="Ecran de confirmation d'enregistrement."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Ensuite, nous nous retrouvons sur la page d'accueil et nous pouvons passer à la connexion. C'est ce que montre
l'écran suivant ou j'ai déjà rempli les valeurs nécessaires. La case "Remember me" est une expérience. A la base,
l'application devait permettre la connexion automatique. C'est ce que j'essaie de refaire avec les cookies (pour
ceux qui ne savent pas, c'est des petits fichiers qui se mettent dans votre navigateur pour garder des valeurs en
mémoire d'une visite à l'autre. Parfois ils sont très critiqués et parfois très utiles. J'entre pas plus en détail
sur le sujet). Etant donné la nature de l'application, le fait de conserver un mot de passe dans un cookie est pas
trop risqué. Il faut savoir que vu la nature de la navigation sur téléphone mobile il est plus difficile de
récupérer les cookies par une tierce personne. Dans ces conditions, j'accepte ce compromis de sécurité. J'ai pu
tester que ça fonctionne sur un navigateur normal mais impossible de tester sur l'émultateur. Dès lors, j'espère
que sur le téléphone mobile ça fonctionnera. Je verrai bien. Dans le cas contraire, la petite case disparaitra tout
simplement.

{%- media_cartridge -%}
{% include img.html
    image="wui_5.jpg"
    type="portrait"
    title="Ecran de connexion."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Lors de la première connexion au jeu, le joueur se retrouve à parler avec son avatar. Le but de ce premier dialogue
est de présenter le jeu et d'expliquer le mécanisme des quêtes. Après quoi, une quête est proposé au joueur (l'idée
étant par exemple de trouver un NPC étant le plus proche du joueur).

{%- media_cartridge -%}
{% include img.html
    image="wui_6.jpg"
    type="portrait"
    title="Ecran de dialogue."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Voici à présent l'écran qui propose une quête. Comme on peut le constater, la place dans la bulle n'est pas très
grande et ainsi, le détail de la quête ne peut être montré directement dans le dialogue. Pour pallier à ce
problème, un écran de détails de quête est prévu à partir du dialogue. Le lien pour aller aux détails de la quête
est d'ailleurs visible sur la droite de l'écran.

{%- media_cartridge -%}
{% include img.html
    image="wui_7.jpg"
    type="portrait"
    title="Ecran de proposition de quête."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Voici le détail de la quête (oui je sais, les textes laissent à désirer mais c'est du test. L'important pour le
moment était le mécanisme et pas le contenu. Le contenu va pas tarder, vous en faites pas.). Pour le moment, la
quête manque de substance. On ne voit par exemple pas les conditions à remplir pour réussir la quête ni même les
récompenses à obtenir en cas de succès. Les mécanismes d'affichage sont présents mais je n'ai pas mis de données
pour cette partie. Ca ne m'intéressait pas encore de tester cette partie.

{%- media_cartridge -%}
{% include img.html
    image="wui_8.jpg"
    type="portrait"
    title="Ecran de détails d'une quête."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Lorsqu'on retourne à l'écran de la proposition de la quête, on a le choix entre accepter ou refuser la quête. Pour
cette fois, j'ai accepté la quête. Voici ce que mon avatar me répond. Il faut savoir qu'en acceptant, la quête a
été ajoutée à mon journal de quête (que l'on ne peut pas encore voir, vu qu'il n'existe pas encore de
reprsésentation graphique :wink:). Mais au moins, la quête est à présent en cours.

{%- media_cartridge -%}
{% include img.html
    image="wui_9.jpg"
    type="portrait"
    title="Autre écran de dialogue."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Et pour finir, lorsque le dialogue prend fin comme c'est le cas à l'écran précédent, on se retrouve sur la vue
principale qui est la carte. Pour le moment celle-ci n'est pas implémentée et ne le sera pas avant un moment suite
à quelques petites difficultés. Toutefois, en attendant, je compte mettre en place une liste des objets à proximité
du joueur. Quand je dis objets, j'entends NPC, Joueurs et items.

{%- media_cartridge -%}
{% include img.html
    image="wui_10.jpg"
    type="portrait"
    title="Ecran vue de la carte."
    gallery="img"
%}
{%- endmedia_cartridge -%}

Tout ceci est réalisé au moyen d'images, de code iHTML et style directement inclus dans les balises. J'ai voulu
trouver un framework simple pour faire une application iMode mais je n'ai rien trouvé de pertinent en anglais ou en
français. Je pense qu'il existe sûrement une solution quelconque en japonais mais forcément voilà quoi :wink: J'ai
donc mis en place une solution simple et moche pour faire mon rendu graphique. Pour le moment ça va très bien. En
discutant avec mon professeur responsable, il m'a parlé de quelques pistes à suivre pour améliorer ça de manière
relativement simple mais personnellement, je doute sur le mot simple. Je pense que ma solution risque de me poser
des problèmes au moment du changement ce qui prouvera qu'elle est pas terrible mais a le mérite de pouvoir me
permettre d'avancer et d'avoir quelque chose à montrer. Pour cette partie d'amélioration, on avisera mais je sens
que ça va encore me prendre un peu de temps, mais ça sera probablement bénéfique à condition de pouvoir avoir un
jeu réduit de balises et de styles à utiliser et de pouvoir configurer correctement les entêtes iXHTML et entêtes
HTTP (je vise en particulier la gramaire DTD et le content-type).

J'ai oublié de signaler un petit détail qui n'est pas tant un détail que ça. Vous aurez remarqué que les images
utilisées pour les avatars ne sont certainement pas de mon fait. C'est des images temporaires que j'utilise et
elles sont tirées d'un logiciel qui se nomme RPG Maker Vx. Ce logiciel permet de créer des Jeux de rôle manière
"old school" de manière relativement simple. On peut se concentrer sur l'histoire et la réalisation plutôt que sur
le code.