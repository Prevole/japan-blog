---
layout:     post
title:      Les affaires reprenent pour le projet
date:       2008-10-16 06:32:42 +0200
categories: ["Projet"]
---

Quelques mots sur le projet pour vous faire part d'une grande percée. Cette percée est avant tout psychologique
qu'autre chose, mais c'est très important pour le moral.

<!--more-->

Depuis deux semaines, je tente de mettre en place avec David - un assistant à l'IICT, institut dans lequel je fais
mon Travail de Diplôme - inTrack directement intégré à une partie de mon projet. Ça ne s'est vraiment pas fait sans
douleurs. D'une part il faut faire avec mes bugs et d'autre part il faut faire avec les bugs d'inTrack. De plus, il
faut faire face à des situations qui n'ont pas été envisagées. C'est d'ailleurs tout le but de la manœuvre.

Une partie de mon projet est de montrer un cas concret d'utilisation de ladite plateforme. Pour l'instant ce n'est
pas encore une réussite, mais faut pas non plus dramatiser. Il y a quand même pas mal de difficultés qui sont dues:

- Décalage horaire
- Disponibilité des gens
- Contraintes techniques
- Souhaits d'implémentation
- et la liste est encore longue

Nous arrivons tout de même à trouver de longs moments avec David pour travailler en parallèle sur mon projet et
inTrack. Merci à lui pour ses efforts, sa disponibilité (quand il est là :wink:) et ses nombreux coups de main. Il
a pu m'apporter pas mal de support pour cette mise en œuvre.

Ceci dit, s'était sans compter un certain problème très, mais alors je dis TRES subtile. Je vais tenter d'expliquer
la situation pour vous illustrer le problème et sa résolution (il aura fallu presque deux semaines pour y arriver
d'ailleurs).

Dans le cas normal, le flux de navigation de mon application se déroule de la sorte:

1. Arrivée sur l'écran d'accueil
2. L'utilisateur s'enregistre (phase 1: pseudo, mot de passe et confirmation)
3. L'utilisateur s'enregistre (phase 2: choix de l'avatar)
4. L'utilisateur s'enregistre (phase 3: message de fin d'inscription)
5. Retour sur l'écran d'accueil
6. Connexion (phase 1: pseudo et mot de passe)
7. Connexion (phase 2: comme c'est la première connexion, l'utilisateur voit le dialogue d'introduction au jeu)
8. Suite du déroulement du jeu...

Ce comportement applicatif est collé aux cas d'utilisation et les respecte très bien. Tout fonctionne très bien, et
j'ai pu tester ça des dizaines et des dizaines de fois.

Mais voilà que les ennuis commencent. Pour mettre en œuvre inTrack dans mon projet, je dois faire hériter ma classe
KmepEntity (représente une entité du jeu. Un joueur, un personnage non-joueur…) de la classe MobileEntityMBO
(classe représentant une entité mobile pour inTrack). Pour faire simple, je dois ajouter un bout de code "extends
MobileEntityMBO" entre "public class KmepEntity" et "{" dans ma classe KmepEntity. On va dire que cette
modification prend au bas mot 10 secondes :wink: J'exagère la façon de parler pour simplement dire que si tout
allait bien, le simple fait de faire ça, suffirait pour la mise en œuvre de inTrack pour localiser mes KmepEntités.
Du moins, c'est ce que l'on pensait avec David.

Il est vrai que du point de vue inTrack, c'est fonctionnel et c'est parfait. Mais de mon point de vue c'est loin
d'être le cas. Le déroulement normal que j'ai décrit plus haut devient le suivant:

1. Arrivée sur l'écran d'accueil
2. L'utilisateur s'enregistre (phase 1: pseudo, mot de passe et confirmation)
3. L'utilisateur s'enregistre (phase 2: choix de l'avatar)
4. L'utilisateur s'enregistre (phase 3: message de fin d'inscription)
5. Retour sur l'écran d'accueil
6. Connexion (phase 1: pseudo et mot de passe)
7. Connexion (phase 2: comme c'est la première connexion, l'utilisateur DEVRAIT VOIR le dialogue d'introduction au jeu 
   mais voit une boite de dialogue lui signifiant qu'il doit se connecter. Pourtant c'est ce qu'il vient de faire !!!)

Dans les logs (journaux d'évènements, traces applicatives, ...) aucune trace. Rien ! Nada ! Que dalle ! Tout se
passe normalement. Ce qui est fondamentalement très embêtant. Commence alors la traque au bug mais rien n'y fait.
Le code semble correct et il l'est !

Je me suis dit: "Je sais plus faire d'héritage et y a quelque chose de pas net !". J'ai enlevé l'héritage.
Recommencé mes tests et là ça marche de nouveau. Alors hop, on remet l'héritage en place et à nouveau le
comportement n'est pas celui attendu. Incompréhensible. Juste incompréhensible.

Commence alors une mise en place systématique de "System.out.println("blablabla");", en gros, un bout de code pour
imprimer du texte à l'écran. Avec ça, et avec l'aide de David, on repère une anomalie au niveau de la Map contenant
l'association Clé/Valeur &lt;String, AbstractBehaviour&gt;. Il s'agit d'associer un nom à un comportement. Il faut
savoir que mes KmepEntités disposent de différents comportements stockés dans cette forme où un comportement est
associé à un nom. Ceci permet de facilement faire une recherche d'un de ces comportements lorsque j'en ai besoin.
Pour revenir à l'anomalie, en imprimant à l'écran le contenu des clés de cette Map, nous nous sommes rendus compte,
qu'il s'agissait de valeurs de type Long, et non pas de valeurs de type String. Pourquoi ça ? A ce moment précis,
nous n'en avions pas la moindre idée. C'est aussi à ce moment là, que David ne pouvait faire autrement que de
corriger des laboratoires et qu'il a dû me laisser me débrouiller.

J'ai continué à chercher en ajoutant des traces de partout et en tentant de chercher sur le net des infos, mais
j'ai rien trouvé. Difficile de trouver un problème, quand on a pas le nom du problème :wink: J'ai continué à
chercher des heures durant, hier après-midi à tenter de modifier mon code pour voir ce qui se passait. J'étais
proche d'abandonner pour la journée, lorsque tout à coup, une idée saugrenue est née dans mon esprit.

Je suis aller voir mon code de la KmepEntité et j'ai réalisé que j'ai mis des annotations sur l'attribut
behaviours. Jusque là rien de surprenant, mais si je suis allé voir ça (surtout que durant tout l'après midi
j'avais déjà vu et revu ce bout de code et modifé également) c'est que je me suis souvenu que la technologie EJB
utilise des annotations. Pour fonctionner, ces annotations peuvent être placées soit avant les attributs d'une
classe, soit avant ses accesseurs. A ce moment là, je ne me souvenais pas encore de la subtilité de la chose. Je me
suis simplement dit: "Et si je déplaçais mon annotation de l'attribut vers l'accesseur ?" En me disant ça, je me
suis également dit: "Nan, c'est pas possible que ce soit un truc aussi bête !".

J'ai toutefois fait cette modification et j'ai fait mes tests. Et là, ça fonctionnait !!! Après tout ce temps passé
sur ce problème, j'ai fini par trouver la cause. J'ai alors réfléchi et me suis souvenu que les EJB autorisent les
deux types d'annotations que j'ai décrit, mais n'en prennent qu'une en compte et prennent la première rencontrée.
J'ai alors demandé à David quelle méthode d'annotation était utilisé dans inTrack et il m'a confirmé mes soupçons.
Il s'agissait bien de la méthode sur les accesseurs. Fallait vraiment s'en souvenir de celle là !

Ok, le problème est résolu mais ça me plait pas. Pourquoi ça ? Parce que les accesseurs sont publics et qu'ils
offrent un accès direct sur les "behaviours" que j'avais SOIGNEUSEMENT évité jusqu'à présent, pour des raisons
évidentes. C'est un point crucial de mon application, et j'ai mis en œuvre d'autres méthodes que de simples
accesseurs pour pouvoir faire du contrôle sur les données. Je ne souhaitais pas offrir une prise en direct pour
éviter tout risque de perte d'intégrité dans la gestion de mes "behaviours" pour une KmepEntité.

Je ne pouvais pas demander à David de modifier inTrack pour changer les annotations et je ne veux pas modifier les
miennes. Je trouve nettement plus lisible de les avoir auprès des attributs regroupés dans le début de la classe,
que dispersées au travers des accesseurs. Du coup, pour cette classe KmepEntity, je suis obligé de faire une
exception à ma règle. Admettons, mais alors j'ai encore le problème de la visibilité des accesseurs parce que je ne
veux pas qu'ils soient publics. Je pensais qu'ils n'était pas possible de les mettre privés à cause des EJB, mais
non c'est possible. Alors pour finir, j'ai des accesseurs qui ne servent à rien, qui sont privés mais qui
permettent de faire fonctionner la classe normalement et ainsi toute mon application. C'est un moindre mal en
définitive.

Avec tout ceci, je vais enfin pouvoir me remettre à l'oeuvre sur les points importants de mon projet. Il faudrait
bien que je puisse enfin avoir quelque chose pour jouer non :laughing: