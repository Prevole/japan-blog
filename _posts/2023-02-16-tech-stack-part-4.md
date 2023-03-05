---
layout:     post
title:      Le Stack Technologique - Partie 4
date:       2023-02-16 22:26:00 +0100
categories: ["Général"]
---

Pendant la rédaction de mon 4ème article technique, j'ai voulu ajouté une note de texte au milieu de mon article pour
augmenter l'emphase du texte. Au départ, j'aurai voulu utiliser une extension du markdown pour pouvoir écrire mon texte
de manière aussi peu formatée que possible mais ça n'était pas si simple. J'en suis venu à créer un block tag Liquid
pour obtenir le résultat souhaité.

<!--more-->

Comme je l'ai dit plus haut, j'ai cherché à étendre markdown (et surtout le moteur de parsing et rendu kramdown) pour
ajouter ce que l'on nomme `admonitions`. Avant de poursuivre, voici ce que c'est.

{% admonition info "Hello" %}
World!
{% endadmonition %}

Ce qui se traduit par ce qui suit dans mes articles.

~~~liquid
{% raw %}
{% admonition info "Hello" %}
World!
{% endadmonition %}
{% endraw %}
~~~

Où je travaille actuellement, nous utilisons beaucoup le langage Python dans mon équipe et du coup, les outils sont 
majoritairement basés sur ce langage. J'ai mis en place des sites statiques à base de 
[mkdocs](https://www.mkdocs.org/){:target="_blank"} avec le thème 
[material for mkdocs](https://squidfunk.github.io/mkdocs-material/){:target="_blank"}. Dans ce thème, qui est très 
orienté documentation technique, on y trouve des 
[admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/#supported-types){:target="_blank"}. Je
trouve très pratique cette manière de mettre en avant des informations que l'on estime plus importantes que d'autres.

N'ayant pas le courage de trop creuser dans le parser Kramdown, je me suis à nouveau tourner vers un plugin Liquid. Un
block tag pouvait faire parfaitement l'affaire au prix de mettre un peu plus de markup dans mes articles. A nouveau,
j'ai estimé que l'effort, la plus value et le résultat étaient plus importants que la maintenance potentielle. Et faut
aussi dire, que le petit challenge technique qui allait en découdre n'était pas pour me déplaire.

Pourquoi un challenge technique ? Et bien tout simplement que je ne voulais pas mélanger présentation et processing dans
la partie code Ruby. J'aime la séparation dans les générateurs de site statiques entre la logique pour construire le 
site et la couche de présentation. J'ai vu beaucoup d'exemple de plugin Liquid et j'en ai codé moi même qui avait en dur
dans le code la partie templating de l'élément rendu.

Je suis parvenu, aux termes de quelques efforts, à séparer logique de génération et rendu HTML. Sans attendre plus 
longtemps, le plugin Liquid.

~~~ruby
module Jekyll
  class AdmonitionTag < Liquid::Block
    # Initialisation de l'objet en récupérant les arguments {% raw %}{% <tag> <arg1> <arg2> ... %}{% endraw %}
    def initialize(tag_name, markup, tokens)
      super

      # La suite des arg1..n se retrouve comme une seule chaîne de caractère dans markup
      args = markup.split(' ')

      # On force le type d'admonition en minuscules
      @admonition_type = args[0].downcase

      # On récupère le titre si présent sinon on utilise le type
      @admonition_title = args[1].nil? ? @admonition_type.capitalize : args[1..].join(' ').gsub(/"/, '')
    end

    # La fonction de rendu
    def render(context)
      # On load à la volée le template et les icônes. En mode production
      # on garde en cache ce qui a été loadé alors qu'en dev on reload 
      # chaque fois.
      if ENV['JEKYLL_ENV'] != 'production' || !@@admonition_template
        load_template context 
        load_icons context
      end
      
      # On applique le rendu du template Liquid et on applique
      # le rendu Kramdown au contenu de l'admonition. 
      @@admonition_template.render(
        
        # On construit le contexte avec les variables qui vont être
        # dans le template.  
        {
          'title' => @admonition_title,
          'type' => @admonition_type,
          'icon' => @@admonition_icons[@admonition_type],
          'content' => Kramdown::Document.new(super,{remove_span_html_tags:true}).to_html
        }
      )
    end

    private

    def load_template(context)
      # L'emplacement du fichier de template est spécifier dans la configuration
      # pour éviter de devoir spécifier son emplacement dans chaque tag.
      @@admonition_file = File.read(
        File.expand_path(
          context.registers[:site].config['admonition']['template']
        )
      )
      
      # On prépare le template Liquid
      @@admonition_template = Liquid::Template.parse(@@admonition_file)
    end

    def load_icons(context)
      # L'affichage repose en partie sur des icônes SVG qui vont être écrite
      # complètement dans le HTML pour chaque admonition. Pour le stockage,
      # elles sont dans un répertoire dédié sous de fichiers SVG. La config
      # du site permet de retrouver l'emplacement des icônes. 
      icon_folder = context.registers[:site].config['admonition']['icons']
      @@admonition_icons = Dir
        # On récupère la liste des fichiers SVG
        .glob(File.expand_path("#{icon_folder}/*.svg"))
        
        # On transforme liste des fichier en tableau associant nom de 
        # l'admonition et le contenu SVG du fichier.
        .map {|file| [file.gsub(%r{.*/(.*)\.svg}, '\\1'), File.read(file)] }
        
        # On convertit le tableau de tableau en map ([["note", "<svg..."], 
        # ["info", "<svg..."]]) -> { "note" => "<svg...", "info" => "<svg..."}
        .to_h
    end
  end
end

# Et comme pour les plugins précédents, on enregistre notre plugin dans Liquid
Liquid::Template.register_tag('admonition', Jekyll::AdmonitionTag)
~~~

Et finalement, le template que j'utilise qui contient les variables préparées dans le plugin.

~~~html
{% raw %}
<div class="admonition {{ type }}">
  <div class="admonition-title">
    <div class="admonition-title-icon">
      {{ icon }}
    </div>
    <p class="admonition-title-text">{{ title }}</p>
  </div>
  <div class="admonition-content">
    {{ content }}
  </div>
</div>
{% endraw %}
~~~

Pour finir, voici la petite configuration ajoutée dans la configuration du site.

~~~yaml
admonition:
  template: _includes/admonition.html
  icons: resources/admonition-icons
~~~

Encore une fois, il a fallut choisir entre customisation et non customisation au prix d'un peu de code dans mes
articles. Je pense être parvenu à un bon compromis car mes articles contiennent peu de markup et celui-ci reste facile
à parser pour le transformer en autre chose le cas échéant.

En passant, j'ai également ajouté le support pour [mermaidjs](https://mermaid.js.org/){:target="_blank"} ce qui me 
permet d'inclure des diagrammes dans articles. Pour ajouter le support de mermaid, j'ai simplement inclus le code HTML
suivant dans le layout principal de mon site static.

~~~html
<script type="module">
  import mermaid from "assets/js/mermaid.esm.min.mjs";
  mermaid.initialize({
    startOnLoad:true,
    theme: "dark",
  });
  mermaid.init(undefined, document.querySelectorAll('.language-mermaid'));
</script>
~~~

Ensuite, il me suffit simplement d'écrire dans mes articles des block de code comme ci-dessous.

~~~markdown
~ ~ ~mermaid
erDiagram
  POSTS {
    int ID
    string post_name
    string post_status
    string post_title
    string post_content
    date post_date
  }
  …
~ ~ ~
~~~

{% admonition warning %}
L'exemple markdown ci-dessus contient des espaces entre les `~` mais en réalité, il n'y en a pas dans mes articles. Ici,
j'ai été obligé d'en mettre pour éviter les problèmes de double parsing et autres petits problèmes de rendu. 
{% endadmonition %}

Je découvre `mermaid` et ne suis pas encore très rôdé avec mais j'aime beaucoup l'idée d'avoir un moyen de décrire 
textuellement des diagrammes et de les stocker directement dans mes articles.