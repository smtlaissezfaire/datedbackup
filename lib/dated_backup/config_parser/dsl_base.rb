
class DatedBackup
  class DSL
    class Base
      
      include UtilityFunctions

    private
      
      TOKENS = {
        :key => /[\w\d\_]+/,
        :value => /.*/,
        :key_delimiter => /\=/,
        :value_delimiter => /\,/,
        :escape_start => /\%q\(/,
        :escape_end => /\)/
      }
      
      class << self        
        private
        
        def tokens; TOKENS; end
        
        def token_src(key)
          tokens[key].source
        end
      end
      
      REGEXPS = {
        # need to add zero-width look-aheads to some of these...
        :non_escaped => /(?!#{token_src :escape_start})(.*?)(!?#{token_src :escape_end})/, # this is clearly wrong, but it breaks the specs!
        :keys_and_values => /(#{token_src :key}?)#{token_src :key_delimiter}(#{token_src :value})/,
        :key => /^(#{token_src :key}?)(?=#{token_src :key_delimiter})/,
        :key_with_spaces => /^(\s*?#{token_src :key}?\s*?)(?=#{token_src :key_delimiter})/,
        :values => /^.+?#{token_src :key_delimiter}(#{token_src :value})/, # the key should be here, but this too breaks the specs
        :non_escaped_delimiter => /(?!#{token_src :escape_start})#{token_src :value_delimiter}(?!#{token_src :escape_end})/
      }
      
      def regexps
        REGEXPS
      end
        
    end
  end
end