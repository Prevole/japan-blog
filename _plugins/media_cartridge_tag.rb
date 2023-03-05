module Jekyll
  class MediaCartridgeTag < Liquid::Block
    def render(context)
      "\n<div class=\"post-media-cartridge\">\n#{super}\n</div>\n"
    end
  end
end

Liquid::Template.register_tag('media_cartridge', Jekyll::MediaCartridgeTag)
