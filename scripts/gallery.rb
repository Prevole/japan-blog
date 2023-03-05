require 'yaml'
require 'mysql2'

require "#{__dir__}/db.rb"
require "#{__dir__}/smileys.rb"

DOWNLOAD_PATH = File.expand_path '~/Downloads/web 2/japan/wp-content/gallery'
BASE_DIR = File.expand_path("#{File.dirname(__FILE__)}/..")
DATE_FORMAT = '%Y-%m-%d %H:%M:%S %z'.freeze

def sanitize_title(title)
  smilleys(
    title
      .strip
      .gsub("\\'", "'")
      .gsub(/(\\)?&#039;/, "'")
  )
  .gsub(/(:[a-z_]+:)[a-z_]+:/, '\\1')
  .gsub('...', '…')
end

def gallery_to_yaml(gallery)
  gallery
    .to_yaml(line_width: 110)
    .gsub(/title: (>-\n {4})?/, "title: |\n    ")
    .gsub(/(\s+thumb:\s.*)/, "\\1\n")
    .gsub(/---\n/, '')
    .gsub(/^\s{4}'/, '    ')
    .gsub(/:'\n/, ":\n")
    .gsub(/''/, "'")
    .gsub(/(\s{4})"/, '\\1')
    .gsub(/"(\n)/, '\\1')
    .gsub(%r{(/.*?\.[jJ][pP][gG])}, '\\1"')
end

def gallery(id)
  name, title = extract_gallery_name id

  source_path = "#{DOWNLOAD_PATH}/#{name}"
  site_path = "/assets/images/galleries/#{name}"
  dest_path = "#{BASE_DIR}/assets/images/galleries/"
  files_path = "#{dest_path}/#{name}"
  data_path = "#{BASE_DIR}/_data/galleries/#{name}.yaml"

  if ENV['J_DRY_RUN']
    p """
Source gallery: #{source_path}
Destination gallery: #{dest_path}
    """
  else
    FileUtils.mv(source_path, dest_path) if Dir.exist?(source_path)
  end

  gallery_images id, name, title, site_path, data_path, files_path
end

def gallery_images(id, name, title, site_path, data_path, files_path)
  first_date, extracted_images = extract_images id

  files = Dir.glob('*.JPG', files_path).sort

  images = files.map do |file_name|
    {
      **(extracted_images[file_name].nil? ? { 'title' => 'n/a', 'date' => first_date } : extracted_images[file_name]),
      'file' => file_name,
      'path' => File.join(site_path, file_name),
      'thumb' => File.join(site_path, 'thumbs', "thumbs_#{file_name}")
    }
  end

  yaml_content = gallery_to_yaml({ 'name' => title, 'date' => first_date, 'images' => images })

  if ENV['J_DRY_RUN']
    p """
Gallery: #{name}
Content: #{yaml_content}
"""
  else
    File.open(data_path, 'w') { |file| file.write(yaml_content) }
  end

  "{% include gallery.html gallery=\"#{name}\" %}"
end

def extract_gallery_data(id)
  client = db_client

  statement_gallery = client.prepare("""
SELECT
  *
FROM
  wpjapan_ngg_gallery
WHERE
  gid = ?;
""")

  result_gallery = statement_gallery.execute(id).first

  return result_gallery['name'], result_gallery['title']
end

def extract_images(id)
  result = client
    .prepare("""
SELECT
  *
FROM
  wpjapan_ngg_pictures
WHERE
  galleryid = ?
ORDER BY
  imagedate ASC;
""")
    .execute(id)

  first_date = nil

  return first_date, result
    .map do |row|
      first_date ||= row['imagedate'].strftime(DATE_FORMAT)

      [
        row['filename'],
        {
          'title' => sanitize_title(row['alttext']),
          'date' => row['imagedate'].strftime(DATE_FORMAT)
        }
      ]
    end
    .to_h
end
