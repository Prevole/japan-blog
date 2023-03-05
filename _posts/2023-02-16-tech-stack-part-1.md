---
layout:     post
title:      Le Stack Technologique - Partie 1
date:       2023-02-16 22:29:00 +0100
categories: ["Général"]
---

Tout d'abord et comme mentionné dans mon article [Le Blog renait]({% post_url 2023-02-15-renaissance %}), j'ai opté 
pour un site static pour ne plus avoir besoin de faire de maintenance régulière sur le stack technologique qui fait 
tourner le site. Avec des solutions comme [WordPress](https://github.com/WordPress/wordpress-develop){:target="_blank"},  
il faut régulièrement le mettre à jour ainsi que les plugins utilisés.

<!--more-->

Comme vous pouvez vous en douter, c'est très important de le faire pour éviter de se faire pirater son site ou autres 
joyeusetés du genre. Mettre à jour un tel stack requiert du temps même si de nos jours, WordPress intègre ce qu'il faut
pour rendre ces mises à jours plus douces. Mais il n'empêche qu'il faut toujours vérifier que c'est toujours en ordre, 
que le design ne subit pas d'effet de bords, que des fonctionnalités ne disparaissent pas.

L'avantage du stack technologique pour un site static c'est que toute la tool chain se fait en amont. Une fois le site 
"compilé", celui-ci ne bouge plus. L'outcome du build du site se présente sous forme de fichiers "basiques": HTML, CSS, 
JS, PNG, JPEG, ... Avec un tel contenu, seul un serveur web servant de bêtes fichiers comme n'importe quel serveur sait 
le faire. Ça fait plus de 20 ans que les serveurs web existent, ils ne sont donc pas prêts de disparaître...

Mais du coup, bah oui, c'est facile de dire que je veux faire un site static. J'aurai pu créer des pages HTML bêtes et 
méchantes en les créant à la main, en créant les liens à la main. Mais si je veux pouvoir encore poster du contenu de
temps en temps comme je suis entrain de le faire à présent, et bien il faut pouvoir régénérer les pages régulièrement.

C'est ici qu'intervient le terme de [Jamstack](https://jamstack.org/){:target="_blank"}, de nouveau un buzz word, si 
vous me permettez l'expression, pour pas grand chose. En bref, c'est un terme qui recouvre exactement le fait de 
séparer l'expérience web de la partie data. Des tas de solutions existent pour apporter une réponse à cette 
problématique. 

# Jekyll

Parmi toutes ces solutions, une a retenue depuis longtemps mon attention: 
[Jekyll](https://jekyllrb.com/){:target="_blank"}. Il s'agit d'une solution basée sur 
[Ruby](https://www.ruby-lang.org/en/){:target="_blank"} (par abus de langage et extension: 
[Ruby on Rails](https://rubyonrails.org/){:target="_blank"}). Cette solution est également la solution de base utilisée 
pour la publication automatique des [github pages](https://pages.github.com/){:target="_blank"} (il s'agit en réalité 
d'une version fixée avec un subset des possibilités existantes mais c'est suffisamment pratique et puissant pour être 
mentionné ici).

J'ai retenu cette solution parmi d'autres parce que je connais déjà Jekyll depuis quelques années sans l'avoir 
extensivement utilisé. C'est basé sur du Ruby que je connais (je suis rouillé mais pas complètement perdu) pour avoir
pratique du Ruby on Rails pendant plusieurs mois/années. Le but était d'obtenir un résultat assez rapidement et donc
la courbe d'apprentissage était également un critère de choix.

Quand on y réfléchit de plus près, ce choix n'est pas aussi important qu'il n'y parait. Une fois le site généré, le 
résultat ne bouge plus et c'est tout le but. Si par la suite, la technologie venait à être dépréciée ou si je souhaite
explorer de nouvelles options pour construire mon site les contenus sont dans un format suffisamment simple pour que 
l'effort de conversion soit plus simple.

### Front Matter

A noter qu'un article dans Jekyll contient une spécificité ou deux. Comme souvent dans les générateurs de sites 
statiques, il y'a ce qu'on appelle le [front matter](https://jekyllrb.com/docs/front-matter/){:target="_blank"} qui est 
une entête de fichier pour influencer la génération des contenus. L'exemple ci-dessous est le `front matter` de cet 
article. Comme on peut le voir, on y trouve la `date de publication` qui est arbitraire, le `titre` de l'article, le 
`layout` du rendu, la liste des `catégories` aux quelles appartient l'article.

~~~yaml
---
layout:     post
title:      Le Stack Technologique
date:       2023-02-16 22:31:00 +0100
categories: ["Général"]
---
~~~

Ces différentes informations vont permettre la génération des pages HTML qui seront servies. La date va apparaître par
exemple en dessous du titre dans cet article (et les autres). C'est également la date qui va servir au tri pour ordonner
les articles dans la liste des articles des pages principales.

Cette addition dans les fichiers d'articles est obligatoire pour Jekyll, autrement, les articles seraient pris comme
des fichiers bruts et ne seraient pas pris pour la génération des pages HTML. Si un jour je décide de récupérer les 
articles pour en faire autre chose, alors il me suffira de simplement supprimer ce `front matter` ce qui se fait très
facilement avec une commande ou deux du genre `sed`, …

# Markdown

Comme expliqué à l'instant, le format de fichier des articles et commentaires est simple. Il s'agit du 
[Markdown](https://daringfireball.net/projects/markdown/syntax){:target="_blank"}. Le Markdown est un langage de 
formatage qui se base sur quelques des "balises" qui sont finalement quelques caractères à ajouter dans le texte. Par 
exemple, un titre de section de cet article se formalise de cette manière: `# Markdown`. Lorsque le site est généré, 
ces marqueurs de formatage sont convertis automatiquement vers du langage HTML. Ainsi, l'exemple précédent va créer un 
titre de ce genre là: `{% raw %}<h1>Markdown</h1>{% endraw %}`.

Le grand avantage de se formatage textuel est que l'on ne se préoccupe plus de formater son texte dans des outils comme
Word ou autre. On focalise essentiellement sur le contenu et la rédaction. Comme on est dans un format texte, c'est très
facile de changer de technologie. Les fichiers sont de simples fichiers texte et ils peuvent être lus par n'importe quel
outil. Si on souhaite changer de technologie, il suffit au choix:

- soit de trouver un outil qui interprète le markdown dans un autre langage de programmation/technologie
- soit de reprendre le texte et y apporter de légères modifications pour un autre moteur de rendu

### Kramdown

En réalité, Jekyll intgère la possibilité d'utiliser un sur-ensemble de Markdown nommé 
[kramdown](https://kramdown.gettalong.org/){:target="_blank"} qui est l'interpréteur 
[Markdown](https://jekyllrb.com/docs/configuration/markdown/){:target="_blank"} par défaut dans Jekyll. Cette 
intégration permet également d'ajouter la coloration syntaxique du code via 
[Rouge](https://github.com/rouge-ruby/rouge){:target="_blank"}. J'ai quelques articles, comme celui que vous être 
entrain de lire, qui contienne du code et c'est fort pratique d'avoir de quoi le rendre visuellement plus agréable à
lire.

# Liquid

Comme vous avez pu le voir plus haut ainsi que dans différents articles, je dispose de plusieurs options de formatage
avancées pour les images et media en général, pour le code et deux trois autres petites bricoles.

La génération des pages HTML est effectué via Jekyll qui est la technologie qui va compiler les contenus, les organiser
mais pour le rendu lui même, Jekyll repose sur un moteur de templating qui se nomme 
[Liquid](https://shopify.github.io/liquid/){:target="_blank"}. Il s'agit d'un des nombreux moteurs de template qui 
existe. On peut en citer d'autres tels que [Jinja](https://jinja.palletsprojects.com/en/3.1.x/intro/){:target="_blank"}, 
[Mustache](https://mustache.github.io/){:target="_blank"}, … En général, chaque langage de programmation dispose d'un 
template engine phare qui est très utilisé et d'une pléthore d'autres template engines plus obscurs les uns que 
les autres.

La majorité des moteurs de templates reposent sur les mêmes principes:

- des opérateurs
- des séquences de contrôle (boucles, conditions, …)
- des variables
- des remplacements de placeholders
- des filtres (nous y reviendrons)

Finalement, on est pas très loin d'un langage de programmation. Dans le cas de Liquid, on retrouve exactement les 
éléments mentionnés. On peut également découper les instructions du template engine en deux catégories:

- block statements: Permet d'appliquer une instruction du template engine à tout ce qui se trouve entre deux marqueurs
- inline statements: Permet d'appliquer une instruction directement à l'endroit de l'appel

L'exemple suivant est un block statement Liquid pour formatter du code. J'en utilise dans cet article. Tout ce qui se
trouve entre l'élément ouvrant et l'élément fermant sera formatter d'une manière plus spécifique que juste du Markdown.

~~~liquid
{%- raw -%}
{% highlight yaml %}
...
{% endhighlight %}
{% endraw -%}
~~~

Et voici un exemple d'inline statement. Il s'agit d'un extrait dans le layout de génération des articles pour indiquer
le temps de lecture estimé d'un article. L'exemple contient également l'utilisation d'un filtre dont nous discuterons
plus loin.

~~~liquid
{%- raw -%}
<span>{{ page.read_time | time_to_read }}</span>
{% endraw -%}
~~~

Un autre exemple d'inline statement et de block statement pris directement d'un des articles. Il s'agit de l'insertion 
de média organisé dans un même contexte pour l'affichage dans un article. Le but n'est pas de passer en détail ce que
fait chaque élément de Liquid mais d’apercevoir ce que ça implique dans mes articles.

~~~liquid
{%- raw -%}
{%- media_cartridge -%}
{% include img.html 
    image="IMG_0078.jpg" 
    type="portrait" 
    thumb_size="225x300" 
    title="Chaussures détruites" 
    gallery="img" %}
{%- endmedia_cartridge -%}
{% endraw -%}
~~~

Ces différents ajouts dans les articles sont autant de customizations liées à la technologie du moteur de rendu Liquid.
On peut associer cette manière de travailler à une sorte de Lock In. C'est à dire qu'une fois qu'on met les pieds 
dedans, ça devient difficile d'en sortir. C'est très fréquent en IT. Une fois une solution choisie, le coût et les 
efforts pour quitter la solution sont très/trop élevées et du coup, on reste pendant des années et des années avec la 
même solution qu'on évolue au gré des mises à jour du vendeur qui ne manque pas de changer ces prix de temps en temps 
:smiley: Mais ceci est un autre débat.

Pour revenir à mon site, le choix d'ajouter ce type de customizations est un trade off comme on en fait sans arrêt en 
IT. Avec les années, je me rends compte que l'IT n'est qu'un long chemin de croix parmi des tas d'options qui sont bien
souvent toutes aussi valables les unes que les autres (à quelques exceptions près bien sûr). On passe notre temps à 
évaluer des options et faire des choix qui ne sont jamais parfaits et qui deviennent caducs des mois ou années plus
tard.

Dans mon site, j'ai décidé d'ajouter ces customizations pour me simplifier la vie. Sans ces balises de Liquid, je 
serais obligé de répéter ou d'ajouter des bouts de code à mes fichiers de textes de manière encore plus intrusive. Mais
quand on y regarde de plus près, les ajouts que je fais dans mes articles sont liés aux images et medias et qu'ils sont,
la majorité du temps, porteur d'information importantes (nom de l'image, …).

Au final, récupérer les informations sémantiques de ces éléments ajoutés est relativement facile à l'aide d'expression
régulières (regex pour les initiés) car tous ces ajouts sont construits de la même manière. C'est un compromis que 
j'estime totalement viable sur le long terme. Encore une fois, il s'agit de texte dans mes articles et c'est assez 
facile de les exploiter.
