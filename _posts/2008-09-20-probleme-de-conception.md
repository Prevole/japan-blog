---
layout:     post
title:      Problème de conception
date:       2008-09-20 16:56:41 +0200
categories: ["Projet"]
---

Et voici un nouvel article qui, à mon avis, est encore plus technique que le précédent. Je vais tenter de le rendre
accessible à tous, mais je vous garantis rien parce qu'on va parler de concept de programmation objet.

<!--more-->

Tout d'abord, laissez moi vous exposer quelques termes techniques pour poser le décor:

#### Classe

Une classe est une sorte de moule qui nous permet d'obtenir des objets possédant les différents attributs de ladite
classe, mais de manière indépendante des autres objets de la même classe. Prenons un petit exemple, tout le monde
(ou presque) sait que je suis fan de Légo alors je trouve que c'est un bon domaine pour faire des exemples.

Dans le monde des Légo, nous disposons d'un tas de pièces différentes, des briques, des barres, des plaques, etc...
L'idée c'est de se dire que je crée une classe Piece avec quelques attributs comme la couleur et le poids par
exemple. Bien entendu, quand je vais vouloir créer mes différentes pièces, chacune de celles-ci aura ces propres
attributs couleur et poids. Ca ne serait pas très pratique, que toutes les pièces soient de même poids et de même
couleur si le but est justement de les différencier. En java, ça donnerait le code suivant:

```java
public class Piece {
  private Color couleur;
  private int poids;

  public Piece(Color couleur, int poids) {
    this.couleur = couleur;
    this.poids = poids;
  }

  ... // Code supplémentaire
}
```

Pour faire simple, il s'agit de la définiton de notre classe qui va nous permettre d'instancier nos objets. Chacun
de nos objets aura son propre poids et sa propre couleur. Pour instancier (le fait de construire un objet) une
pièce, nous écrirons le code suivant:

```java
Piece maPiece = new Piece(maCouleur, monPoids);
```

Dans ce contexte, maPiece représente mon objet de classe (on peut voir ça comme un type) Piece et maCouleur et mon
Poids sont des variables préalablement définies, permettant la création de notre objet de type pièce. Si je veux
créer d'autres pièces, je procéderais de la même façon que ci-dessus. Je vous fais grâce des détails de syntaxe,
code et autres joyeusetés.

L'idée à retenir, c'est qu'une fois définie nos classes, nous pouvons manipuler des objets ayant les différents
attributs et méthodes de manière indépendante les uns des autres.

#### Attribut

Un attribut peut être vu comme une variable. Ce n'est rien d'autre qu'un champ de données qui caractérise un objet.
Cela permet de stocker des données de différents types. Un attribut peut très bien être d'un type d'une classe
comme l'exemple ci-dessous le montre. En effet, l'attribut suivant déclare un attribut de type tableau de pièce
Piece dans une classe CollectionLego.

```java
public class CollectionLego {
  private Piece[] pieces;
  
  ... // Code supplémentaire
}
```

#### Méthode

Une méthode peut être vue comme une fonction. Elle permet d'effectuer une action basée sur l'objet, sur lequel on
appelle la méthode. Par exemple, nous avons deux collections de pièces différentes comme ci-dessous, et nous
voulons afficher le contenu de chacune de celles-ci. Le code ci-dessous va permettre de faire cela.

```java
CollectionLego c1 = new Collection(...);
CollectionLego c2 = new Collection(...);

c1.show();
c2.show();

// Voici la méthode show
public void show() {
  System.out.println("Collection :");
  for (Piece maPiece : pieces) {
    System.out.println(maPiece);
  }
}
```

Sans entrer trop dans les détails, imaginez que la méthode show se trouve dans la classe CollectionLego. Ainsi,
lorsque je l'appelerai sur mes objets de classe CollectionLego, la liste des pièces apparaitra. Mais l'appel de la
méthode show() sur l'objet c1 ne produira pas le même résultat que l'appel sur l'objet c2. C'est bien ce qui est
recherché,, vu que nous avons deux collections différentes. Pourtant le code est pareil. C'est ça la magie du monde
objet (bon dans le monde procédural, on sait faire pareil mais ça se passe pas comme ça :wink:).

#### Héritage

C'est bien joli d'avoir une classe Piece mais c'est très limitatif. Imaginez que j'ai des pièces de type brique
ronde et brique carrée. Fondamentalement, elles ne partagent que certains attributs mais en ont d'autres qui leurs
sont propre. Par exemple une brique ronde aura un diamètre ou rayon alors qu'une brique carrée aura un côté de
défini. Pourtant que ce soit l'un ou l'autre des types, les deux ont une couleur et un poids. Pour ce faire, dans
les langages objets, ils existent l'héritage. Ca permet de définir une sous-classe qui peut profiter des attributs
de sa classe parente. Ainsi, je vais définir mes deux sous-classes de la manière suivante:

```java
public class BriqueCarree extends Piece {
  private int cote;

  public BriqueCarree(Color couleur, int poids, int cote) {
    // Appel du constructeur parent, ce qui permet d'obtenir un objet
    super(couleur, poids);
    this.cote = cote;
  }
}

public class BriqueRonde extends Piece {
  private int rayon;

  public BriqueRonde(Color couleur, int poids, int rayon) {
    // Idem que pour la classe BriqueCarree
    super(couleur, poids);
    this.rayon = rayon;
  }
}
```

Nous avons à présent deux sous-classes qui nous permettent de créer des pièces de type différents mais qui
partagent des caractéristiques communes. Ainsi, le code suivant est permis:

```java
BriqueCarree bc = new BriqueCarree(maCouleur, monPoids, monCote);
BriqueRonde br = new BriqueRonde(monAutreCouleur, monAutrePoids, monRayon);

maCollection.addPiece(bc);
maCollection.addPiece(br);
```

Il faut savoir que ma classe CollectionLego dispose d'une méthode addPiece(Piece unePiece); qui permet d'ajouter
une pièce à la collection. Comme mes deux sous-classes ont comme super-classe la classe Piece, elles peuvent sans
autre être ajoutée à ma collection. C'est pratique non ? Car de ce fait, je peux stocker mes pièces indifféremment
de leur type. Mais en faisant cela, je perds la possibilité de savoir ce qu'elles sont. C'est un problème dans
certains cas mais qui est bien maigre face aux avantages que ce mécanisme peut apporter.

#### Interface

Là on arrive dans quelque chose de très abstrait. Une interface, c'est une sorte de contrat qui oblige une classe
qui implémente (c'est le terme consacré mais on ne le trouve pas dans le dictionnaire, on devrait utiliser le terme
implante en français. Ceci dit, je préfère la françisation du terme anglais) l'interface de respecter un certain
nombre de choses que l'interface propose. Prenons notre exemple de Légo (oui, oui je sais, mais faut comprendre que
c'est bien adapté :laughing:).

Imaginons que nous ayons nos différentes pièces Lego et que nous voulions les assembler. Pour ça, il faudrait être
sûr que chaque pièce Lego possède une méthode permettant l'assamblage. Définissons pour commencer notre interface.

```java
public interface Assemblable {
  public void assemble(Assemblable piece);
}
```

J'avoue que cet exemple est tordu :laughing: Tout simplement que la méthode d'assemblage prend en paramètre un
objet de type Assemblable qui n'est autre que l'interface que l'on est en train de définir. Pourquoi faire ça, tout
simplement parce que l'on veut être sûr que les pièces vont pouvoir s'emboiter les unes aux autres (Je prends que
le cas de pièces simples :wink: Pas d'exception dans mon exemple :laughing:). Donc, il est important de s'assurer
que les pièces à assembler puissent l'être.

Afin d'obliger toutes nos pièces à pouvoir s'assembler, nous allons modifier notre classe Piece pour lui ajouter le
contrat à respecter. Ainsi, notre classe se voit changer comme ci-dessous:

```java
public abstract Piece implements Assemblable {
  private Color couleur;
  private int poids;
  ... // Code supplémentaire
}
```

A présent, toutes les sous-classes devront implémenter la méthode assembler pour pouvoir être compilée. Tant que le
contrat ne sera pas respecté, alors il ne sera pas possible de compiler correctement les différentes classes. Du
fait, que la classe Piece est abstraite, elle n'a pas besoin de l'implémenter, parce qu'elle délègue ce travail à
ces sous-classes.

Le fait d'utiliser une interface, nous permet après dans le code devoir les objets de type Piece comme des objets
de type Assemblable et de les manipuler en tant que tels sans se préocuper de leur type réel. On pourrait imaginer
ajouter une nouvelle classe qui n'a rien à voir avec une pièce. Par exemple, prenons le cas des mini personnages
Lego. Ce n'est pas vraiment des pièces mais pourtant elles peuvent être emboitées avec les pièces. dans ce cas, je
définirais le code suivant.

```java
public class MiniFig implements Assemblable {
  ... // Attributs

  public void assemble(Assemblable piece) {
    ... // Boulot à faire pour l'assemblage
  }
  ... // Code supplémentaire
}
```

Cette fois, cette classe implémente directement la méthode définie dans l'interface et devient alors manipulable en
tant qu'objet de type Assemblable. Mais elle ne peut pas être manipulée en tant que Pièce car elle ne partage pas
les mêmes propriétés. Ainsi, il ne sera pas possible de stocker les minis personnages dans le même tableau que les
pièces dans la classe CollectionLego. Dans ce cas de figure nous serons obligés de modifier la classe en question
comme suit.

```java
public class CollectionLego {
  Pieces[] pieces;
  MiniFig[] minifigs;
  ... // Code supplémentaire
}
```

Nous avons à présent dans notre collection des pièces et des minis personnages. Essayons à présent d'assembler un
personnage avec une pièce. Imaginez que j'ai défini deux méthodes dans la classe CollectionLego qui sont
getFirstPiece(); et getFirstMiniFig(); qui retourne chacune respectivement le premier mini personnage et la
première pièce de la collection. Le code d'assemblage donnerait ceci.

```java
// Récupération de la pièce et du personnage
Piece maPiece = maCollection.getFirstPiece();
MiniFig maFig = maCollection.getFirstMiniFig();

// Assemblage
maPiece.assemble(maFig);
```

Ceci dit, j'aurais très bien pu écrire maFig.assemble(maPiece); mais le résultat ne serait pas le même car
l'assemblage ne se ferait pas de la même manière. Lorsque j'écris cette ligne de code (ainsi que l'autre), je ne
sais pas comment va se faire l'assemblage, je sais juste qu'il va avoir lieu. Je ne sais pas quel type de pièce,
j'ai car c'est forcément une des sous-classes définies mais laquelle, c'est un mystère à ce moment d'écriture du
code. Par contre, le fait de ne rien savoir sur la nature de ce que je manipule n'est pas un problème car tous
respectent le contrat et ainsi permettent l'assemblage.

#### Point de situation

J'espère que je ne vous ai pas trop perdu avec mes explications préliminaires :wink: N'hésitez pas à me laisser des
commentaires pour des compléments d'information ou pour me signaler des amélioration possibles. Je suis resté assez
superficiel, car c'est impossible de traiter tous les sujets dans un article aussi court. S'il existe des livres de
plus de 500 pages sur le sujet c'est qu'il y a bien une raison non ? :laughing: Je ne prétends pas apporter une
lumière divine sur le sujet, mais quelques clés de compréhension pour la suite de l'article.

### Problématique rencontrée

Durant les trois dernières semaines, j'ai été confronté à un problème de conception objet. Une bonne pratique de
programmation est le découplage entre le rendu graphique et le stockage des données. C'est ce qui m'a été donné
d'affronter.

L'idée est la suivante. J'ai mes petits NPC qui peuvent communiquer avec le joueur. Actuellement, ils ont trois
possibilités d'exposer des dialogues. Le premier est simplement du texte, le second de proposer une quête avec
acceptation ou refus par le joueur, et le dernier est le fait de poser une question avec une série de réponses
possibles par le joueur.

Jusqu'ici ça semble simple et sans problème. Mais ce n'est pas le cas. Il faut savoir que pour construire un
dialogue, j'utilise une technique dite d'arbre. C'est à dire que je pars depuis un dialogue principal et en
fonction des choix de l'utilisateur je me déplace dans mon arbre. Ainsi, une réponse à une question peut déboucher
sur plusieurs voies possibles. C'est assez simple à mettre en oeuvre mais difficile à gérer. D'une part la création
des dialogues doit être rigoureuse mais l'affichage devient compliquée.

Pour le stockage des dialogues, je dois forcément les voir d'une manière commune sans me préoccuper de leur type.
De ce fait j'ai une classe abstraite AbstractDialog qui est étendue par mes trois classes (DialogText, DialogQuest
et DialogQuestion). Ainsi, dès que je vois un AbstractDialog, je ne suis plus en mesure de savoir de quel type de
sous-classe il s'agit.

Mon problème est que pour afficher ces dialogues de nature différente, il me FAUT savoir de quel type il s'agit,
sinon je peux accéder aux caractéristiques spécifiques de chacun de mes dialogues, mais voilà comme je le disais,
je ne sais pas de quoi il s'agit au moment de leur manipulation.

Pour solutionner ce problème de conception, j'ai pensé à trois solutions différentes mais forcément aucune n'est
parfaite.

#### 1ère solution - La moins propre

En Java, il existe un opérateur nommé "instanceof". Cet opérateur permet de savoir si un objet est une instance
d'une classe. Alors avec cet opérateur je pourrais écrire ceci :

```java
// Récupère le dialogue dont on ne sait rien
AbstractDialog dialog = retrieveDialog(...); 

if (dialog instanceof DialogText) {
  // Conversion de AbstractDialog => DialogText
  DialogText dt = (DialogText)dialog;
  ... // Rendu à faire
}
else if (dialog instanceof DialogQuest) {
 // Conversion vers DialogQuest
 DialogQuest dq = (DialogQuest);
  ... // Rendu à faire
}
else if (dialog instanceof DialogQuestion) {
  // Conversion vers DialogQuestion
  DialogQuestion dqi = (DialogQuestion);
  ... // Rendu à faire
}
else {
  ... // ERREUR : Type de dialogue inconnu
}
```

Ok, pour trois ça va, mais imaginez que demain, j'ai 15 nouveaus types de dialogues à ajouter. C'est galère à gérer
parce que faut modifier ce test. C'est pas pratique. En POO (Programmation Orientée Objet) on dit que lorsqu'on
utilise un "instanceof" c'est que l'on a un problème de conception. J'ai pour principe de ne jamais utiliser cet
opérateur. Bien entendu, c'est pas une règle absolue sinon il existerait pas :laughing:

#### 2ème solution - L'acceptable

Il est possible en Java de récupérer la classe ainsi que des données sur celle-ci à partir d'un objet. Par exemple,
en écrivant dialog.getClass(); je vais retrouver la classe. Mais ce qui est pratique, c'est que je me retrouve pas
avec une classe AbstractDialog mais bien sa sous-classe. C'est ce qu'on appelle le mécanisme de liaison dynamique,
je vais pas entrer dans les détails, c'est assez simple mais ça prend du temps à expliquer.

Ainsi, grace à cette "astuce", je suis en mesure de savoir qu'un AbstractDialog est d'un type précis parmi ces
sous-classes. Je peux mettre en place un protocole qui me permet de générer le rendu graphique au moyen du nom de
la classe retrouvée. Seulement voilà, dès que je voudrais faire du renommage de classes, je serais dans les ennuis
car je devrais modifier également mon protocole. Prenons le code suivant :

```java
public interface IFormater {
  public void render(AbstractDialog dialog);
}

public class DialogTextFormater implement IFormater {
  ... // Code pour le rendu graphique
}

public class DialogText {
  ... // Code et attributs du dialog textuel
}

// Code basé sur un protocole simpliste
// Récupère le dialogue dont on ne sait rien
AbstractDialog dialog = retrieveDialog(...); 

// Retrouve la classe grâce au nom de celle-ci
Class classRetrieved = Class.forName(
    "pckName" + dialog.getClass().getSimpleName() + "Formater");

// Construit un objet de type IFormater à partir de la  Classe 
// retrouvée (ici, cette classe est la classe DialogTextFormater
IFormater formater = (IFormater)classRetrieved.newInstace();

// Applique le rendu graphique
formater.render(dialog);
```

Comme on peut le voir, cette solution peut sembler plus compliquée de demander plus de code mais en fait elle est
assez simple. Mais le défaut majeur c'est que si je décide de renommer mon DialogTextFormater en
DialogTextRenderer, ça ne marchera plus sans devoir modifier ce code. De même qu'en renommant DialogText en
DialogTextual ça ne marchera plus non plus. Donc c'est une solution relativement peut adéquate au final.

#### 3ème solution - La plus compliquée

Pour finir, la troisième et dernière solution. C'est celle que j'ai adoptée et franchement, je la trouve très
adaptée et je ne vois pas de meilleure solution pour le moment. Mais j'ai peut-être passé à côté de quelque chose.
J'ai pas encore 10 ans d'expérience en POO alors un peu d'indulgence :wink:

L'idée c'est de se dire que vu qu'on ne sait pas de quel type il s'agit, autant mettre en oeuvre un moyen d'obtenir
quelque chose dont on a pas besoin de savoir de quoi il s'agit. C'est ici qu'interviennent des notions comme les
fabriques et callbacks (oups, je vois pas comment expliquer le terme en français :laughing: , en gros, c'est de
fournir quelque chose à un objet pour que cet objet rappelle ce qui lui a été fourni (pas très clair mais ça ira
très bien)).

D'abord, je rappelle la structure de classe qui contient mes données à afficher:

```java
public abstract class AbstractDialog {
  ... // Je fais grâce des détails inutiles ici
}

public class DialogText extends AbstractDialog {
  ... // Idem
}

public class DialogQuest extends AbstractDialog {
  ... // Idem
}

public class DialogQuestion extends AbstractDialog {
  ... // Idem
}
```

Voilà, ça c'est mes classes de données. A présent, je me dis que je veux que ces classes me retournent de quoi
générer du graphisme mais sans savoir quel type de graphisme. Le but est, qu'elles en sachent le moins possible.
Alors, je vais définir deux interfaces. La première permet de créer des classes affectuant le rendu graphique et la
seconde de pouvoir construire des objets implémentant la première. Voici ce que celà donne:

```java
public interface IFormater {
  public void apply(); // Applique le rendu graphique
}

public interface IDialogFormaterFactory {
  public IFormater createDialogTextFormater(DialogText dialogText);

  public IFormater createDialogQuestFormater(DialogQuest dialogQuest);

  public IFormater createDialogQuestionFormater(DialogQuestion dialogQuestion);
}
```

Comme nous pouvons le voir, la première interface oblige la présence d'une méthode d'application (pour le rendu
graphique) et la seconde propose trois méthodes pour créer spécifiquement chaque type de formateur graphique.

A présent, nous allons créer nos classes permettant le formatage. Tout d'abord, nous allons partir du principe
qu'il y a une partie commune. Voici le code que celà donnerait:

```java
public abstract AbstractDialogFormaterImpl implements IFormater {
  ... // Code commun
}

public DialogTextFormaterImpl extends AbstractDialogFormaterImpl {
  private DialogText text;

  // Constructeur prenant un dialog text en paramètre
  public DialogTextFormaterImpl(DialogText text) {
    this.text = text;
  }

  public void apply() {
    ... // Code spécifique
  }
}

public DialogQuestFormaterImpl extends AbstractDialogFormaterImpl {
  private DialogQuest quest;

  // Constructeur prenant un dialog quest en paramètre
  public DialogQuestFormaterImpl(DialogQuest quest) {
    this.quest = quest;
  }

  public void apply() {
    ... // Code spécifique
  }
}

public DialogQuestionFormaterImpl extends AbstractDialogFormaterImpl {
  private DialogQuestion question;

  // Constructeur prenant un dialog question en paramètre
  public DialogQuestionFormaterImpl(DialogQuestion question) {
    this.question = question;
  }

  public void apply() {
    ... // Code spécifique
  }
}
```

Nos classes de rendus graphiques sont prêtes, mais pour le moment nous ne sommes toujours pas capable d'appliquer
ce rendu graphique, car nous n'avons pas encore de quoi construire des rendus graphiques. Il nous faut pour celà
implémenter l'interface IDialogFormaterFactory. Voici cette implémentation:

```java
public class DialogFormaterFactoryImpl implements IDialogFormaterFactory {
  public IFormater createDialogQuestFormater(DialogQuest quest) {
    return new DialogQuestFormaterImpl(quest);
  }

  public IFormater createDialogQuestionFormater(DialogQuestion question) {
    return new DialogQuestionFormaterImpl(question);
  }

  public IFormater createDialogTextFormater(DialogText text) {
    return new DialogTextFormaterImpl(text);
  }
}
```

Voilà, à présent nous sommes presque en mesure de créer nos rendus grpahiques, il ne nous manque plus que le moyen
d'obtenir le bon en fonction du type de dialogue. Pour ce faire, il nous faut modifier les classes Dialog pour
qu'elles puissent nous fournir le bon rendu graphique en fonction de la fabrique à fournir en paramètre. J'ai opté
pour une voie par méthode abstraite à redéfinir par les sous-classes. J'aurais pu opter pour une autre interface,
c'est un choix et je ne vois pas de justifications particulières pour le moment. Voici le code ajouté uniquement:

```java
/ Classe AbstractDialog
public abstract IFormater getFormater(IDialogFormaterFactory factory);

// Classe DialogText
public IFormater getFormater(IDialofFormaterFactory factory) {
  // Crée un rendu text avec référence sur ce dialogue
  return factory.createDialogTextFormater(this);
}

// Classe DialogQuest
public IFormater getFormater(IDialofFormaterFactory factory) {
  // Crée un rendu quest avec référence sur ce dialogue
  return factory.createDialogQuestFormater(this);
}

// Classe DialogQuestion
public IFormater getFormater(IDialofFormaterFactory factory) {
  // Crée un rendu question avec référence sur ce dialogue
  return factory.createDialogQuestionFormater(this);
}
```

Voilà, à présent nous sommes prêts pour effectuer la mise en place finale. Avec tout ce que nous avons défini
jusqu'à présent, nous pouvons enfin obtenir un rendu graphique spécifique, sans savoir ce que nous manipulons en
aval. La démonstration tout de suite:

```java
// Récupère le dialogue dont on ne sait rien
AbstractDialog dialog = retrievedDialog(...); 

// Récupère le rendu graphique en fonction de la fabrique
IFormater formater = dialog.getFormater(new DialogFormaterFactoryImpl()); 

// Applique le rendu graphique
formater.apply();
```

Et voilà, le tour est joué. Cette fois, je peux faire un rendu graphique sans me préocuper de quoi que ce soit, car
je sais que forcément j'aurai le bon. Il me suffira de créer mes rendus graphiques spécifiques. La seule contrainte
se situe au niveau de la fabrique, car si tout à coup on décide de changer de type d'interface (Client léger (web)
à un client lourd (swing)), il faudra changer la fabrique de rendu graphique ainsi que créer les classes de rendu
graphique. Mais dans tous les cas c'est très "simple" de pouvoir changer d'un rendu graphique à un autre. Après,
tout dépend du rendu graphique que l'on souhaite, mais les classes de contenu, on y touche plus.

Lorsque je veux modifier le nom de mes classes et méthodes c'est pas un problème avec des outils comme Eclipse ou
NetBeans qui font le refactoring (changement des noms en cascade...). Si je veux ajouter un dialogue ou plus, c'est
pas difficile, j'ajoute les classes et les méthodes nécessaires. Au final, je n'ai plus de grandes et délicates
modifications à faire.

Je vous propose un petit diagramme de classe pour résumer l'architecture de ce que je viens de vous expliquer. Les
liens avec des flèches fermées et vides sont des liens d'héritage, les flèches trétillées sont des liens
d'implémentation (interface) et les liens bleus sont simplement une utilisation de classe (association).

<!-- /assets/images/posts/2008-09-20-probleme-de-conception/rendering.jpg -->
{% include img.html
    image="rendering.jpg"
    type="landscape"
    thumb_size="600x545"
    thumb_width="600"
    thumb_height="545"
    thumb_use_original="yes"
    title="Architecture"
    gallery="img"
%}

Nous sommes au terme de cet article technique qui je l'espère vous aura plu. Je l'avoue, il est purement technique
et j'ai tenté de rester le plus simple possible, mais c'est guère possible quand on fait appel à autant de notions,
que dans cet article :laughing: Je suis très intéressé par tous les commentaires constructifs et idées
d'améliorations, ou simplement pour me signaler d'éventuelles erreurs.