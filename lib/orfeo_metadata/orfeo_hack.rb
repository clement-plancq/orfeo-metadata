# Some Orfeo categories are defined using a model file that is too complex to
# process in an XPath expression. This is a workaround for that.

# -*- coding: utf-8 -*-

module OrfeoMetadata
  class OrfeoHack

    # Define mappings here. The value is an array with the name of the
    # metadata field and, optionally, the full string to be used
    # (otherwise the key string itself will be used).
    @taxonomy_mappings = {
      # These keys are from fsOrfeo.xml.
      'réunion' => ['nature'],
      'entretien' => ['nature'],
      'conversation' => ['nature'],
      'consultation' => ['nature'],
      'discours' => ['nature'],
      'professionnel' => ['categorie'],
      'privé' => ['categorie'],
      'public' => ['categorie'],
      'associatif' => ['milieuProfessionnel'],
      'médical' => ['milieuProfessionnel'],
      'politique' => ['milieuProfessionnel'],
      'face_à_face' => ['distance', 'face à face'],
      'environnement_très_bruité' => ['qualiteSon', 'environnement très bruité'],
      'environnement_peu_bruité'  => ['qualiteSon', 'environnement peu bruité'],
      'environnement_bruité' => ['qualiteSon', 'environnement bruité'],
      'enregistrement_défectueux' => ['qualiteSon', 'enregistrement défectueux'],
      'x' => ['qualiteVideo'],
      'bip' => ['anonymisationSignal'],
      'script_Hirst' => ['anonymisationSignal', 'script Hirst'],

      # These keys are from actual instances of TEI.
      'très_bruité' => ['qualiteSon', 'environnement très bruité'],
      'peu_bruité'  => ['qualiteSon', 'environnement peu bruité'],
      'environnement_bruité' => ['qualiteSon', 'environnement bruité'],
      'problème_enregistrement' => ['qualiteSon', 'enregistrement défectueux'],
      'script' => ['anonymisationSignal', 'script Hirst'],
    }

    # Return value(s) that the given string maps to for a specific field.
    # (If there are none, an empty array is returned.)
    def self.map_vocab(fieldname, string)
      strings = string.scan(/[^\#\s]+/)
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
