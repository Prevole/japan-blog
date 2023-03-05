require "rouge"

Jekyll::Hooks.register :site, :pre_render do |site|
  puts "Adding Pseudo Code Lexer..."

  class PseudoCodeLexer < Rouge::RegexLexer
    title "Pseudo Code"
    desc "Pseudo Code"
    tag 'pseudo'

    def self.keywords
      @keywords ||= %w(
        si alors sinon fin
      )
    end

    state :basic do
      rule %r/\s+/, Text
      rule %r/\d+/, Num::Integer
      rule %r/\d+\.\d+/, Num::Float
      rule %r/[<>=+]/, Operator

      rule %r/([a-z]\w*)/i do |m|
        if self.class.keywords.include? m[1]
          groups Keyword, Error
        else
          token Text
        end
      end
    end

    state :root do
      mixin :basic
    end
  end
end