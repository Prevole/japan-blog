# frozen_string_literal: true

require "jekyll"
require "jemoji"

module Jekyll
  class PaginatedEmoji < Jekyll::Emoji
    class << self

      def emojiable?(doc)
        doc.output_ext == "" && doc.is_a?(Jekyll::PaginateV2::Generator::PaginationPage)
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  Jekyll::PaginatedEmoji.emojify(doc) if Jekyll::PaginatedEmoji.emojiable?(doc)
end
