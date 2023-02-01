---
layout:     post
title:      iHTML, iXHTML tout pareil ... très limité
date:       2008-08-31 16:10:47 +0200
categories: ["Projet"]
---

Comme je le disais dans mon sujet précédent, j'ai passé ma journée à faire des essais et recherches pour mon
projet. J'ai exploré la voie que je préconise actuellement c'est à dire une application web avec des modules iAppli
exploitable depuis l'application web.

<!--more-->

Toutefois, parce qu'à présent j'ai retenu la leçon, tout ne se passe jamais totalement comme prévu. Donc à présent,
plus rien ne me surprend.

Faisons d'abord un petit résumé de ce que j'ai à disposition pour faire mon application web. Ca se résume très
simplement à deux termes techniques iHTML (des balises) et iXHTML. Tous deux sont des langages basés respectivement sur 
le HTML et XHTML mais à la sauce NTT Docomo (sont pénibles eux franchement :laughing:). C'est à dire que ça reprend des 
sous ensembles des deux langages mais en version super modèle réduit.

#### Points communs:

- Pas de JavaScript ou autre chose du genre
- Pas de support de CSS en référence externe
- Jeu minimal de balises
- Balises spécifiques pour certaines fonctionnalités (Infrarouge, profil, ...)

#### iHTML:

- Attributs supplémentaires propriétaire (ilet, ijam, ista, lcs, ...)
- Définition des styles par attributs des balises (background, bgcolor, alink, ...)
- Attribut istyle pour les balises input (sert à définir quel genre d'input (kana, alpha, numérique)
- Pas de CSS inline
- Version actuelle 7.0/7.1 (seule la prise en charge de Flash Lite 3.0 diffère entre les deux versions)

#### iXHTM:

- Attribut style disponible pour certaines balises (body, ...)
- CSS inline à travers les attributs style des balises
- CSS possible dans la balise head mais limitée à certaines classes/sous-classes
- Attribut istyle non disponible
- Version actuelle 2.1/2.2 (même différence que pour l'iHTML entre les deux versions)

Il y a certainement encore d'autres différences notables à signaler mais je ne les ai pas encore répertoriées, et
je ne me réjouis pas forcément de les découvrir actuellement. Il faut comprendre également que les deux langages
semblent incompatibles entre eux. C'est à dire qu'il me faudra faire un choix entre les deux, et pour le moment il
me semble que je penche pour le iXHTML pour sa possibilité d'utiliser les attributs styles.

Au final, une interface web, qu'elle soit avec l'une ou l'autre des deux technologies sera très limitée et
demandera que beaucoup de processing soit fait du côté du serveur. Ce qui sous-entend également un nombre
d'échanges de paquets potentiellement conséquents et donc des coûts supplémentaires pour l'utilisateur bien que je
ne sois pas actuellement en mesure de chiffrer les coûts. Tout dépend surtout de la formule d'abonnement de
l'usager. Par exemple, je dispose d'un forfait illimité en termes de paquets. Il faut savoir que le coût ici ne se
calcule pas au KByte comme chez nous mais au paquet, et un paquet fait 128 Bytes. Au final, c'est plus ou moins la
même chose.

Si je pars sur cette idée d'interface web c'est que l'attribut "lcs" associé à une balise &lt;A HREF...&gt; ou
&lt;FORM&gt; me permet de récupérer la localisation du joueur. Ce qui ne m'est pas possible dans l'iAppli sauf en
ayant un TrustedAPID ce que je ne suis toujours pas en mesure de savoir comment obtenir, et d'après le professeur
Liechti, ça risque d'être une procédure longue et difficile sans garantie de succès. Par la force des choses, c'est
la solution la moins mauvaise mais elle est loin d'être parfaite.

Le plus gros problème que je vois actuellement, c'est l'affichage de la carte avec les informations dessus. Car vu
les limitations du langage je vais avoir des soucis pour superposer des images sur mon interface web. Il va donc
falloir trouver une solution. Après, il y aura encore le problème de l'utilisation comme le zoom ou le déplacement.
Sûrement que dans un premier temps ces fonctionnalités seront laissées de côté. Et pour finir, je n'ai pas moyen,
depuis une iAppli, de revenir sur le navigateur en changeant de page internet. Ce qui signifie pour l'utilisateur
des manipulations supplémentaires. C'est pas très pratique mais pas trop le choix (sauf si je finis par trouver une
info pour faire ce que j'ai dit avant, mais j'en doute).

Je finis par dire, qu'après avoir lu un document résumant les spécifications de tous les modèles de téléphones
portables de NTT Docomo de ces 2 ou 3 dernières années (sûrement plus en fait) j'ai réussi à voir qu'en prenant la
version iHTML 7.0 et/ou iXHTML 2.1, je touche un ensemble de 80 modèles environ sur le double dans le document
regardé. C'est un bon score. Malheureusement, et oui c'est encore un problème, pour avoir l'attribut "lcs", il me
faut ces versions. En dessous de celle-ci impossible de l'avoir, donc je n'ai encore une fois pas le choix.

Au départ, nous croyions avec mon professeur en Suisse que le Japon était vraiment en avance sur les technologies
de téléphonie mobile, ce qui est vrai. Toutefois, tout est tellement bridé qu'il faut être une grosse société pour
pouvoir aisément obtenir des arrangements avec les opérateurs pour diffuser du contenu de confiance et vérifié par
eux. C'est vraiment un frein dans le développement et l'expériementation de nouvelles choses.