---
layout:     post
title:      Le Stack Technologique - Partie 2
date:       2023-02-16 22:28:00 +0100
categories: ["Général"]
---

Lorsque j'ai convertit mes articles WordPress vers mon site static, je voulais récupérer les commentaires. Certains 
diront que ce n'est pas forcément très important mais j'estime que ça fait partie de mon patrimoine émotionnel, de mes
souvenirs. C'est des moments précieux de mon aventure japonaise. Relire mes articles puis relire les commentaires me
rappellent de bons et moins bons souvenirs mais ça fait partie de mon être.

<!--more-->

Jekyll offre un mécanisme de base appelé [collections](https://jekyllrb.com/docs/collections/){:target="_blank"}. Cela
permet d'organiser des jeux de données sous forme d'une sorte de base de données qui ensuite sont chargées en mémoires 
et automatiquement disponibles pour la génération des pages du site. On peut même générer des pages de collections
automatiquement via ce mécanisme.

# Commentaires

C'est un bon exemple de contenus qui se prête à être traiter en mode collection. La particularité vient du fait que
chaque article à son propre sous-ensemble de commentaires. Mais ça tombe bien, parce que Jekyll organise les collections
en fonction de contenus présents dans des fichiers `yaml`. Pour être plus précis, Jekyll considère comme un même type de 
collection tous les documents présents dans un répertoire.

Pour les commentaires, il s'agit du répertoire `_data/comments`. Dans ce répertoire se trouve des fichiers qui ont le
même nom que les fichiers markdown de mes articles. La correspondance 1:1 entre le nom de fichier d'un article et le
nom de fichier de ses commentaires est bien entendu faite à dessein. Par convention, si une collection de commentaires
existe pour un article donné, alors c'est qu'il y a un commentaire ou plus. Autrement, il n'y a pas de commentaires pour
l'article en question.

Grace à ce mécanisme, il est facile ensuite d'écrire le rendu des commentaires comme l'exemple ci-dessous:

~~~liquid
{%- raw -%}
<!-- Retrieve the collection comments collection name -->
{% assign comment_file = page.name | remove: '.md' %}

<!-- Check if there are comments for the article -->
{% if site.data.comments[comments_file] %}
<section class="comments">
...
</section>
{%- endif -%}
{% endraw -%}
~~~

Quand à la structure d'un commentaire, l'exemple suivant en donne un exemple. Chaque commentaire est constitué de 3
champs:

- `author` L'auteur du commentaire
- `date` Date et heure quand le commentaire a été posté
- `text` Le texte du commentaire

~~~yaml
- author: Prevole
  date: '2008-06-30 13:19:38 +0200'
  text: |
    Le texte du commentaire qui va bien
~~~

Jekyll load automatiquement les structure `yaml` et les mets à disposition comme des objets sont faciles à exploiter.
L'exemple suivant montre l'utilisation d'un commentaire dans le rendu des commentaires d'un article. On y voit la
structure d'un commentaire et la boucle qui est faite pour parcourir tous les commentaires de l'article.

~~~liquid
{%- raw -%}
<!-- Loop to iterate over the post comments -->
{%- for comment in site.data.comments[comments_file] -%}

<!-- Custom filter to vary the CSS style when the comment is posted by the post author -->
<section class="comment {{ comment | comment_class_author: "", "comment-owner" }}">
  <div class="{{ comment | comment_class_author: "comment-m…", "comment-o…" }}">
    <div class="comment-meta-icon">...</div>
    <div class="comment-meta">
      # Access to the fields author and date of the comment. For the date, 
      # we apply a custom filter
      <p class="comment-author">{{ comment.author }}</p>
      <p class="comment-date">{{ comment.date | format_dt }}</p>
    </div>
  </div>
  <div class="{{ comment | comment_class_author: "comment-c…", "comment-o…" }}">

    <!-- Show the comment's content and apply Liquid filters 
         (the last one is a custom filter) -->
    {{ comment.text | markdownify | comment_reply_to }}
  </div>
</section>
{%- endfor -%}

{% endraw -%}
~~~

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

~~~yaml
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
~~~

Jekyll load la collection de données des galeries de la même manière que les commentaires. De cette manière, je me
retrouve avec l'objet `site.data.galleries` avec toutes les galeries du site. Je n'ai plus qu'à y accéder par leur
nom qui correspond au nom du fichier sans l'extension. Il est dès lors facile de créer un bout de code HTML avec Liquid
pour rendre la galerie dans un article. Le code suivant est celui originellement utilisé au moment de l'écriture de cet
article. Il s'agit du fichier `_includes/gallery.html`.

~~~liquid
{%- raw -%}
<ul class="image-gallery">
  <!-- Retrieve the gallery data based on gallery name (the include prefix
       means we have the following code in an _include HTML file) -->
  {% assign gallery = site.data.galleries[include.gallery] %}

<!-- We iterate over each image present in the gallery data -->
{% for image in gallery.images %}

<!-- We extract the image name to create kind of unique id -->
{%- assign image_name = (image.file | split: ".")[0]  %}
  <li>
    <!-- Part of the following code is realted to glightbox to present galleries -->
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
{% endraw -%}
~~~

Pour exploiter cet include dans mes articles, voici le code Liquid nécessaire. A nouveau, l'article contient un bout
de customisation Liquid mais c'est relativement faible et facile à parser le jour où il faudra changer de moteur de
site static. L'information reste finalement assez facile et structurée.

~~~liquid
{%- raw -%}
{% include gallery.html gallery="tokyo-roppongi-itchome-view" %}
{% endraw -%}
~~~
