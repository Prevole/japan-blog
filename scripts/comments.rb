require 'yaml'

require "#{File.expand_path(File.dirname(__FILE__))}/db.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/smileys.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/smileys.rb"

def sanitize_comment(comment)
  word_wrap smileys(
    comment
      .strip
      .gsub(/\r\n/, "\n")
  )
  .gsub(/(:[a-z_]+:)[a-z_]+:/, '\\1')
  .gsub(/ $/, '')
  .gsub(/ {2,}/, ' ')
  .gsub("\\x01", '')
  .gsub(/\.\.\./, '…')
end

def comments_to_yaml(comments)
  comments
    .to_yaml(line_width: 110)
    .gsub(/text: ((>-|\|-)\n {4})?/, "text: |\n    ")
    .gsub(/\n(- author:)/, "\n\n- author:")
    .gsub(/---\n\n/, '')
    .gsub(/^\s{4}'/, '    ')
    .gsub(/'\n$/, "\n")
    .gsub(/''/, "'")
    .gsub(/^\s{4}-/, '    ﹣')
end

def comments(post_name, post_id, post_date)
  client = db_client

  post_date = post_date.strftime('%Y-%m-%d')

  statement_comments = client.prepare("""
SELECT
  *
FROM
  wpjapan_comments
WHERE
  comment_post_ID = ?
ORDER BY
  `comment_date` ASC;
""")

  result_comments = statement_comments.execute(post_id)
  comments = result_comments.map do |row|
    {
      'author' => row['comment_author'],
      'date' => row['comment_date'].strftime('%Y-%m-%d %H:%M:%S %z'),
      'text' => sanitize_comment(row['comment_content'])
    }
  end

  yaml_content = comments_to_yaml comments

  base_dir = File.expand_path("#{File.dirname(__FILE__)}/..")
  file_path = "#{base_dir}/_data/comments/#{post_date}-#{post_name}.yaml"

  if ENV['J_DRY_RUN']
    p """################### COMMENTS
File: #{file_path}
Content: #{yaml_content}
###
"""
  else
    File.open(file_path, 'w') { |file| file.write(yaml_content) } if comments.count >= 1
  end
end