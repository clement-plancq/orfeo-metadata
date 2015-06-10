# -*- coding: utf-8 -*-

require 'rexml/document'
include REXML

module OrfeoMetadata

  ##
  # The metadata fields and the corresponding values associated with
  # a single sample (and the speakers within it).
  class MetadataStore
    def initialize(model)
      @model = model
      @field_by_name = {}
      @model.fields.each { |field| @field_by_name[field.name] = field }
      @val_by_field = {}
      @num_speakers = 0
    end

    # Parse metadata from a TEI document (represented as a DOM tree).
    def read_tei(xmldoc)
      # Note that line breaks must be removed from metadata values.
      @model.fields.each do |field|
        next if field.xpath == 'n/a'
        if field.xpath.start_with? 'orfeo:'
          # The rest of the field after 'orfeo:' is the actual XPath.
          xp = field.xpath[6..-1]
          val1 = XPath.first(xmldoc, xp).to_s.gsub(/[\n\r]/, '').strip
          val = OrfeoHack.map_vocab(field.name, val1)
          next if val.empty?
          val = val[0] unless field.multi_valued?
        elsif field.multi_valued?
          val = []
          XPath.each(xmldoc, field.xpath) do |n|
            text = n.to_s.gsub(/[\n\r]/, '').strip
            # To maintain ordering, all multi-valued elements are
            # stored even if empty.
            val << text
          end
          # The number of speakers is the highest number of
          # speaker-level values available.
          if field.specific? && val.size > @num_speakers
            @num_speakers = val.size
          end
        else
          # Do not overwrite existing value.
          next if @val_by_field.key? field
          val = XPath.first(xmldoc, field.xpath).to_s.gsub(/[\n\r]/, '').strip
        end
        @val_by_field[field] = val unless val.empty?
      end
    end

    # Read metadata values from a text file (format is key=value on
    # each line of file). If field is multivalued, it can be defined
    # multiple times.
    def read_txt(filename)
      File.open(filename) do |file|
        file.each do |line|
          name, value = line.split '='
          next if name.nil?
          if @field_by_name.key? name
            field = @field_by_name[name]
            if field.multi_valued?
              @val_by_field[field] = [] unless @val_by_field.key? field
              @val_by_field[field] << value
            else
              @val_by_field[field] = value
            end
          end
        end
      end
    end

    # Set file and corpus names if they are not yet set.  (These
    # values are known based on file and directory names even when no
    # metadata file is available.)
    def set_defaults(sample)
      field = @field_by_name['nomFichier']
      unless @val_by_field[field]
        sample_name = sample.name
        sample_name ||= 'sans titre'
        @val_by_field[field] = sample_name
      end
      field = @field_by_name['nomCorpus']
      unless @val_by_field[field]
        @val_by_field[field] = sample.corpus.to_s
      end
      field = @field_by_name['url']
      unless @val_by_field[field]
        @val_by_field[field] = sample.sample_url if sample.sample_url
      end
    end

    def field(name)
      @field_by_name[name]
    end

    def by_name(name)
      @val_by_field[@field_by_name[name]]
    end

    def by_field(field)
      @val_by_field[field]
    end

    # Loop through specific metadata groups (i.e. speakers) and yield
    # an enumerator to each one in turn, along with the number of the
    # group.
    def enumerators_spe
      @num_speakers.times do |i|
        yield each_spe_num(i), i
      end
    end

    # Iterate through all metadata.
    def each
      return enum_for(:each) unless block_given?
      @val_by_field.each do |k, v|
        yield k, v
      end
    end

    # Iterate through general metadata.
    def each_gen
      return enum_for(:each_gen) unless block_given?
      @val_by_field.reject{ |k, v| k.specific? }.each do |k, v|
        yield k, v
      end
    end

    # Iterate through speaker metadata.
    def each_spe
      return enum_for(:each_spe) unless block_given?
      @val_by_field.select{ |k, v| k.specific? }.each do |k, v|
        yield k, v
      end
    end

    # Iterate through speaker metadata of the given speaker only.
    def each_spe_num(num)
      unless block_given?
        return Enumerator.new do |y|
          each_spe do |k, v|
            y.yield k, v[num]
          end
        end
      end
      each_spe do |k, v|
        yield k, v[num]
      end
    end
  end
end
