require 'time'

module Jekyll
  module DateFilter
    MONTHS = %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)

    def jp_date(date)
      date = Time.parse(date) if date.is_a? String

      day = date.strftime("%-d")
      formatted_day = day == "1" ? "1er" : day

      "#{formatted_day} #{MONTHS[date.strftime("%m").to_i - 1]} #{date.strftime("%Y")}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::DateFilter)
