require 'time'

module Jekyll
  module JapanFilter
    MONTHS = %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)

    def format_dt(input, front_word = "Posté")
      input = Time.parse(input) if input.is_a? String

      day = input.strftime("%-d")
      formatted_day = day == "1" ? "1er" : day

      (
        "#{front_word} le #{formatted_day} #{MONTHS[input.strftime("%m").to_i - 1]} #{input.strftime("%Y")} à " +
        "#{input.strftime("%k")}:#{input.strftime("%M")}"
      ).gsub("  ", " ")
    end

    def comment_str(input)
      if input[:comments_count].nil?
        ""
      else
        "<span> | <a href=\"#{input[:url]}#comments\">#{input[:comments_count]} commentaire#{input[:comments_count].to_i > 1 ? "s" : ""}</a></span>"
      end
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
