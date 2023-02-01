---
layout:     post
title:      Et le projet ? Ça en est où ?
date:       2008-08-12 13:14:13 +0200
categories: ["Projet"]
---

Ça fait quelque temps que je n'ai plus parlé de mon projet et de l'état d'avancement. Alors je vais vous faire un
petit point de situation (parfois technique) d'où en sont les choses.

<!--more-->

# Téléphone mobile

Pour le choix du téléphone mobile, ça avance. Nous sommes arrivés à la conclusion que NTT Docomo (le swisscom
mobile du coin :wink:) conviendra le mieux à mes besoins en termes de service et de facilité de développement. Cet
opérateur impose DoJa comme profil de développement Java. Pour faire simple, c'est du Java mais spécifique à NTT
Docomo. Donc pas compatible directement avec les deux autres opérateurs (AU by KDDI et Softbank). Ce profile est
relativement proche du profil standard MIDP de Sun Microsystems mais comporte bien entendu des différences
propriétaires (ça serait trop facile sinon).

Trois téléphones sont envisagés pour le moment :

- SH906i de Sharp
- SO906i de Sony-Ericsson
- SO905i de Sony-Ericsson

Le choix définitif n'étant pas encore fait mais ne saurait plus trop tarder. Il faut bien que je débute avec le
développement sur le téléphone mobile si je veux un jour avoir une application utilisable.

# DoJa 5.1

Entre hier et aujourd'hui, j'ai réussi à installer l'environnement de développement pour la version 5.1 de DoJa. Il
m'a fallu pas mal ruser je dois dire. De base, l'environnement n'est fait que pour des OS en japonais ou en anglais
(US) et à priori du Windows XP. Après avoir trouvé une astuce, j'arrive à avoir cet environnement en Anglais (US)
sous mon Windows XP français (CH). C'est ce qui m'a occupé tout le matin hier.

Après quoi, je me suis amusé à créer une petite application vraiment toute simple qui affiche simplement "Hello
World !" (c'est un classique du genre d'ailleurs :laughing:). Je vous laisse découvrir les images de ce que ça produit
dans l'émulateur fourni avec l'environnement de développement. C'est pas fantastique mais deja arriver à ce
résultat c'est bien satisfaisant.

<!-- /assets/images/posts/2008-08-12-et-le-projet-ca-en-est-ou/screen_1.jpg -->
{% include img.html
    image="screen_1.jpg"
    type="portrait"
    title="Démarrage de l'application démo."
    gallery="img"
%}

<!-- /assets/images/posts/2008-08-12-et-le-projet-ca-en-est-ou/screen_2.jpg -->
{% include img.html
    image="screen_2.jpg"
    type="portrait"
    title="Quelques clics sur le bouton Hello World !"
    gallery="img"
%}

<!-- /assets/images/posts/2008-08-12-et-le-projet-ca-en-est-ou/screen_3.jpg -->
{% include img.html
    image="screen_3.jpg"
    type="portrait"
    title="Clic sur le bouton quitter."
    gallery="img"
%}

# Partie serveur et explications sur le jeu

Un gros morceau qui n'est pas visible directement des utilisateurs/joueurs est la partie serveur. Sans elle pas de
jeu. C'est toute la partie logique de résolution du jeu. Autant dire que c'est un sacré gros morceau. Jusqu'à
présent, je n'avais pas encore les idées très claires sur cette partie mais ça commence à venir. J'ai deja pu poser
la partie d'enregistrement des joueurs (c'est très basique et il n'y a pas encore de sécurité mais ça fonctionne).
J'ai également avancé la partie gestion des quêtes.

Pour rappel, mon jeu se propose de placer le joueur dans un pseudo jeu de rôle basé dans un contexte géographique
réel qui n'est autre que la ville de Kyoto. C'est à dire, que le terrain de jeu est la ville elle même et que tous
les éléments que le joueur voit dans le jeu sont virtuels mais avec un emplacement dans la ville. Le joueur sera
amené à accomplir des quêtes qui pourront simplement lui demander d'aller à un endroit ou d'aller parler à un NPC
(Personnage Non-Joueur - Non-Player Character). Les possibilités de quêtes sont très grandes et pas déterminées
actuellement avec une grande précision. C'est d'ailleurs le but pour l'instant.

D'autre part, le joueur pourra récupérer des objets qui lui permettront de mieux s'équiper ou de gagner de l'argent
en les revendant auprès des NPC adéquats. Il pourra également utiliser des objets dans le cadre de combats ou
simplement dans le cadre du jeu lui même.

En plus de cela, le jeu est décomposé en deux modes. Un premier orienté touriste et personne résidant pour une
courte période à Kyoto et un mode normal pour les joueurs assidus. Dans le premier mode, toute la partie RPG
(progression, monstres, objets d'équipement, ...) seront mis de côté. Ce premier mode est vraiment centré sur les
quêtes dans le but pédagogique de faire profiter des richesses de la ville. Alors que le second sera plus orienté
jeu pour les mordus (et les moins mordus d'ailleurs).

Pour le moment on retrouve tous les aspects que couvre mon projet : Culture, Téléphonie Mobile, Géo-Localisation,
Informatique. Il manque à définir l'exergaming. L'idée est de faire faire de l'exercice au joueur de manière
agréable et naturelle sans que celui-ci se sente obligé de le faire de manière rébarbative. Pour ce faire, la
marche à pied ainsi que le vélo sont deux pistes qui sont privilégiées. Imaginez que l'on mesure la vitesse d'un
parcours et qu'en fonction de cette vitesse, le personnage que vous incarnez recouvre sa santé plus rapidement ou
qu'il gagne de l'expérience ou de l'argent dans le jeu. C'est une piste parmi d'autres.

D'autres interactions sont prévues comme les discussions avec les NPC. C'est d'ailleurs ce sur quoi je travaille
actuellement et je peux vous dire que ce n'est pas simple. Il faut imaginer un moyen de créer des dialogues
relativement interractifs tout en permettant de casser le fil d'un dialogue en fonction d'un état (par exemple: un
NPC qui répond spécifiquement à un joueur car celui-ci est en train de faire une certaine quête).

# Technologies serveurs

Pour le développement de la partie serveur je me base sur l'IDE (Integrated Development Environment - Environnement
de développement intégré) NetBeans 6.1. J'utilise les EJB 3.0 ainsi que le serveur Glassfish 2+ pour le déploiement
de mon application serveur. Mon serveur de base de donnée est un MySQL 5+. Les EJB permettent, en gros et pour
faire simple, de réaliser la persistence de mes données, c'est à dire d'enregistrer mes données à conserver dans la
base de données de manière trensparente. Pour être clair, je n'ai pas à me soucier comment se passe le passage des
données dans mon code vers la base de données (c'est la théorie, en pratique faut quand même se méfier :laughing:).

J'utilise toute une flopée de technologies annexes pour réaliser la communication entre le terminal mobile et le
serveur de jeu. Je me base sur le protocole HTTP pour les communications et j'implémente mon propre protocole
applicatif sur le protocole HTTP. Il faut comprendre que c'est le plus facile et que souvent les téléphones mobiles
ne permettent pas d'autres communications sans complication.

Ça sera tout pour cette fois. Je crois qu'il y a deja pas mal à ingurgiter, mais ça vous donne une bonne idée de ce
que je suis en train de faire actuellement, et pas seulement mes petits plats :wink:
