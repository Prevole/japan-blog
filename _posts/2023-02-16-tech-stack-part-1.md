---
layout:     post
title:      Le Stack Technologique - Partie 1
date:       2023-02-16 22:31:00 +0100
categories: ["Général"]
---

Après avoir convertit mon blog dynamique en blog static, il me semble intéressant de parler du stack technologique 
retenu et mis en place. Bien sûr, ça n'intéressera que les plus férus de techniques et pas les autres.

<!--more-->

Tout d'abord et comme mentionné dans mon article précédent, j'ai opté pour un site static pour ne plus avoir besoin de
faire de maintenance régulière sur le stack technologique qui fait tourner le site. Avec des solutions comme 
[WordPress](https://github.com/WordPress/wordpress-develop){:target="_blank"},  il faut régulièrement le mettre à jour 
ainsi que les plugins utilisés. 

C'est très important de le faire pour éviter de se faire pirater son site ou autres joyeusetés du genre. Mettre à jour
un tel stack requiert du temps même si de nos jours, WordPress intègre ce qu'il faut pour rendre ces mises à jours plus
douces. Mais il n'empêche qu'il faut toujours vérifier que c'est toujours en ordre, que le design ne subit pas d'effet
de bords, que des fonctionnalités ne disparaissent pas.

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

{% highlight yaml %}
---
layout:     post
title:      Le Stack Technologique
date:       2023-02-16 22:31:00 +0100
categories: ["Général"]
---
{% endhighlight %}

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
titre de ce genre là: `&lt;h1&gt;Markdown&lt;/h1&gt;`.

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

{% highlight liquid %}
{% raw %}
{% highlight yaml %}
...
{% endhighlight %}
{% endraw %}
{% endhighlight %}

Et voici un exemple d'inline statement. Il s'agit d'un extrait dans le layout de génération des articles pour indiquer
le temps de lecture estimé d'un article. L'exemple contient également l'utilisation d'un filtre dont nous discuterons
plus loin.

{% highlight liquid %}
{% raw %}
<span>{{ page.read_time | time_to_read }}</span>
{% endraw %}
{% endhighlight %}

Un autre exemple d'inline statement et de block statement pris directement d'un des articles. Il s'agit de l'insertion 
de média organisé dans un même contexte pour l'affichage dans un article. Le but n'est pas de passer en détail ce que
fait chaque élément de Liquid mais d’apercevoir ce que ça implique dans mes articles.

{% highlight liquid %}
{% raw %}
{%- media_cartridge -%}
{% include img.html 
    image="IMG_0078.jpg" 
    type="portrait" 
    thumb_size="225x300" 
    title="Chaussures détruites" 
    gallery="img" %}
{%- endmedia_cartridge -%}
{% endraw %}
{% endhighlight %}

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

# Jekyll Plugins

Avant de parler à proprement parler du [système de plugin](https://jekyllrb.com/docs/plugins/){:target="_blank"} 
présent dans Jekyll, il faut mentionner la fonctionnalité dite des collections. Jekyll permet de créer des collections 
de données sous forme de fichiers `yaml` qui peuvent ensuite être traiter de manière cohérente entre eux. C'est pratique
car par défaut, les données sont loadées automatiquement et groupées correctement. Il suffit de simplement les exploiter
pour les ajouter dans le contenu des pages générées.

En guise de teaser, les types de plugins que j'ai utilisé/créé sont les suivants:

- [Générateurs](https://jekyllrb.com/docs/plugins/generators/){:target="_blank"}
- [Filtres](https://jekyllrb.com/docs/plugins/filters/){:target="_blank"}
- [Tags](https://jekyllrb.com/docs/plugins/tags/#tag-blocks){:target="_blank"}
- [Hooks](https://jekyllrb.com/docs/plugins/hooks/){:target="_blank"}

### Commentaires

Lorsque j'ai convertit mes articles WordPress vers mon site static, j'avais les commentaires récupérer également.
Certains diront que ce n'est pas forcément très important mais j'estime que ça fait partie de mon patrimoine émotionnel,
de mes souvenirs. C'est des moments précieux de mon aventure japonaise. Relire mes articles puis relire les commentaires
me rappellent de bons et moins bons souvenirs mais ça fait partie de mon être.

C'est un bon exemple de contenus qui se prête à être traiter en mode collection. La particularité vient du fait que 
chaque article à son propre sous-ensemble de commentaires. Mais ça tombe bien, parce que Jekyll organise les 
[collections](https://jekyllrb.com/docs/collections/){:target="_blank"} en fonction de contenus présents dans des 
fichiers `yaml`. Pour être plus précis, Jekyll considère comme un même type de collection tous les documents présents 
dans un répertoire. 

Pour les commentaires, il s'agit du répertoire `_data/comments`. Dans ce répertoire se trouve des fichiers qui ont le 
même nom que les fichiers markdown de mes articles. La correspondance 1:1 entre le nom de fichier d'un article et le
nom de fichier de ses commentaires est bien entendu faite à dessein. Par convention, si une collection de commentaires
existe pour un article donné, alors c'est qu'il y a un commentaire ou plus. Autrement, il n'y a pas de commentaires pour
l'article en question.

Grace à ce mécanisme, il est facile ensuite d'écrire le rendu des commentaires comme l'exemple ci-dessous:

{% highlight liquid %}
{% raw %}
# Retrieve the collection comments collection name
{% assign comment_file = page.name | remove: '.md' %}

# Check if there are comments for the article
{% if site.data.comments[comments_file] %}
<section class="comments">
...
</section>
{%- endif -%}
{% endraw %}
{% endhighlight %}

Quand à la structure d'un commentaire, l'exemple suivant en donne un exemple. Chaque commentaire est constitué de 3
champs:

- `author` L'auteur du commentaire
- `date` Date et heure quand le commentaire a été posté
- `text` Le texte du commentaire

{% highlight yaml %}
- author: Prevole
  date: '2008-06-30 13:19:38 +0200'
  text: |
    Le texte du commentaire qui va bien
{% endhighlight %}

Jekyll load automatiquement les structure `yaml` et les mets à disposition comme des objets sont faciles à exploiter.
L'exemple suivant montre l'utilisation d'un commentaire dans le rendu des commentaires d'un article. On y voit la 
structure d'un commentaire et la boucle qui est faite pour parcourir tous les commentaires de l'article.

{% highlight liquid %}
{% raw %}
# Loop to iterate over the post comments
{%- for comment in site.data.comments[comments_file] -%}

# Custom filter to vary the CSS style when the comment is posted by the post author
<section class="comment {{ comment | comment_class_author: "", "comment-owner" }}">
  <div class="{{ comment | comment_class_author: "comment-m…", "comment-o…                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      " }}">
    <div class="comment-meta-icon">...</div>
    <div class="comment-meta">
      # Access to the fields author and date of the comment. For the date, 
      # we apply a custom filter
      <p class="comment-author">{{ comment.author }}</p>
      <p class="comment-date">{{ comment.date | format_dt }}</p>
    </div>
  </div>
  <div class="{{ comment | comment_class_author: "comment-c…", "comment-o…" }}">
    # Show the comment's content and apply Liquid filters (the last one is a custom filter)
    {{ comment.text | markdownify | comment_reply_to }}
  </div>
</section>
{%- endfor -%}

{% endraw %}
{% endhighlight %}

Nous reviendrons un peu plus tard sur les plugins utilisés pour améliorer les contenus et faciliter la vie à quelques 
endroits.

### Galeries

En relation avec les articles, j'ai parfois des galeries de photos. Le use case est relativement simple. Une galerie
dans un article. C'est toujours ainsi que se présente la chose. Certains articles n'ont pas de galerie.

Une galerie est caractérisée par les éléments suivants:

- `name` Le nom de la galerie. Nom humain.
- `date` La date des prises de vue
- `images` Une liste d'images. Chaque image étant composée des éléments suivants
  - `title` Un potentiel titre, parfois (souvent) vide ou … Autrement, ça sert à décrire le contexte de la photo
  - `date` La date et l'heure de la photo. A noter que lors de la migration, la date de la première photo a été utilisé
           pour renseigner la date de la galerie.
  - `file` Le nom du fichier de la photo
  - `path` Le path complet y compris le nom du fichier d ela photo (absolu par rapport à la racine du site)
  - `thumb` Le chemin complet vers l'image miniature pour la vue d'ensemble de la galerie (absolu par rapport à la 
            racine du site)

En `yaml`, ça donne l'extrait suivant. A nouveau, on constate rapidement qu'il s'agit d'informations structurées et 
facile à utiliser ou réutiliser dans d'autres contextes. 

{% highlight yaml %}
name: Akihabara by day
date: '2008-10-31 11:13:44 +0100'
images:
- title: |
    Du manga par ci.
  date: '2008-10-31 11:13:44 +0100'
  file: IMG_1875.JPG
  path: "/assets/images/galleries/akihabara-by-day/IMG_1875.JPG"
  thumb: "/assets/images/galleries/akihabara-by-day/thumbs/thumbs_IMG_1875.JPG"
- ...
{% endhighlight %}

Jekyll load la collection de données des galeries de la même manière que les commentaires. De cette manière, je me 
retrouve avec l'objet `site.data.galleries` avec toutes les galeries du site. Je n'ai plus qu'à y accéder par leur
nom qui correspond au nom du fichier sans l'extension. Il est dès lors facile de créer un bout de code HTML avec Liquid
pour rendre la galerie dans un article. Le code suivant est celui originellement utilisé au moment de l'écriture de cet
article. Il s'agit du fichier `_includes/gallery.html`.

{% highlight liquid %}
{% raw %}
<ul class="image-gallery">
  # Retrieve the gallery data based on gallery name (the include prefix
  # means we have the following code in an _include HTML file)
  {% assign gallery = site.data.galleries[include.gallery] %}
  
  # We iterate over each image present in the gallery data
  {% for image in gallery.images %}

  # We extract the image name to create kind of unique id
  {%- assign image_name = (image.file | split: ".")[0]  %}
  <li>
    # Part of the following code is realted to glightbox to present galleries
    <a href="{{ image.path }}" 
      class="glightbox-gallery" 
      data-gallery="{{ include.gallery }}" 
      data-description=".custom-desc-{{ image_name }}">
      <img class="image" src="{{ image.thumb }}" alt="{{ image.title }}">
    </a>
    <div class="glightbox-desc custom-desc-{{ image_name }}">
      <p>{{ image.title }}</p>
    </div>
  </li>
 {% endfor %}
</ul>
{% endraw %}
{% endhighlight %}

Pour exploiter cet include dans mes articles, voici le code Liquid nécessaire. A nouveau, l'article contient un bout
de customisation Liquid mais c'est relativement faible et facile à parser le jour où il faudra changer de moteur de
site static. L'information reste finalement assez facile et structurée.

{% highlight liquid %}
{% raw %}
{% include gallery.html gallery="tokyo-roppongi-itchome-view" %}
{% endraw %}
{% endhighlight %}

Jusque là, nous avons jeté les bases pour pouvoir parler des plugins de Jekyll. Cette technologie offre toute une série
de points d'extensions afin d'enrichir les contenus et la génération. La communauté autour de Jekyll offre des plugins
ce que j'ai en partie profiter. Par exemple, j'utilise le plugin 
[Paginate V2](https://github.com/sverrirs/jekyll-paginate-v2){:target="_blank"}