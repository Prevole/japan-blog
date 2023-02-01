LINE_WIDTH = 115
BREAK_SEQUENCE = "\n"

# https://github.com/rails/rails/blob/7c70791470fc517deb7c640bead9f1b47efb5539/actionview/lib/action_view/helpers/text_helper.rb#L264
def word_wrap(text)
  text.split("\n").collect! do |line|
    line.length > LINE_WIDTH ? line.gsub(/(.{1,#{LINE_WIDTH}})(\s+|$)/, "\\1#{BREAK_SEQUENCE}").rstrip : line
  end * BREAK_SEQUENCE
end
