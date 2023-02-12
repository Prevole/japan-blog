---
layout:     post
title:      Un peu de projet
date:       2008-09-18 16:00:22 +0200
categories: ["Projet"]
image:      /assets/images/posts/2008-09-18-un-peu-de-projet/mvc.jpg
---

Autant annoncer la couleur tout de suite. Cet article sera sûrement un des plus techniques que j'aurai écrit depuis
que je suis ici. Les sensibles de la technique s'abstenir, quoique ça peut être intéressant quand même. Y a une
jolie image (enfin j'espère :wink:).

<!--more-->

Y il a une semaine de celà, j'ai eu un téléphone avec mon professeur en Suisse et je lui ai parlé de ma partie
interface web (client du jeu pour le téléphone) et ma manière de faire. Forcément, je savais que c'était pas génial
au moment où j'en ai parlé, mais ça avait le mérite de fonctionner et d'être simple et efficace question fiabilité.
Une solution pas trop mauvaise, ni trop bonne.

En fait, je réalisais le traitement métier et rendu graphique dans les mêmes servlets (ou tout du moins ce qui en
faisait office). Un servlet est un bout de code côté serveur qui s'occupe de traîter les requêtes de l'utilisateur
sur le serveur web (quand on est avec une technologie java et tout ce qui va avec). Cette explication se veut
simpliste pour les non connaisseurs. En résumé, c'est du code qui fait ce que l'utilisateur a besoin lorsqu'il
clique sur un lien :wink: J'avais mis tout le traitement logique et graphique dans ces servlets.

En programmation, ce n'est pas terrible de faire ça, car on dit qu'il y a dépendance forte entre la vue et le
modèle. C'est à dire que les données métiers (en l'occurence du jeu) dépendent de la vue et la vue dépend des
données. Dans l'absolu, c'est certain qu'il y aura toujours une sorte de dépendance entre les deux. On a des
données, et on veut les afficher, donc si on ne connait pas les données on ne peut pas les afficher. Mais on se
doit de tout faire pour découpler le plus possible ces deux aspects.

Pourquoi chercher à faire celà ? Imaginez un instant que je veuille gérer non plus une application iMode pour NTT
Docomo, mais également des applications pour les deux autres opérateurs. Si je garde le couplage fort, alors je
devrais avoir à chaque fois tout le traitement métier copié avec le résultat graphique spécifique à chacun. Alors
que si je découple suffisament correctement le traitement logique du rendu graphique, alors je peux avoir plusieurs
vues différentes qui s'appuient sur les mêmes traitements logiques. En faisant cela, on s'assure une meilleure
évolutivité et un moyen de réutilisation du code.

Une décomposition possible s'appuie sur un modèle de conception nommé MVC pour Model View Controller (Modèle Vue
Contrôleur). L'idée est d'avoir des vues qui ne s'occupent que du rendu graphique, le modèle qui s'occupe que de la
gestion des objets métiers (stockage des données, ...), et un contrôleur qui s'occupe de gérer les traitements, de
réceptionner les demandes et de déléguer les rendus graphiques. Ainsi, chacune des parties a sa petite tâche bien
définie et permet le découplage.

C'est ce que j'ai mis en place cette semaine pour mon application. Bien entendu ça ne s'est pas passé sans mal, et
il m'a fallu 2 jours entiers pour mettre en place la structure et la tester. Il a ensuite fallu que je prépare
quelques outils supplémentaires pour générer les vues et que je mette en place quelques Transfer Objects pour
communiquer depuis mes Actions (mes actions sont les traitements logiques demandés par le contrôleur, par exemple :
enregistrer un nouvel utilisateur en fournissant le pseudo et mot de passe) vers mes vues. Comme je le disais tout
à l'heure, le découplage n'est possible que jusqu'à un certain point (tout du moins dans cette version basique de
ma réalisation). Donc il faut bien que la vue puisse obtenir les données à afficher. C'est à ça que servent mes
Transfert Objects en partie.

Tout de suite je vous propose un diagrame pour mieux fixer les idées en place et comprendre le cheminement du
processus depuis la requête d'un client à la réponse au client.

{%- media_cartridge -%}
{% include img.html
    image="mvc.jpg"
    type="landscape"
    thumb_size="300x189"
    thumb_width="600"
    thumb_height="379"
    thumb_use_original="yes"
    title="MVC"
    gallery="img"
    show_legend="yes"
%}
{%- endmedia_cartridge -%}

Je vous fais une fleur, je mets la légende en français :laughing:

1. Requête HTTP de l'utilisateur
2. Le contrôleur demande si l'action demandée existe
3. Le manager de configuration consulte le fichier XML de configuration
4. Le manager répond au contrôleur
5. Le contrôleur délègue le traitement à l'action demandée
6. L'action effectue le traitement et requiert l'aide de la couche de persistance en cas de besoin (EJB)
7. La couche de persistance renvoie le(s) résultat(s)
8. L'action retourne le statut d'exécution au contrôleur
9. Le contrôleur délègue le rendu graphique à la vue
10. La vue fait appel à d'autres vues (inclusions, modèles)
11. La vue renvoie le résultat à l'utilisateur (on espère qu'il sera content après tout ça :wink:)

Comme vous pouvez le constater, je ne vous ai pas encore parlé des deux points dans mon explication précédant le
schéma. Ces deux points concernent la partie de rendu graphique et de configuration des actions.

Commençons par la partie configuration. Pour me permettre une souplesse et une rigueur en même temps, j'ai mis en
place un fichier de configuration qui me permet de configurer les actions associées aux vues à utiliser. Ainsi, il
n'est pas possible de faire tout et n'importe quoi du côté utilisateur et du côté développeur, il faut savoir ce
que l'on fait et ce que l'on veut faire, tout en laissant la porte ouverte à de nombreuses possibilités de
configuration. Pour cette partie, j'ai utilisé JAXB qui permet de charger et de gérer facilement un fichier XML à
partir de classe Java existante ou pas. On ajoute quelques annotations à nos classes (@XmlRootElement, @XmlElement,
...) et on crée quelques TypeAdapter pour les cas particuliers pour que ça nous arrange bien tout en gardant la
facilité de chargement.

Pour la partie du rendu graphique, il est parfois utile de pouvoir créer un modèle (template) et de pouvoir le
réutiliser le plus possible. Ainsi, il ne reste plus qu'à se concentrer sur la partie contenu et plus celle du
contenant. C'est ce que j'ai mis en ouevre au moyen de la balise &lt;jsp:include&gt;. Cette balise me permet
d'inclure un fichier jsp dans un autre. Après, au moyen de mon fichier de configuration mentionné précédement, il
ne me reste plus qu'à définir le nom des vues à employer.

Sachant que je ne dispose que d'un jeu réduit de balises XHTML pour mon développement, j'ai pris soin de créer mes
propres balises au niveau jsp. Ceci se fait au moyen des TagHandler. Une fois ces classes capables de gérer les tag
créées (j'en ai une bonne trentaine), il suffit de préparer un fichier tld qui contient la "taglib definition",
c'est à dire la définition des balises. On définit à cet endroit ce que l'on peut faire ou pas avec les balises.
Une fois fait et grâce à NetBeans, je peux écrire des documents avec mes propres balises, tout en étant sûr que la
syntaxe et les contraintes sont respectées.

Au final, je suis satisfait de ce que j'ai fait et je dis un grand merci au professeur Liechti qui a su m'orienter
vers des sources de documentation très utiles. Il reste encore un point noir actuellement à mon design, c'est que
c'est uniquement fonctionnel dans le cadre de mon application iMode (parce que c'est codé avec les pieds, oui !) et
donc je dois reprendre un petit peu pour améliorer ça, histoire de découpler complètement les vues des actions. Je
sais pas quand je vais faire ça parce que j'ai d'autres priorités avant ça. Il faut dire qu'il me reste à finir de
convertir ce que j'avais fait jusque là ([voir mon sujet précédent]({% post_url 2008-09-12-avancement-du-projet-2 %})). 
Une fois que se sera fait, il faudra reprendre la progression des travaux qui ne sont pas en avance.