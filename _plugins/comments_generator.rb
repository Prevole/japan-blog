module Jekyll
  class CommentsGenerator < Jekyll::Generator
    def generate(site)
      site.posts.docs.each do |post|
        post_tech_name = File.basename(post.path).gsub(/\..*/, "")

        comments = site.data["comments"][post_tech_name]

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
