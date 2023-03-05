
module Jekyll
  class AdmonitionTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super

      args = markup.split(' ')

      @admonition_type = args[0].downcase
      @admonition_title = args[1].nil? ? @admonition_type.capitalize : args[1..-1].join(' ').gsub(/"/, '')
    end

    def render(context)
      if ENV['JEKYLL_ENV'] != 'production' || !defined?(@@admonition_template)
        load_template context
        load_icons context
      end

      @@admonition_template.render({
        'title' => @admonition_title,
        'type' => @admonition_type,
        'icon' => @@admonition_icons[@admonition_type],
        'content' => Kramdown::Document.new(super,{remove_span_html_tags:true}).to_html
      })
    end

    private

    def load_template(context)
      @@admonition_file = File.read(File.expand_path(context.registers[:site].config['admonition']['template']))
      @@admonition_template = Liquid::Template.parse(@@admonition_file)
    end

    def load_icons(context)
      icon_folder = context.registers[:site].config['admonition']['icons']
      @@admonition_icons = Dir
        .glob(File.expand_path("#{icon_folder}/*.svg"))
        .map {|file| [file.gsub(%r{.*/(.*)\.svg}, '\\1'), File.read(file)] }
        .to_h
    end
  end
end

Liquid::Template.register_tag('admonition', Jekyll::AdmonitionTag)
