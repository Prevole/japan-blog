require 'yaml'

module AddTagsCountPlugin
  class Generator < Jekyll::Generator
    def generate(site)
      site.posts.docs.each do |post|
        post_tech_name = File.basename(post.path).gsub(/\..*/, "")
        comments_file_path = "_data/comments/#{post_tech_name}.yaml"
        comments = YAML.load_file(comments_file_path) if File.exist? comments_file_path
        post.data[:comments_count] = comments.length unless comments.nil?
      end
    end
  end
end
