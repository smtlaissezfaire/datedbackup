
class DatedBackup
  class DSL
    class Base
      
      include UtilityFunctions

      private
      
        REGEXPS = {
          :non_escaped => /(?!\%q\()(.*?)(!?\))/,
          :keys_and_values => /(.*?)(?!\%q\()\=(?!\))(.*)/,
          :key => /^([\w\d\_]+?)(?=\=)/,
          :key_with_spaces => /^(\s*[\w\d\_]+?\s*)/,
          :value => /^.*?\=(.*)/,
          :non_escaped_comma => /(?!\%q\()\,(?!\))/
        }
      
    end
  end
end