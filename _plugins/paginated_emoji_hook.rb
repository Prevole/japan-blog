require "jemoji"

module Jekyll
  class PaginatedEmojiHook < Jekyll::Emoji
    class << self
      def emojiable?(doc)
        doc.output_ext == "" && doc.is_a?(Jekyll::PaginateV2::Generator::PaginationPage)
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  Jekyll::PaginatedEmojiHook.emojify(doc) if Jekyll::PaginatedEmojiHook.emojiable?(doc)
end
