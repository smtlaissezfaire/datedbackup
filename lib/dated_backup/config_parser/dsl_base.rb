
class DatedBackup
  class DSL
    class Base
      
      include UtilityFunctions

      private
      
        REGEXPS = {
          :non_escaped => /(.*?)(\%q\(.*?\))/,
          :keys_and_values => /(.*?)(?!\%q\()\=(?!\))(.*)/,
          :key => /^(.*?)=/,
          :value => /^.*?=(.*)/
        }
      
    end
  end
end