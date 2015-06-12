# Some Orfeo categories are defined using a model file that is too complex to
# process in an XPath expression. This is a workaround for that.

# -*- coding: utf-8 -*-

module OrfeoMetadata
  class OrfeoHack

    # Define mappings here. The value is an array with the name of the
    # metadata field and, optionally, the full string to be used
    # (otherwise the key string itself will be used).
    @taxonomy_mappings = {
      # Keys from the old fsOrfeo.xml.
      'environnement très bruité' => ['qualiteSon', 'très bruité'],
      'environnement peu bruité'  => ['qualiteSon', 'peu bruité'],
      'environnement bruité' => ['qualiteSon', 'bruité'],
      'enregistrement défectueux' => ['qualiteSon', 'problème enregistrement'],
      'script_Hirst' => ['anonymisationSignal', 'script Daniel Hirst'],

      # Keys from the RNG schema of an input format (not of the TEI format).
      'entretien' => ['nature'],
      'conversation' => ['nature'],
      'consultation' => ['nature'],
      'réunion' => ['nature'],
      'discours' => ['nature'],
      'cours' => ['nature'],
      'discours' => ['nature'],
      'présentation' => ['nature'],
      'narration' => ['nature'],
      'transaction' => ['nature'],
      'repas' => ['nature'],
      'activité' => ['nature'],

      'professionnel' => ['secteur'],
      'privé' => ['secteur'],

      'associatif' => ['milieu'],
      'administratif' => ['milieu'],
      'architecture' => ['milieu'],
      'conseil' => ['milieu'],
      'culturel' => ['milieu'],
      'juridique' => ['milieu'],
      'associatif' => ['milieu'],
      'recherche' => ['milieu'],
      'médical' => ['milieu'],
      'scolaire' => ['milieu'],
      'commercial' => ['milieu'],
      'religieux' => ['milieu'],
      'sportif' => ['milieu'],
      'académique' => ['milieu'],
      'familial' => ['milieu'],
      'amical' => ['milieu'],

      'face à face' => ['medium'],
      'téléphone' => ['medium'],
      'radio' => ['medium'],
      'tv' => ['medium'],
      'en public' => ['medium'],

      'très bruité' => ['qualiteSon', 'environnement très bruité'],
      'peu bruité'  => ['qualiteSon', 'environnement peu bruité'],
      'bruité' => ['qualiteSon', 'environnement bruité'],
      'problème enregistrement' => ['qualiteSon', 'enregistrement défectueux'],

      'bip' => ['anonymisationSignal'],
      'script Daniel Hirst' => ['anonymisationSignal'],
      'silence' => ['anonymisationSignal'],

      'oui' => ['anonymisationTranscription'],
      'non' => ['anonymisationTranscription'],
    }

    # Return value(s) that the given string maps to for a specific field.
    # (If there are none, an empty array is returned.)
    def self.map_vocab(fieldname, string)
      strings = string.scan(/#[^#]+/).map{ |x| x.strip.gsub('_', ' ')[1..-1] }
      result = []
      strings.each do |str|
        next unless @taxonomy_mappings.key? str
        vals = @taxonomy_mappings[str]
        if vals[0] == fieldname
          result.push(vals.size > 1 ? vals[1] : str)
        end
      end
      result
    end
  end
end
