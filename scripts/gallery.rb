require 'yaml'
require 'mysql2'

require "#{File.expand_path(File.dirname(__FILE__))}/db.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/smilleys.rb"

def sanitize_title(title)
  smilleys(
    title
      .strip
      .gsub("\\'", "'")
      .gsub(/(\\)?&#039;/, "'")
  )
  .gsub(/(:[a-z_]+:)[a-z_]+:/, "\\1")
  .gsub("...", "…")
end

def gallery_to_yaml(gallery)
  gallery
    .to_yaml(line_width: 110)
    .gsub(/title: (>-\n {4})?/, "title: |\n    ")
    .gsub(/(\s+thumb:\s.*)/, "\\1\n")
    .gsub(/---\n/, "")
    .gsub(/^\s{4}'/, "    ")
    .gsub(/:'\n/, ":\n")
    .gsub(/''/, "'")
    .gsub(/(\s{4})"/, "\\1")
    .gsub(/"(\n)/, "\\1")
    .gsub(/(\/.*?\.[jJ][pP][gG])/, "\\1\"")
end

def gallery(gallery_id)
  download_path = File.expand_path"~/Downloads/web 2/japan/wp-content/gallery"
  base_dir = File.expand_path("#{File.dirname(__FILE__)}/..")

  client = db_client

  statement_gallery = client.prepare("""
SELECT
  *
FROM
  wpjapan_ngg_gallery
WHERE
  gid = ?;
""")

  result_gallery = statement_gallery.execute(gallery_id).first

  gallery_name = result_gallery["name"]

  gallery_source_path = "#{download_path}/#{gallery_name}"
  gallery_relative_dest_path = "/assets/images/galleries/#{gallery_name}"
  gallery_dest_path = "#{base_dir}/assets/images/galleries/"
  gallery_dest_full_path = "#{gallery_dest_path}/#{gallery_name}"
  gallery_data_path = "#{base_dir}/_data/galleries/#{gallery_name}.yaml"

  if ENV["J_DRY_RUN"]
    p """
Source gallery: #{gallery_source_path}
Destination gallery: #{gallery_dest_path}
"""
  else
    FileUtils.mv(gallery_source_path, gallery_dest_path) if Dir.exist?(gallery_source_path)
  end

  if Dir.exist?("#{gallery_dest_full_path}")
    gallery_current_path = gallery_dest_full_path
  else
    gallery_current_path = gallery_source_path
  end

  statement_images = client.prepare("""
SELECT
  *
FROM
  wpjapan_ngg_pictures
WHERE
  galleryid = ?
ORDER BY
  imagedate ASC;
""")

  result_images = statement_images.execute(gallery_id)

  images_hash = {}
  result_images.each do |row|
    title = sanitize_title row["alttext"]

    images_hash[row["filename"]] = {
      "title" => "#{title}",
      "date" => row["imagedate"].strftime("%Y-%m-%d %H:%M:%S %z")
    }
  end

  files = Dir
    .entries(gallery_current_path)
    .reject{|f| f == ".DS_Store"}
    .select { |f| File.file? File.join(gallery_current_path, f) }
    .sort

  images = []

  files.each do |file_name|
    images << {
      **images_hash[file_name],
      "file" => file_name,
      "path" => File.join("", gallery_relative_dest_path, file_name),
      "thumb" => File.join("", gallery_relative_dest_path, "thumbs", "thumbs_#{file_name}")
    }
  end

  gallery = {
    "name" => result_gallery["title"],
    "date" => result_images.first["imagedate"].strftime("%Y-%m-%d %H:%M:%S %z"),
    "images" => images
  }

  yaml_content = gallery_to_yaml gallery

  if ENV["J_DRY_RUN"]
    p """
Gallery: #{gallery_name}
Content: #{yaml_content}
"""
  else
    File.open(gallery_data_path, "w") { |file| file.write(yaml_content) }
  end

  "{% include gallery.html gallery=\"#{gallery_name}\" %}"
end