#!/usr/bin/env ruby

require 'fileutils'
require 'mysql2'
require 'yaml'

require "#{File.expand_path(File.dirname(__FILE__))}/db.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/comments.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/gallery.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/smilleys.rb"

LINE_WIDTH = 115
BREAK_SEQUENCE = "\n"

# https://github.com/rails/rails/blob/7c70791470fc517deb7c640bead9f1b47efb5539/actionview/lib/action_view/helpers/text_helper.rb#L264
def word_wrap(text)
  text.split("\n").collect! do |line|
    line.length > LINE_WIDTH ? line.gsub(/(.{1,#{LINE_WIDTH}})(\s+|$)/, "\\1#{BREAK_SEQUENCE}").rstrip : line
  end * BREAK_SEQUENCE
end

def categories_str(categories)
  categories.map do |result|
    "\"#{result["name"].gsub(/&amp;/, "&")}\""
  end
end

def front_matter(title, date, categories)
  """---
layout:     post
title:      #{title}
date:       #{date}
categories: [#{categories}]
---

"""
end

def sanitize_post_content(content)
  lines = content
    .split("\n")
    .map { |line| line.strip }
    .select { |line| line.length > 0 }
    .map do |line|
      if line =~ /<p.*?><a/
        line.gsub(/(<p.*?>|<\/p>)/, "")
      elsif line =~ /^\w/
        word_wrap line
      elsif line =~ /<p.*?>/
        word_wrap line.gsub(/(<p.*?>|<\/p>)/, "")
      else
        line
      end
    end

  content = lines.join("\n\n")

  smilleys(content)
    .gsub(/<hr( \/)?>/, "-----\n")
    .gsub("\\'", "'")
    .gsub(/(\\)?&#039;/, "'")
    .gsub(/(\d+)\s*?[yY][eE][nN]/, "\\1¥")
    .gsub(/ {2,}/, " ")
    .gsub(/: \)/, ":)")
  #.gsub(/(\n){3,}?/, "\n\n")

  #.gsub(/(:[a-z_]+:)[a-z_]+:/, "\\1")
end

def create_image_file(paths, short_date, name, img_name, extension, title, width)
  if width == "225"
    orientation = "portrait"
    thumb = "225x300"
  else
    orientation = "landscape"
    thumb = "300x225"
  end

  files = %W[#{img_name}#{extension} #{img_name}-#{thumb}#{extension}]

  replacement = """
<!-- /assets/images/#{short_date}-#{name}/#{img_name}#{extension} -->
{% include img.html
    image=\"#{img_name}#{extension}\"
    type=\"#{orientation}\"
    title=\"#{title}\"
    gallery=\"img\"
%}

"""

  if files.count > 0
    if ENV["J_DRY_RUN"]
      p "Create destination directory (if required): #{paths[:images_file_path]}"
    else
      Dir.mkdir(paths[:images_file_path]) unless Dir.exist? paths[:images_file_path]
    end

    files.each do |file|
      source_path = "#{paths[:download_path]}/#{paths[:download_image_subpath]}/#{file}"

      if ENV["J_DRY_RUN"]
        p "Source file: #{source_path}"
      else
        FileUtils.mv(source_path, paths[:images_file_path]) if File.exist? source_path
      end
    end
  end

  replacement
end

def create_media_file(paths, short_date, name, media_name, extension, title)
  files = ["#{media_name}#{extension}"]

  replacement = """
<!-- /assets/media/#{short_date}-#{name}/#{media_name}.mp4 -->
{% include media.html
    media=\"#{media_name}.mp4\"
    title=\"#{title}\"
    gallery=\"video\"
%}

"""

  if files.count > 0
    if ENV["J_DRY_RUN"]
      p "Create destination directory (if required): #{paths[:media_file_path]}"
    else
      Dir.mkdir(paths[:media_file_path]) unless Dir.exist? paths[:media_file_path]
    end

    files.each do |file|
      source_path = "#{paths[:download_path]}/#{paths[:download_image_subpath]}/#{file}"

      if ENV["J_DRY_RUN"]
        p "Source file: #{source_path}"
      else
        FileUtils.mv(source_path, paths[:media_file_path]) if File.exist? source_path
      end
    end
  end

  replacement
end

def process_media(content, short_date, name, paths)
  sanitized_blocks = content.scan(/<a.*\/a>/).map do |a_block|
    {
      :original => a_block,
      :list => a_block.gsub(/<\/a><a/, "</a>\n<a").split("\n")
    }
  end

  sanitized_blocks.each do |block|
    block[:list].each do |elem|
      elem.scan(/<a href=".*\/(.*?)(.jpg)"><img .*?title="(.*?)" .*?width="(\d+)".*?<\/a>/).each do |image|
        media_str = create_image_file paths, short_date, name, *image
        content = content.sub(elem, media_str)
      end

      elem.scan(/<a href=".*\/(.*?)(.mpg)">(.*?)<\/a>/).each do |media|
        media_str = create_media_file paths, short_date, name, *media
        content = content.sub(elem, media_str)
      end
    end
  end

  content
end

def process_gallery(content)
  content.scan(/\[gallery=(\d+)\]/).each do |gallery_match|
    gallery_str = gallery gallery_match[0]
    content = content.gsub(/\[gallery=\d+\]/, gallery_str)
  end

  content
end

base_dir = File.expand_path("#{File.dirname(__FILE__)}/..")
download_path = File.expand_path("~/Downloads/web/japan/wp-content/uploads")

post_name = ARGV[0]

client = db_client

statement_post = client.prepare("""
SELECT
  *
FROM
  wpjapan_posts
WHERE
  post_name = ? and post_status = 'publish';
""")

result_post = statement_post.execute(post_name).first

statement_categories = client.prepare("""
SELECT
	t.*
FROM
	wpjapan_terms AS t
LEFT JOIN
	wpjapan_term_relationships AS tr ON t.term_id = tr.term_taxonomy_id
LEFT JOIN
	wpjapan_posts AS p ON tr.object_id = p.ID
WHERE
	post_name = ?
	and post_status = \"publish\";
""")
result_categories = categories_str statement_categories.execute(post_name)

post_year = result_post["post_date"].strftime("%Y")
post_month = result_post["post_date"].strftime("%m")
post_short_date = result_post["post_date"].strftime("%Y-%m-%d")
post_date = result_post["post_date"].strftime("%Y-%m-%d %H:%M:%S %z")
post_file_path = "_posts/#{post_short_date}-#{post_name}.md"

paths = {
  :images_file_path => "#{base_dir}/assets/images/posts/#{post_short_date}-#{post_name}",
  :media_file_path => "#{base_dir}/assets/media/posts/#{post_short_date}-#{post_name}",
  :download_image_subpath => "#{post_year}/#{post_month}",
  :download_path => download_path
}

front_matter = front_matter result_post["post_title"], post_date, result_categories.join(", ")

post_content = sanitize_post_content result_post["post_content"]
post_content = process_media post_content, post_short_date, post_name, paths
post_content = process_gallery post_content

post_content = post_content.gsub(/\n{2,}/, "\n\n")

full_content = "#{front_matter}#{post_content}"

if ENV["J_DRY_RUN"]
  p """#################### Post
File path: #{post_file_path}
Content: #{full_content}
"""
else
  File.open(post_file_path, "w") { |file| file.write(full_content) }
end

comments post_name
