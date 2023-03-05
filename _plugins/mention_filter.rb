module Jekyll
  module MentionFilter

    def mention(input)
      input.gsub(/@(.*?)\s*:/, "<span class=\"comment-reply-to\">\\1</span>")
    end
  end
end

Liquid::Template.register_filter(Jekyll::MentionFilter)
