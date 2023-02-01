---
layout:     post
title:      Choisir un téléphone portable
date:       2008-07-30 15:25:12 +0200
categories: ["Projet"]
---

En dehors de mes petites expériences je me dois de vous dire que je travaille. Oui, oui c'est vrai. Actuellement,
une de mes tâches est de choisir un téléphone portable pour mon projet. Je vais devoir développer la partie cliente
de mon projet dessus.

<!--more-->

On pourrait se dire, que de choisir un téléphone n'est pas très compliqué. C'est ce que je croyais en venant ici.
Je peux vous dire, que depuis quelques jours, je commence à prendre la mesure de la tâche, qu'est de choisir un
téléphone portable.

Avant toute chose, je vais vous poser les premiers critères de choix qui sont retenus. Après quoi, j'exposerai ceux
qui sont abandonnés et pour finir, les difficultés supplémentaires inhérentes à l'eco-système présent au Japon en
ce qui concerne la téléphonie mobile.

# Principaux critères

#### GPS - Global Positionning System

Le téléphone portable de mon choix doit proposer un GPS embarqué. Pas question d'avoir un GPS à côté pour des raisons 
de facilités d'utilisation pour les utilisateurs. Et comme mon jeu se base essentiellement sur la géo-localisation, il 
est impératif de disposer d'un GPS. Ce critère de choix n'est pas du tout négociable.Heureusement pour moi, les 
japonais commencent à avoir de plus en plus de téléphones équipés de GPS. 

#### Bluetooth - Technologie de communication à courte distance.

Le Bluetooth dans le cadre de mon projet me permet de détecter des joueurs à proximité (rayon de 10m environ). C'est 
une fonctionnalité intéressante pour forcer les joueurs à être proches les uns des autres pour ajouter de 
l'interactivité. Malheureusement pour moi, le Bluetooth n'est pas très répandu ici.

#### TouchScreen - Ecran tactile

Il s'agit d'un plus indéniable pour une interface de jeu. L'utilisation d'un écran tactile, si je prends l'exemple
de l'iPhone, rend une application bien plus facile à la prise en main et l'utilisation. Une fois encore, les écrans 
tactiles ne sont pas très répandus ici. 

#### Java

Prise en charge du langage de programmation Java. C'est le langage que je vais utiliser car c'est celui que je connais 
et maitrise le mieux. Ici encore, il y a une difficulté. Le Java est bel et bien présent un peu partout sur les divers 
types de téléphones, mais souvent avec quelques restrictions.

# Faune locale

#### NTT Docomo

NTT Docomo est le plus présent des opérateurs de téléphonie mobile au Japon. Le problème c'est qu'ils utilisent leur 
propre plateforme Java sous le nom de Doja. Je ne vais pas entrer dans les détails, mais en gros il s'agit pour moi 
d'apprendre les différences entre les deux plateformes (pas énormes à ce qu'il paraît) et ensuite d'être absolument 
bloqué uniquement pour cet opérateur.

#### Softbank

Softbank connu anciennement sous le nom de Vodafone et encore avant de J-Phone est un autre opérateur important au 
Japon. C'est cet opérateur qui a le monopole de la distribution de l'iPhone ici. Une fois de plus, Java est bien 
supporté mais cette fois, ils ont quelques petits trucs en plus propriétaire pour pouvoir accéder au matériel du 
téléphone. Ainsi, j'en reviens à me cantonner à cet opérateur uniquement si je ne fais pas attention. Toutefois, les 
fonctionnalités de base permettent une compatibilité relative avec AU by KDDI.

#### AU by KDDI

Il s'agit d'un des trois opérateurs importants (avec Softbank et NTT Docomo) Je ne sais guère plus sur cet opérateur. 
Côté Java c'est la même politique que Softbank. C'est à dire une base standard et plus ou moins compatabile avec les 
autres (sauf NTT Docomo) et une partie propriétaire pour attaquer le matériel.

# Critères abandonnés

Durant les phases de réflexion, il a fallu faire des choix. Un moment donné il a été envisagé (c'est toujours plus
ou moins le cas) de prendre l'iPhone mais il ne supporte pas du Java. Du coup celà engendrerait des complications 
supplémentaires.

Parmi les choix effectués, le TouchScreen et le Bluetooth ont été mis de côté pour des raisons de disponibilité dans 
le par déjà présent chez les utilisateurs. Mon professeur local propose de faire tester mon projet par ces étudiants en
septembre et par conséquent pas tous auront à disposition le Bluetooth et le TouchScreen. Pour toucher le plus de monde 
possible il faut faire cette concession.

Pour le TouchScreen, il n'est vraiment pas indispensable. C'était juste une question de préférence et de
"userfriendly" pour l'interface. Pour le Bluetooth, il est possible de simuler les fonctionnalités prévues directement 
sur la partie serveur de mon application. Au final, ces deux éléments ne sont pas indispensables mais seraient un plus. 
Gérer un mixe des deux ne serait pas viable dans le temps à disposition pour le projet.

# Synthèse

Comme vous pouvez le constater, ce n'est clairement pas facile de faire un choix. J'en suis encore dans une phase
de recherche et documentation. Ce n'est pas du tout facile de trouver de la documentation suivant l'opérateur, car
parfois seule la documentation en japonais est disponible, et je ne suis clairement pas capable d'en lire un mot 
:laughing:

Il me faut donc actuellement analyser quel opérateur me permettrait de développer en Java de manière relativement
facile et surtout qui permettrait un portage vers un autre opérateur sans trop de travail. Dans tous les cas, ça
ajoute du piment pas prévu à mon projet et va m'obliger de vraiment, mais alors vraiment bien penser la partie
client, pour à la fois utiliser les possibilités propriétaire sans pour autant contraindre mon application à un
opérateur particulier. Je ne vais pas entrer plus dans les détails pour le moment.
