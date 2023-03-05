#!/usr/bin/env ruby

require 'fileutils'
require 'mysql2'
require 'yaml'

require "#{__dir__}/db.rb"
require "#{__dir__}/comments.rb"
require "#{__dir__}/gallery.rb"
require "#{__dir__}/smileys.rb"
require "#{__dir__}/utils.rb"

BASE_DIR = File.expand_path("#{File.dirname(__FILE__)}/..")
DOWNLOAD_PATH = File.expand_path('~/Downloads/web/japan/wp-content/uploads')

def categories_str(categories)
  categories.map do |result|
    "\"#{result['name'].gsub(/&amp;/, '&')}\""
  end
end

def front_matter(post)
  """---
layout:     post
title:      #{post[:title]}
date:       #{post[:date]}
categories: [#{post[:categories]}]
---

"""
end

def sanitize_post_content(content)
  lines = smileys(content)
    .split("\n")
    .map(&:strip)
    .reject(&:empty?)
    .map do |line|
      case line
      when /<p.*?><a/
        line.gsub(%r{(<p.*?>|</p>)}, '')
      when /^\w/
        word_wrap line
      when /<p.*?>/
        word_wrap line.gsub(%r{(<p.*?>|</p>)}, '')
      else
        line
      end
    end

  lines
    .join("\n\n")
    .gsub(%r{<hr( /)?>}, "-----\n")
    .gsub("\\'", "'")
    .gsub(/(\\)?&#039;/, "'")
    .gsub(/(\d+)\s*?[yY][eE][nN]/, '\\1¥')
    .gsub(/ {2,}/, ' ')
    .gsub(/: \)/, ':)')
end

def create_image_file(post, img_name, extension, title, width, height)
  orientation = %w[225 200].include?(width) ? 'portrait' : 'landscape'

  thumb = "#{width}x#{height}"

  files = %W[#{img_name}#{extension} #{img_name}-#{thumb}#{extension}]

  if ENV['J_DRY_RUN']
    p "Create destination directory (if required): #{post[:images_path]}"
  else
    Dir.mkdir(post[:images_path]) unless Dir.exist? post[:images_path]
  end

  files.each do |file|
    source_path = "#{DOWNLOAD_PATH}/#{post[:download_image_subpath]}/#{file}"

    if ENV['J_DRY_RUN']
      p "Source file: #{source_path}"
    else
      FileUtils.mv(source_path, post[:images_path]) if File.exist? source_path
    end
  end

  """
{% include img.html
    image=\"#{img_name}#{extension}\"
    type=\"#{orientation}\"
    thumb_size=\"#{thumb}\"
    title=\"#{title}\"
    gallery=\"img\"
%}

"""
end

def create_media_file(post, media_name, extension, title)
  file = "#{media_name}#{extension}"

  if ENV['J_DRY_RUN']
    p "Create destination directory (if required): #{post[:media_path]}"
  else
    Dir.mkdir(paths[:media_path]) unless Dir.exist? post[:media_path]
  end

  source_path = "#{DOWNLOAD_PATH}/#{post[:download_image_subpath]}/#{file}"

  if ENV['J_DRY_RUN']
    p "Source file: #{source_path}"
  else
    FileUtils.mv(source_path, post[:media_path]) if File.exist? source_path
  end

  """
{% include media.html
    media=\"#{media_name}.mp4\"
    title=\"#{title}\"
    gallery=\"video\"
%}

"""
end

def process_media(content, post)
  sanitized_blocks = content.scan(%r{<a.*/a>}).map do |a_block|
    {
      original: a_block,
      list: a_block.gsub(%r{</a><a}, "</a>\n<a").split("\n")
    }
  end

  sanitized_blocks.each do |block|
    block[:list].each do |elem|
      elem.scan(%r{<a href=".*/(.*?)(.jpg)"><img .*?title="(.*?)" .*?width="(\d+)".*?</a>}).each do |image|
        height = elem.gsub(/.*?height="(\d+)".*/, '\\1')
        image << height
        media_str = create_image_file paths, post, *image
        content = content.sub(elem, media_str)
      end

      elem.scan(%r{<a href=".*/(.*?)(.mpg)">(.*?)</a>}).each do |media|
        media_str = create_media_file paths, post, *media
        content = content.sub(elem, media_str)
      end
    end
  end

  content
end

def process_gallery(content)
  content.scan(/\[(?:ng)?gallery(?:=| id=)(\d+)\]/).each do |gallery_match|
    gallery_str = gallery gallery_match[0]
    content = content.gsub(/\[(ng)?gallery(=| id=)(\d+)\]/, gallery_str)
  end

  content
end

def retrieve_post(name)
  client = db_client

  statement_post = client.prepare("""
SELECT
  *
FROM
  wpjapan_posts
WHERE
  post_name = ?
  and post_status = 'publish';
""")

  result_post = statement_post.execute(name).first
  post_id = result_post['ID']

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
	p.ID = ?
	and p.post_status = 'publish';
""")

  year = result_post['post_date'].strftime('%Y')
  month = result_post['post_date'].strftime('%m')
  short_date = result_post['post_date'].strftime('%Y-%m-%d')

  {
    id: post_id,
    name: name,
    date: result_post['post_date'],
    short_date: short_date,
    formatted_date: result_post['post_date'].strftime('%Y-%m-%d %H:%M:%S %z'),
    title: result_post['post_title'],
    content: result_post['post_content'],
    categories: categories_str(statement_categories.execute(post_id)).join(", "),
    path: "_posts/#{short_date}-#{name}.md",
    images_path: "#{BASE_DIR}/assets/images/posts/#{short_date}-#{name}",
    media_path: "#{BASE_DIR}/assets/media/posts/#{short_date}-#{name}",
    download_image_subpath: "#{year}/#{month}"
  }
end

def post(name)
  post = retrieve_post name

  front_matter = front_matter post

  post_content = sanitize_post_content post[:post_content]
  post_content = process_media post_content, post
  post_content = process_gallery post_content

  post_content = post_content.gsub(/\n{2,}/, "\n\n")

  full_content = "#{front_matter}#{post_content}"

  if ENV['J_DRY_RUN']
    p """#################### Post
File path: #{post[:path]}
Content: #{full_content}
    """
  else
    File.open(post[:path], 'w') { |file| file.write(full_content) }
  end

  comments post[:name], post[:id], post[:date]
end

post ARGV[0]
