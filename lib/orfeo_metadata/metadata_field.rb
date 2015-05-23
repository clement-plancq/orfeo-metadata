# -*- coding: utf-8 -*-

module OrfeoMetadata

  ##
  # A single metadata field.
  class MetadataField
    attr :name
    attr :desc
    attr :xpath

    def initialize(name, xpath, indexable, specific, facet = false, show_conc = false, show_snip = false, search_target = false, multi_valued = false, desc = nil)
      @name = name
      @xpath = xpath
      @desc = desc
      @indexable = indexable
      @specific = specific
      @multi_valued = multi_valued
      @facet = facet
      @search_target = search_target
      @show_conc = show_conc
      @show_snip = show_snip
    end

    # Facets and "searchable" fields are indexable.
    def indexable?
      @indexable
    end

    def multi_valued?
      @multi_valued
    end

    def specific?
      @specific
    end

    def facet?
      @facet
    end

    def search_target?
      @search_target
    end

    def show_in_concordancer?
      @show_conc
    end

    def show_in_snippet_view?
      @show_snip
    end

    def to_s
      return desc unless desc.nil? || desc.empty?
      name
    end
  end
end
