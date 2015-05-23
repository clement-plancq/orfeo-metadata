# -*- coding: utf-8 -*-

module OrfeoMetadata

  ##
  # The set of all metadata fields, both sample level and speaker
  # level.
  class MetadataModel
    attr :fields

    def initialize
      @fields = []
    end

    # Init metadata definitions from the specified .tsv file or, if no
    # file is specified, from the default file contained in this gem.
    def load(filename = nil)
      # Skip the first line since it's used for headers.
      File.readlines(filename || DEFAULT_MD_FILE).drop(1).each do |line|
        line.chomp!
        columns = line.split(/\t/)
        puts "Warning: malformatted line in metadata model: #{line}" unless columns.size == 7
        if columns[2] == 's'
          spe = true
          multi = true
        else
          spe = false
          multi = (columns[2] == 'gm')
        end
        facet = false
        target = false
        case columns[3]
        when 'f'
          facet = true
          index = true
        when 's'
          target = true
          index = true
        when 'i'
          index = true
        else
          index = false
        end
        show_conc = (columns[4] == 'y')
        show_snip = (columns[5] == 'y')

        @fields << MetadataField.new(columns[0], columns[6], index, spe, facet, show_conc, show_snip, target, multi, columns[1])
      end
    end

    # Output definitions of the indexable metadata fields in Solr
    # schema format (not a complete schema file, just the field
    # definitions).
    def output_schema(out)
      @fields.each do |field|
        if field.indexable?
          out.puts "<field name=\"#{field.name}\" type=\"string\" indexed=\"true\" stored=\"true\" multiValued=\"#{field.multi_valued?}\"/>"
        end
      end
    end
  end
end
