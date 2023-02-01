---
layout:     post
title:      Avancement du projet
date:       2008-08-14 13:57:24 +0200
categories: ["Projet"]
---

Je sais que pour le moment je n'ai rien de concret à montrer pour mon projet, pour la simple et bonne raison que je
n'ai pas encore de téléphone pour développer concrètement la partie cliente. Ceci dit, il ne faut pas croire que je
me tourne les pouces. Malgré quelques déboires de début de projet (apprentissage de technologie, reflexion et choix
sur comment faire quoi, ...) j'avance.

<!--more-->

Aujourd'hui, je me suis attaqué à une partie importante qui est la gestion des dialogues. Je reprends un petit
exemple tout bête. Nous avons notre joueur Bob qui se promène dans la ville de Kyoto et qui tout à coup rencontre
Alice la NPC (Non Player Character - Personnage Non Joueur), tâchez de vous en souvenir, je ne vais pas le remettre
à chaque fois :laughing:). Bob est content de rencontrer un NPC, car celui-ci pourrait lui donner des informations ou
alors simplement lui dire des banalités ou encore mieux, lui décrire des faits historiques sur un bâtiment se
trouvant derrière lui.

Dans tous les cas, il faut pouvoir gérer ce dialogue et pouvoir permettre une interaction dans la succession des
dialogues, voir même permettre à Bob de répondre à des questions qu'Alice lui poserait. Ainsi, on se retrouve avec
un nombre de fonctionnalités assez grand juste pour la partie des dialogues. Il m'a fallu quelques heures de
réflexion pour parvenir à un résultat satisfaisant. Ce n'est peut être pas le meilleur et sûrement qu'il y aurait
matière à améliorations, mais il faut bien avoir un résultat au bout d'un moment.

L'idée est de gérer le flux du dialogue comme un arbre. C'est à dire que l'on part d'un dialogue de base qui
représente la racine du dialogue et petit à petit on parcourt les branches pour obtenir la suite du dialogue. Dans
certains cas, des choix seront faits par le joueur et représenteront des noeuds dans mon arbre qui vont alors
augmenter les possibilités du dialogue au fil de la conversation.

Il faut savoir également, que le client (le téléphone mobile) devra à chaque fois se renseigner auprès du serveur
pour obtenir la partie du dialogue suivante (pour le moment en tout cas, par la suite, je ferais en sorte
d'améliorer les choses) car en cas de décision, la partie serveur devra être au courant.

En plus de cela, il faut pouvoir faire varier les dialogues en fonction d'événements. Par exemple, si Bob est en
train de faire une quête dans laquelle Alice intervient, il faut qu'Alice ait un dialogue approprié et non pas son
dialogue de base. Ceci bien évidemment rajoute à la complexité, car il faut ajouter une notion conditonnelle sur le
choix des dialogues. Je n'ai pas encore mis en place cette partie, mais la place est faite pour :laughing:

Une dernière notion est de pouvoir savoir l'état du dialogue. Il serait fâcheux qu'Alice remercie Bob de lui avoir
ramené son parapluie fétiche dans le cadre de la quête et qu'ainsi Bob reçoive la récompense autant de fois qu'il
le souhaite, simplement en rejouant le dialogue de la fin de la quête. Il faut dès lors, interdire de pouvoir
rejouer cette partie de dialogue, et dans ce cas de figure il est nécessaire de garder un état de conversation pour
les dialogues de ce genre. Cette partie n'est pas encore tout à fait au clair dans mon esprit, mais j'y songe
sérieusement.

A la base, je devais m'occuper de cette partie beaucoup plus tard dans l'avancement de mon projet, mais j'en ai
besoin pour réaliser la première phase du projet, qui est de proposer une première quête très simple à un joueur
(genre : Va discuter avec Alice qui se trouve à Kinkakuji temple). Donc il me faut les quêtes et les dialogues pour
ce faire. Mais il me faut également la carte pour la visualisation. Dans tous les cas, il me reste encore bien à
faire sur cette partie.