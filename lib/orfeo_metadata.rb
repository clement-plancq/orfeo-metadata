require 'orfeo_metadata/metadata_field'
require 'orfeo_metadata/metadata_model'
require 'orfeo_metadata/metadata_store'
require "orfeo_metadata/version"

module OrfeoMetadata
  DEFAULT_MD_FILE = File.expand_path '../../data/metadata.tsv', __FILE__
end
