module Jekyll
  class ReadTimeGenerator < Jekyll::Generator
    include Liquid::StandardFilters

    def generate(site)
      site.posts.docs.each do |post|
        total_words = get_plain_text(post.content).split.size
        post.data["read_time"] = (total_words / 300.0).ceil
      end
    end

    def get_plain_text(input)
      strip_html(strip_pre_tags(input))
    end

    def strip_pre_tags(input)
      input.to_s.gsub(/<pre.*?>(.*)<\/pre>/mi, "\\1")
    end
  end
end
