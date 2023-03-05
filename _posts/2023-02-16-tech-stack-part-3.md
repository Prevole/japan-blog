---
layout:     post
title:      Le Stack Technologique - Partie 3
date:       2023-02-16 22:27:00 +0100
categories: ["Général"]
---

Comment déjà mentionné dans mes articles précédents de la série `Le Stack Technologique`, Jekyll offre une série de 
points d'extensions. Cela permet d'étendre les fonctionnalités de base avec une personnalisation ciblée pour les besoins
personnels. La communauté autour de Jekyll offre des plugins ce que j'ai en partie profiter. Par exemple, j'utilise le 
plugin [Paginate V2](https://github.com/sverrirs/jekyll-paginate-v2){:target="_blank"}

<!--more-->

Le [système de plugin](https://jekyllrb.com/docs/plugins/){:target="_blank"} de Jekyll offre des points d'extensions à
plusieurs niveaux. Certaines des extensions possibles sont finalement des extensions de Liquid directement tels que les
filtres.

Les principales catégories de plugins sont les suivantes:

- [Générateurs](#générateurs)
- [Filtres](#filtres)
- [Tags](#tags)
- [Hooks](#hooks)

# Générateurs 

Les [Générateurs](https://jekyllrb.com/docs/plugins/generators/){:target="_blank"} sont des extensions qui permettent 
d'enrichir les données et de générer des contenus. Enrichir les données s'avère très utile quand on veut pré-calculer 
avant la génération des contenus HTML des informations. Quant à la génération de contenus, il s'agit de générer de 
nouvelles pages non prévue par Jekyll de base. C'est par exemple le cas avec le plugin de pagination qui génère des 
pages paginées.

Dans mon cas, les commentaires se prêtaient parfaitement à l'exercice du générateur. 80% des articles disposent d'une
collection de commentaires. Chaque page d'article générée doit être en mesure d'afficher les commentaires si présents 
ou de ne rien afficher. Écrit comme ça, on se rend compte qu'on a toujours besoin de savoir combien de commentaires sont 
présents pour un article donné.

Comme nous l'avons vu dans l'article précédent - [Tech Stack - Partie 2]({% post_url 2023-02-16-tech-stack-part-2 %}) - 
les commentaire sont organisés sous forme de collections mais pas directement relié aux articles. Le lien peut être 
catégorisé comme étant un soft-link. Par soft-link, je sous entend qu'il n'y a que les noms de fichiers de l'article
et de la collection de commentaires qui permettent de trouver un lien entre les deux. Le fichier de commentaire et le
fichier de l'article portent le même nom à l'extension près.

Partant de ce principe, il me faut trouver un moyen de mettre en relation les commentaire et les articles. C'est ici que
les générateurs entre en ligne car ils vont me permettre de pouvoir rattacher de l'information avant que les pages du
site ne soient générées.

Sans plus attendre, un petit bout de code `Ruby` pour démontrer comment j'utilise les générateurs pour traiter les 
commentaires des articles.

~~~ruby
module CommentsPlugin
  # Chaque générateur doit hériter d'une class Jekyll::Generator
  class Generator < Jekyll::Generator
    
    # Cette classe nécessite d'implémenter la méthode generate
    def generate(site)

      # On itère sur tous les articles du site
      site.posts.docs.each do |post|

        # On a besoin de récupérer le nom technique sans l'extension du fichier
        post_tech_name = File.basename(post.path).gsub(/\..*/, "")
  
        # On récupère la collection si elle existe
        comments = site.data["comments"][post_tech_name]
  
        # On enrichi les données de l'article en fonction des commentaires retrouvés. 
        # Une fois arrivé ici, l'article dispose des informations du nombre de commentaires
        # ainsi que les commentaires eux-mêmes
        if comments.nil?
          post.data["comments_count"] = 0
          post.data["comments"] = []
        else
          post.data["comments_count"] = comments.length
          post.data["comments"] = comments
        end
      end
    end
  end
end
~~~

On peut noter dans le code précédent que l'on ajoute le nombre de commentaires en data des articles ainsi que la liste 
des commentaires. C'est uniquement un raccourci pour éviter plus tard de devoir écrire un code un peu plus long. On peut
classer cet ajoute comme un code pour mon confort personnel d'utilisation.

Parfait, nous avons nos données qui sont attachées à nos articles mais encore faut-il les exploiter dans la génération
des pages HTML. C'est ce que nous allons découvrir à présent. J'utilise les commentaires à deux endroits distincts. Le
premier endroit est la liste des articles présents sur le site (que ce soit toutes catégories confondues ou par 
catégorie). 

Nous allons commencer par voir comment j'affiche si des commentaire sont présents. Le bout de code se trouve dans 
`_includes/post-card.html`.

~~~html
{%- raw -%}
<!-- Comme prévu, la data enrichie sur les articles est directement accessible. Ici,
     on accède au nombre de commentaires pour afficher plus d'info si nécessaire. -->
{%- if post.comments_count > 0 -%}
<span class="post-card-header-separator">|</span>
  <a href="{{ post.url }}#comments">
    <svg class="icon icon-bubbles4">
      <use xlink:href="#icon-bubbles4"></use>

    <!-- Puis, on affiche la forme singulière ou plurielle du mot commentaire en
         fonction du nombre de commentaires. -->
    </svg> {{ post.comments_count | pluralize: "commentaire", "commentaires" }}
  </a>
{%- endif -%}
{% endraw -%}
~~~

A présent, regardons comment est rendu les commentaires dans les articles. Le code présenté ci-après se trouve dans
`_includes/comments.html`. Ce fichier est inclus dans le fichier `_layouts/post.html` qui permet de rendre un article.

~~~html
{%- raw -%}
<!-- On vérifie si des commentaires sont présents pour l'article -->
{%- if page.comments_count > 0 -%}
<section class="comments">
  <a id="comments"></a>
  <header>
    <h1 class="post-title">...</h1>
  </header>

  <!-- On affiche chaque commentaire -->
  {%- for comment in page.comments -%}
  <section 
    class="comment {{ comment.author | comment_class_author: '', 'comment-…' }}">
    
    <!-- On change la présentation si le commentaire est écrit par 
         l'auteur du site -->
    <div class="{{ comment | comment_class_author: 'comment-…', 'comment-…' }}">
      <div class="comment-meta-icon">...</div>

      <!-- On affiche les infos du commentaire: date, auteur -->
      <div class="comment-meta">
        <p class="comment-author">{{ comment.author }}</p>
        <p class="comment-date">{{ comment.date | format_dt }}</p>
      </div>
    </div>
    
    <!-- Pour le bloc du commentaire, on change la préentation également 
         en fonction de l'auteur -->
    <div class="{{ comment.author | comment_class_author: 'comment-…', 'comment-…' }}">

      <!-- Finalement, on affiche le contenu du commentaire -->
      {{ comment.text | markdownify | comment_reply_to }}
    </div>
  </section>
  {%- endfor -%}
</section>
{%- endif -%}
{% endraw -%}
~~~

De nouveau, on se rend compte que c'est facile d'accéder aux informations des commentaires liés à l'article vu qu'ils 
ont été attachés durant la phase de génération. Sans cette manière de faire, il serait plus compliqué d'accéder aux 
données car il faudrait accéder aux `site.collections` qui contient les informations. Il faudrait le faire à chaque 
endroit où on en a besoin.

Dans le registre des générateurs, j'ai un second générateur qui me permet de calculer un temps approximatif de lecture
pour les articles. C'est quelque chose qui est devenu pas mal à la mode sur Internet. C'est pratique d'arriver sur un 
article et de savoir combien de temps de lecture nous attend.

Le code pour ce générateur est présenté ci-dessous.

~~~ruby
module ReadTimePlugin
  class Generator < Jekyll::Generator
    include Liquid::StandardFilters

    # Avec le texte brut, on compte le nombre de mots que l'on
    # divise par le nombre de mots minutes moyen en français.
    def generate(site)
      site.posts.docs.each do |post|
        total_words = get_plain_text(post.content).split.size
        post.data["read_time"] = (total_words / 300.0).ceil
      end
    end

    # On veut récupérer le texte pur sans tags HTML pour ne pas 
    # les compter comme temps de lecture
    def get_plain_text(input)
      strip_html(strip_pre_tags(input))
    end

    # On élimine les tags pre qui ne le sont pas par le strip_html
    def strip_pre_tags(input)
      input.to_s.gsub(/<pre.*?>(.*)<\/pre>/mi, "\1")
    end
  end
end
~~~

Puis l'utilisation que l'on en fait dans les articles.

~~~html
{%- raw -%}
<!-- On affiche simplement le temps de lecture. Rien de compliqué ici. -->
<span>{{ page.read_time | pluralize: "minute", "minutes" }} de lecture</span>
{% endraw -%}
~~~

# Filtres

Comme on a pu le voir dans les exemples de layout ou de pages rendues au chapitre des générateurs, j'utilise plusieurs
[filtres](https://jekyllrb.com/docs/plugins/filters/){:target="_blank"} dont certains développés par mes soins. Bien 
que ce soit des plugins Jekyll, en réalité, il s'agit surtout d'extensions à Liquid. 

### Filtres - Pluralize

Prenons en exemple le filtre que j'ai utilisé dans les exemples précédents qui permet d'afficher une version singulière
ou plurielle d'un mot en fonction de la quantité spécifiée. En gros, le pseudo code suivant fait le job pour la logique
du choix du bon mot

~~~pseudo
si valeur > 1 alors 
  pluriel 
sinon 
  singulier
fin si
~~~

> Durant l'écriture de cet article, j'ai été confronté au fait que je ne pouvais pas affiché un morceau de pseudo-
> code comme je le souhaitais. J'ai effectué quelques recherches et j'ai fini par écrire mon propre petit `lexer` pour
> pouvoir présenter mon pseudo code comme du code normal. Ceci nous permettra de rebondir plus loin dans l'article
> sur le type d'extension nommée `hooks`.

Ce qui donne le code suivant pour le filtre utilisable dans Jekyll.

~~~ruby
module Jekyll
  module PluralizeFilter

    # La définition de la fonction qui est exécutée comme filtre
    def pluralize(value, singular, plural)
      
      # On s'assure que la valeur fournie est bien un entier
      value = value.to_i
      
      # On effectue la vérification pour obtenir la forme singulière
      # ou la forme plurielle. Les deux formes sont données en 
      # paramètre
      if value > 1
        "#{value} #{plural}"
      else
        "#{value} #{singular}"
      end
    end
  end
end

# C'est ici qu'on enregistre directement notre filtre 
# dans Liquid et non pas dans Jekyll
Liquid::Template.register_filter(Jekyll::PluralizeFilter)
~~~

Une fois que l'on sait comment écrire une fonction en ruby, que l'on sait comment encapsuler la fonction dans des 
modules et finalement activer le filtre via l'instruction qui va bien dans Liquid, il devient facile d'ajouter des
filtres pour différentes tâches.

### Filtres - Comment Class Author

Le prochain filtre dont nous allons discuté permet d'ajouter une class CSS en fonction de l'auteur d'un commentaire. 
J'ai vu sur un site lors du développement de mon site static un système de commentaires où les commentaires des auteurs
des articles étaient stylés différemment que les autres commentaires. Cette manière de présenter m'a bien plu et j'ai
piqué l'idée pour mon site.

Le code en lui même n'est pas très compliqué. L'unique subtilité tiens du fait qu'on ajoute une configuration 
personnalisée dans le fichier de configuration du site. Étant donné que je suis le seul auteur pour tous les articles,
je ne me suis pas embêté à mettre l'auteur dans chaque article et basé mon filtre sur l'auteur de chaque article. A la 
place, j'ai mis une configuration globale.

~~~yaml
...
japan:
  author: Prevole
...
~~~

On peut noter que ma configuration personnalisée a une clé de configuration racine `japan` pour éviter tout conflit de
configuration avec d'autres éléments de Jekyll.

Pour ce qui est du filtre, le code est simple. Il suit le principe du pseudo code suivant.

~~~pseudo
si auteur du commentaire == auteur du site alors
  classe normale + classe auteur
sinon
  classe normale
fin si 
~~~

Ce pseudo code se traduit en Ruby dans un filtre Liquid de la manière suivante.

~~~ruby
module Jekyll
  module CommentClassAuthorFilter

    # Défini les classes CSS en fonction de l'auteur
    def comment_class_author(author, base_class, class_if_author)
      
      # On vérifie si l'auteur spécifié en paramètre correspond 
      # à l'auteur présent dans la configuration du site
      if author == @context.registers[:site].config['japan']['author']
        "#{base_class} #{class_if_author}"
      else
        base_class
      end
    end
  end
end

# Puis on enregistre notre filtre dans Liquid
Liquid::Template.register_filter(Jekyll::CommentClassAuthorFilter)
~~~

Et comme nous l'avons vu précédemment, l'utilisation de ce filtre se fait pour configurer les classes CSS des tags HTML
affichant les commentaire et leur auteur.

~~~liquid
{%- raw -%}
<div class="{{ comment.author | comment_class_author: "comment-…", "comment-…" }}">
{% endraw -%}
~~~

### Filtres - Date

Par défaut, Jekyll utilise une locale qui n'est pas le français. Par conséquent, la méthode de formatage des dates qui
se base sur `strftime` se base sur la locale pour formater le nom des mois et les décimal des jours. Il n'est pas 
possible de formater une date en français sans jouer avec la locale. Pour me simplifier la vie, j'ai créé un filtre
pour formater une date en français. Pour être franc, je n'ai pas cherché très longtemps avant de me résoudre à créer le
filtre suivant.

~~~ruby
require 'time'

module Jekyll
  module DateFilter
    # On liste les noms des mois en français
    MONTHS = %w(
      janvier février mars avril mai juin juillet août septembre octobre novembre décembre
    )

    # La fonction du filtre qui prend une date de type string ou time
    def jp_date(date)

      # On s'assure d'avoir une date de type time
      date = Time.parse(date) if date.is_a? String

      # On extrait le jour du mois et on ajoute le texte qui
      # va bien pour le premier jour du mois
      day = date.strftime("%-d")
      formatted_day = day == "1" ? "1er" : day

      # Finalement, on assemble les morceaux pour avoir une date formatée
      "#{formatted_day} #{MONTHS[date.strftime("%m").to_i - 1]} #{date.strftime("%Y")}"
    end
  end
end

# Puis on enregistre notre filtre dans Liquid
Liquid::Template.register_filter(Jekyll::DateFilter)
~~~

Comme le filtre est assez simple et qu'au final il repose quand même sur `strftime`, ça me semble tout à fait acceptable
de maintenir ce filtre qui ne bougera sûrement jamais avant que je ne change de stack technologique.

# Tags

Il y'a un moment où de simples filtres ne suffisent pas. Une situation que j'ai rencontrée est que je voudrais ajouter
du markup HTML autour des medias que j'inclus dans mon site. Je pourrais, dans mes articles, ajouter des balises HTML 
pour se faire mais dans ce cas, je devrais répéter le processus partout. Ensuite, si j'ai le malheur de vouloir changer 
le markup ou des styles CSS sur ce markup, je dois repasser dans tous mes articles pour faire la mise à jour. C'est pas
ce que j'appelle quelque chose de pratique.

Encore une fois, Jekyll nous apporte une solution pratique à travers les 
[Tags](https://jekyllrb.com/docs/plugins/tags/#tag-blocks){:target="_blank"}. De la même manière que les filtres, ce 
n'est pas vraiment Jekyll qui nous offre cette fonctionnalité mais bel et bien Liquid. 

Un tag permet de définir un rendu d'un élément quelconque. Un tag requiert d'implémenter une fonction `render`. Ce qui 
est surtout différend par rapport à un filtre, c'est qu'un tag possède un `start` et un `end` qui marque respectivement
le début et la fin de ce sur quoi le tag va avoir de l'effet. On peut complètement comparer ça aux tags HTML qui, pour
la majorité, ont une balise ouvrante et fermante et tout ce qui est situé entre deux est compris dans ce contexte. C'est
pareil pour les tags Liquid.

### Tags - Media Cartridge

Comme discuté, j'avais besoin d'englober mes médias dans des balises HTML pour appliquer du formatage cohérent autour
d'un groupe de media affiché. Le code du tag suivant fait exactement ce travail.

~~~ruby
module Jekyll
  # Notre tag doit hériter de la classe Liquid Block
  class MediaCartridgeTag < Liquid::Block
    
    # On implémente la méthode de rendu
    def render(context)

      # Le contenu provient de la classe parente. Tout ce que l'on
      # fait ici c'est encadrer le contenu dans des balises englobantes 
      "\n<div class=\"post-media-cartridge\">\n#{super}\n</div>\n"
    end
  end
end

# On enregistre le tag dans liquid pour une utilisation dans le site
Liquid::Template.register_tag('media_cartridge', Jekyll::MediaCartridgeTag)
~~~

En ce qui concerne l'utilisation d'un tag, c'est simple. Ça ressemble à l'utilisation des `for`, `if`, … Il suffit 
d'ajouter la balise ouvrante et fermante Liquid dans les articles aux endroits souhaités. L'exempl ci-après en fait la
démonstration.

~~~liquid
{%- raw -%}
<!-- Tout ce qui se trouve entre le tag ouvrant et fermant sera inséré
     entre les balises HTML <div class="post-media-cartridge>…</div>
{%- media_cartridge -%}
...
{% include img.html
    image="IMG_0078.jpg"
    type="portrait"
    thumb_size="225x300"
    title="Chaussures détruites"
    gallery="img"
%}
...
{%- endmedia_cartridge -%}
{% endraw -%}
~~~

Ce qui au final, donne un résultat du genre.

~~~html
<!-- Cette balise div est ajoutée par le tag -->
<div class="post-media-cartridge">

  <!-- Tout le contenu de ce point jusqu'à juste avant le </div> va être mis 
       tel quel dans le code HTML de la page rendue -->
  <figure>
    <a href="/assets/images/posts/2010-11-04-journee-de-boulot/IMG_0078.jpg" 
      class="glightbox-gallery" 
      data-gallery="img" 
      data-description="Chaussures détruites">
      
      <img class="image" 
        src="/assets/images/posts/2010-11-04-journee-de-boulot/IMG_0078-225x300.jpg" 
        alt="Chaussures détruites">
    </a>
  </figure> 
</div>
~~~

# Hooks

La mécanisme des [hooks](https://jekyllrb.com/docs/plugins/hooks/){:target="_blank"} est un mécanisme puissant de 
Jekyll. Ce mécanisme permet de se brancher dans le cycle de build des objets manipulés comme les pages, les articles et
mêmes les collections. De cette manière, ça permet d'apporter un traitement avant ou après que les mécanismes de base
de Jekyll n'entrent en jeu.

Dans le cas de ce site, j'ai utilisé un hook pour modifier le comportement du rendu des emoji. En effet, en ajoutant
le plugin de pagination, je me suis rendu compte que les emoji n'étaient plus convertis en image comme c'était le cas
sans la pagination. En allant regarder le code de plus près pour la conversion des emoji, j'ai pu constater que c'est
un hook pour le rendu des pages et documents du site.

Quand on regarde de plus près le code du hook pour les emoji, on réalise deux choses. La première comme je le disais, 
c'est un hook. Ce hook ne se déclenche que lors que la page est considérée comme "emojifiable". J'utilise le plugin
[Jemoji](https://github.com/jekyll/jemoji){:target="_blank"} pour le rendu des emoji à la GitHub. Le code qui active le 
hook, et donc le plugin, dans Jekyll est le suivant.

~~~ruby
# Hook appliqué pour les pages et document après le rendu initial
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|

  # Une condition supplémentaire est vérifiée avant d'effectuer le rendu
  Jekyll::Emoji.emojify(doc) if Jekyll::Emoji.emojiable?(doc)
end
~~~

Pour être considérée comme telle, le code suivant est présent dans le plugin des emoji.

~~~ruby
# Fonction utilisée dans le hook
def emojiable?(doc)

  # Il faut qu'une page soit de type Jekyll::Page au minimum pour être
  # prise en compte par le plugin Jemoji
  (doc.is_a?(Jekyll::Page) || doc.write?) &&
    doc.output_ext == ".html" || doc.permalink&.end_with?("/")
end
~~~

Le problème, c'est que le plugin de pagination vérifie le type d'objet avant d'appliquer la conversion des emoji. Du 
coup, le plugin s'attend à des objets de type `Jekyll::Page` alors qu'en réalité pour les objets sont de type 
`Jekyll::PaginateV2::Generator::PaginationPage`.

J'en suis venu à écrire mon propre hook basé sur l'original pour pouvoir remplacer la fonction qui effectue la condition
et ainsi restaurer la conversion des emoji en image. Le code suivant est le plugin qui permet de réaliser ça.

~~~ruby
require "jemoji"

module Jekyll

  # On définit le hook basé sur la classe originale
  class PaginatedEmojiHook < Jekyll::Emoji
    class << self

      # On remplace la méthode qui détermine si l'objet à rendre permet
      # le rendu des emoji 
      def emojiable?(doc)

        # Cette méthode est utilisée dans d'autres méthodes de la classe parente
        # pour appliquer la transformation des emoji 
        doc.output_ext == "" && doc.is_a?(Jekyll::PaginateV2::Generator::PaginationPage)
      end
    end
  end
end

# Finalement, on enregistre notre hook dans Jekyll lorsque des pages ou documents
# été calculé pour le rendu.
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|

  # Et finalement on effectue la conversion des emoji si le document est éligible
  Jekyll::PaginatedEmojiHook.emojify(doc) if Jekyll::PaginatedEmojiHook.emojiable?(doc)
end
~~~

# Conclusion

Au terme de cet article qui détails toutes les modifications personnalisées que j'ai ajouté pour le rendu de mon site
static, on constate que les dites modifications ne sont pas très grandes. Bout à bout, ce n'est quand même pas aussi 
anodin que ça. Mais ce qu'il faut surtout garder à l'esprit c'est que les contenus qui sont rendus en format HTML sont
de simples fichiers `yaml`, `markdown` mais avant tout c'est des fichiers textes qui sont très facilement portables.

Malgré toutes les personnalisations apportées, mes contenus sont et restent disponibles dans leur format le plus simple
et m'apporte la sécurité de pouvoir toujours facilement les reprendre à l'avenir. Très peu de chance que dans 30 ans,
les fichiers textes soient désuets. Alors qu'une base de données, sans suivre les mises à jour, c'est pas aussi absolu.

Un autre point qui est toujours intéressant. Lorsqu'on écrit un article présentant du code, on fait en sorte que le code
se présente sous son meilleur jour. Ce processus nous force à revoir et repenser notre code, le nettoyer. En adoptant
cette démarche, on s'aperçoit souvent que le code peut être améliorer, mieux découpé, certains concepts mieux appliqués.
Et lorsque j'ai écrit cet article, ça n'a pas fait exception, j'ai presque ré-écrit l'intégralité des plugins pour 
pouvoir les présenter.