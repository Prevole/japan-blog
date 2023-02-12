---
layout:     post
title:      Deuxième démo
date:       2008-11-13 08:38:16 +0100
categories: ["Projet"]
image:      /assets/media/posts/2008-11-13-deuxieme-demo/thumb_demo_2.png
---

Ça fait une bonne dizaine de jours que je n'ai plus rien écrit sur mon blog et pour cause. C'est très simple, ces
temps ainsi que les prochains, vont être rudement occupés. Pour que vous puissiez comprendre, sachez qu'il ne me
reste que quatre semaines au maximum pour terminer mon travail de diplôme (documentation comprise). Je vous laisse
imaginer le stress qui commence à pointer le bout de son nez. Je fais le maximum pour avancer le plus loin
possible, et je dois dire que le résultat ne s'annonce pas trop mal du tout.

<!--more-->

Depuis la première démo, j'ai eu le temps d'ajouter pas mal de choses, mais il faut également souligner que j'ai dû
refaire quelques "petites" choses en arrière-plan (ce que personne ne voit mais que tout le monde est content que
ça existe :laughing:). Il faut également ajouter, que j'ai patiemment attendu que la plateforme de localisation
soit corrigée au fur et à mesure de mes découvertes.

A ce propos, vous comprendrez que je travaille depuis la maison malgré mon nouvel ordi fonctionnel, pour pouvoir
être en communication le plus possible avec David - assistant à l'IICT. David est responsable du développement de
la plateforme, et il est mon correspondant en Suisse pour cette partie. Autant dire que ces deux dernières
semaines, nous avons travaillé en parallèle quasiment tous les jours et ce malgré les nombreux labos de
&lt;censure&gt; :laughing: Un grand merci à lui pour sa disponibilité, sa patience et sa geektitude :smiling_imp:

Dans la démo qui va suivre, il ne faut pas faire très attention aux erreurs de contenu (mais j'apprécie tout de
même qu'on me les signale :laughing:), car c'est du contenu de test. La difficulté étant de repérer ce qui est
test et ce qui ne l'est pas (titres, liens, ...). Au niveau des fonctionnalités nouvelles, il m'est difficile d'en
faire une liste par rapport à la première démo. Je ne vais pas prendre le temps de faire la comparaison. Toutefois,
je peux garantir que l'inventaire, l'affichage de la map (liste de données plutôt) ainsi que la partie de
messagerie (notifications serait plus correct) sont totalement neufs (ainsi que les fonctionnalités sous-jacentes).
Il faut noter également la présence de nouveaux types de dialogues. Certaines modifications ont aussi eu lieu dans
la partie quête.

Au stade actuel, j'arrive à un produit quasiment utilisable. Il me manque encore les méthodes pour savoir les
entités se trouvant proche de moi. Pour le moment, il ne s'agit que de méthodes de simulations. Cela veut dire que
lorsque j'affiche la map, c'est toutes les données que j'affiche. Lorsque j'affiche la liste des joueurs pour le
choix lors d'un don d'un objet à un autre joueur, la liste est également simulée (tous les joueurs du jeu, sauf
soi-même). Ainsi, il me sera facile de remplacer les méthodes d'obtention des données car tout est déjà prêt, ce
n'est que la recherche des données qui va différer. Si tout se passe bien, dès que David aura fait la méthode qui
m'est nécessaire, il me faudra une petite demi-heure pour mettre en place tout ça (je suis optimiste hein ?
:laughing:).

En ce qui concerne la partie technique de l'application, le design applicatif n'a pas fortement bougé. Depuis le
mois de septembre, je suis dans un état architectural satisfaisant et opérationnel. De temps en temps j'ajoute ou
je modifie quelques détails mais dans l'ensemble, c'est stable. Il y a juste la partie du chargement des données
initiales qui a subi une grande refonte. J'avais un problème qui était pas dérangeant jusqu'à ce que j'ajoute les
nouveaux dialogues.

Lorsque je chargeais mes données, il fallait absolument qu'une donnée référencée par une autre soit existante pour
pouvoir être chargée correctement. Tout va bien si l'on est rigoureux et que l'on fait les choses dans le bon
ordre. Mais que se passe-t-il si une donnée référence une autre et que cette autre donnée référence la première ?
On appelle ça une référence cyclique. En général, ce n'est pas très bon ce genre de chose parce que ça peut causer
quelques problèmes. Toutefois, ce n'est vraiment pas une règle absolue. Il est souvent nécessaire d'avoir ce genre
de références qui, quand elles sont bien gérées, ne posent pas de problème.

Dans mon cas, il n'était pas possible d'avoir de tel références, vu qu'il fallait que la donnée référencée existe
déjà. C'est à dire, qu'elle soit déjà présente dans la base de données. Mais comme je pouvais pas la charger, parce
qu'elle demandait une donnée non existante, je me retrouve avec un paradoxe assez embêtant. Ce simple problème m'a
obligé à revoir intégralement la façon de gérer le chargement des données.

Auparavant, le chargement s'effectuait en un passage et le tour était joué. A présent, il faut trois passages pour
que les données soient correctement chargées. Le premier passage a pour but de charger et valider les fichiers de
données. Le second passage a pour objectif de créer INDÉPENDAMMENT les données (j'insiste sur le terme). Ça
signifie que chaque donnée est chargée dans la base de données, mais qu'aucune référence n'est encore mise en
place. Le dernier passage permet de construire les références entre les données chargées. Ainsi, comme les données
existent à présent dans la base de données, il est possible des les référencer.

Cette nouvelle façon de charger les données est bien plus délicate que la précédente, mais permet un chargement des
données dans n'importe quel ordre, que ce soit par rapport au type de données ou à l'ordre des données pour un type
donné. Ce changement était réellement nécessaire et salutaire pour mon projet. Je pense qu'il reste encore plein de
détails à améliorer dans cette partie, mais elle fait son travail et c'est ce qui est important.

Il est difficile pour les non initiés de comprendre ce que représente le boulot d'un développeur. Alors pour vous
faire une petite idée, je vous laisse découvrir la statistique suivante. Mon projet contient environ 310 sources
compilables. C'est à dire 310 fichiers qui vont être transformés de texte à du code machine exécutable (c'est pas
tout à fait vrai mais je veux pas entrer dans les détails). A raison de 50 lignes de code en moyenne par fichier,
je vous laisse faire le calcul pour le nombre total de lignes de code du projet.

Trêve de blabla et de chiffres. A présent, je vous laisse découvrir la nouvelle démonstration. Désolé pour la
qualité (que je trouve assez potable en fait) et de l'absence du curseur. Il faut savoir qu'avec mon nouvel ordi,
je fais tourner un Windows XP dans une machine virtuelle, et que par conséquent, quelques petits soucis existent,
comme l'absence de curseur quand je fais une capture vidéo. Le début de la vidéo est un peu lent, le temps de
trouver les boutons. C'est plus difficile quand on ne voit pas son curseur :laughing:

{%- media_cartridge -%}
{% include media.html
    media="demo_2.mp4"
    title="Seconde demo"
    gallery="video"
    show_legend="yes"
%}
{%- endmedia_cartridge -%}
