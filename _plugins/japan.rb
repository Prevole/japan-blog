require 'time'

module Jekyll
  module JapanFilter
    MONTHS = %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)

    def format_dt(input, front_word = "Posté")
      input = Time.parse(input) if input.is_a? String

      day = input.strftime("%-d")
      formatted_day = day == "1" ? "1er" : day

      (
        "<span class=\"hide-small\">#{front_word} le </span>#{formatted_day} #{MONTHS[input.strftime("%m").to_i - 1]} #{input.strftime("%Y")}<span class=\"hide-small\">&nbsp;à&nbsp;</span>" +
        "<span class=\"hide-big\">,&nbsp;</span>#{input.strftime("%k")}:#{input.strftime("%M")}"
      ).gsub("  ", " ")
    end

    def comment_str(input)
      if input[:comments_count].nil?
        ""
      else
        "<span> | <a href=\"#{input[:url]}#comments\"><span><svg class=\"icon icon-bubbles4\"><use xlink:href=\"#icon-bubbles4\"></use></svg></span>#{input[:comments_count]} commentaire#{input[:comments_count].to_i > 1 ? "s" : ""}</a></span>"
      end
    end

    def time_to_read(input)
      plural = input == 1 ? "" : "s"
      "#{input} minute#{plural}<span class=\"hide-small\"> de lecture</span>"
    end

    def comment_class_author(input, base_class, class_if_author)
      cls = base_class
      cls = "#{cls} #{class_if_author}" if input["author"] == "Prevole"
      cls
    end

    def comment_reply_to(input)
      input.gsub(/@(.*?)\s*:/, "<span class=\"comment-reply-to\">\\1</span>")
    end
  end

  class MediaCartridgeBlock < Liquid::Block
    def render(context)
      text = super
      "\n<div class=\"post-media-cartridge\">\n#{text}\n</div>\n"
    end
  end
end

Liquid::Template.register_filter(Jekyll::JapanFilter)
Liquid::Template.register_tag('media_cartridge', Jekyll::MediaCartridgeBlock)
