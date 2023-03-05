module Jekyll
  module PluralizeFilter
    def pluralize(value, singular, plural)
      value = value.to_i
      if value > 1
        "#{value} #{plural}"
      else
        "#{value} #{singular}"
      end
    end

  end
end

Liquid::Template.register_filter(Jekyll::PluralizeFilter)
