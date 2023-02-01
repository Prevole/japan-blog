---
layout:     post
title:      Les affaires reprennent
date:       2008-08-29 16:15:38 +0200
categories: ["Projet"]
---

Aujourd'hui a été consacré à une journée de prospection, de prototypage, d'essais, de recherche. En bref, un peu de
tout et n'importe quoi pour voir ce que je peux arriver à faire avec les moyens du bord.

<!--more-->

Suite à mon problème de localisation et mes discussions avec mes professeurs, nous nous sommes mis à la recherche
d'une solution la meilleure possible, sachant pertinemment qu'elle contiendrait des inconvénients. Et oui, du
moment qu'il y a des limitations, une solution pour les contourner n'est pas parfaite.

J'ai donc entrepris, depuis hier, des recherches approfondies sur les diverses possibilités. Mon professeur local
m'a donné un coup de main en effectuant des recherches sur les sites en japonais.

Pour revenir à aujourd'hui, je suis parti sur le principe de changer totalement la partie cliente. De toute
manière, je n'ai pas le choix de ce point de vue là. Donc au lieu d'avoir un client lourd écrit en DoJa, je pars
sur le principe d'une application web dédiée à l'iMode de NTT Docomo. Ceci me permet d'obtenir la localisation des
joueurs par l'intermédiaire de quelques manipulations dévolues à ceux-ci. Ma foi, on a rien sans rien.

Par contre, la partie intéressante de l'affaire, c'est comment rendre intéressante la partie des quêtes si
l'application web ne peut être que du iHTML (version simplifiée d'HTML pour iMode) qui ne permet pas de scripting
côté client. L'idée est dès lors d'utiliser depuis les pages web des petites iAppli (pour rappel, il s'agit des
applications DoJa pour NTT Docomo) et de retourner après sur la page web.

Actuellement, je suis arrivé au résultat qui me permet de lancer une application comme je l'ai dit mais également
de voir si celle-ci existe deja sur le téléphone du joueur. Si c'est le cas, de voir si elle est à jour et au final
de pouvoir l'exécuter dans la version souhaitée après un téléchargement si nécessaire. Après avoir utilisé
l'application, le joueur revient sur la page qui a permis le lancement de l'application.

Ma prochaine prospection et expérimentation consistera à tenter de passer des paramètres depuis la page web vers
l'iAppli. Je sais que c'est possible mais je n'ai pas encore testé ce point. Dans tous les cas, ça promet de belles
petites choses intéressantes. Bien entendu, mon projet est en train de prendre une direction différente de ce qui
était prévu à la base, et le game play sera remanié en conséquence. Certaines fonctionnalités ne seront tout
bonnement pas possibles à faire en l'état actuel des choses. Le but qui est à présent fixé, est d'arriver à rendre
le jeu intéressant et amusant dans un temps d'utilisation relativement réduit.

Je dois également regarder s'il est possible, lorsque je reviens sous le navigateur depuis une iAppli terminée, de
changer de page automatiquement ou si je suis obligé de requérir l'aide de l'utilisateur. Je pense que
malheureusement la seconde solution sera applicable. Encore une fois, on fait avec ce qu'on peut.

Au final, mon application cliente sera un mixe entre un client web et des morceaux d'application de type client
lourd. Le mixe entre les deux peut permettre quelques interactivités intéressantes.