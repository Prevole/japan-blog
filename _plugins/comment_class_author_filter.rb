module Jekyll
  module CommentClassAuthorFilter
    def comment_class_author(author, base_class, class_if_author)
      if author == @context.registers[:site].config['japan']['author']
        "#{base_class} #{class_if_author}"
      else
        base_class
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::CommentClassAuthorFilter)