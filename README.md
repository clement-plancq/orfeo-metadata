# orfeo-metadata

Store metadata, particularly for linguistic annotations of a certain type.

See the [orfeo-importer](https://github.com/larilampen/orfeo-importer)
repository for more information about the project.


# Configuration

The file [metadata.tsv](data/metadata.tsv) defines the metadata fields
to be extracted, indexed and displayed. The following columns are
used:

 - The *short name* of a field is ideally a single word with no
   non-ASCII characters.
 - The *long name* is a descriptive string displayed to users.
 - The *field type* can be **g** for a general field (i.e. one on the
   sample level); **gm** for a general field with multiple values; or
   **s** for a specific (or speaker level) field
 - The *indexing and search* column defines treatment of the field
   when using a text index (basically, Solr) and a corresponding
   search interface: **f** for a facet (indexed, then made available
   for selection in the search interface); **s** for a search target
   (indexed, then accessible for single-field text search); **i** for
   an indexed field (which is included in the text index but not
   separately visible in the search interface); and **o** to omit a
   field (which is not indexed)
 - The *XPath* column defines the XPath expression to be used to
   extract the value of the field from a TEI document. If the field is
   not multi-valued, only the first match is used; otherwise all
   matching values are extracted.


# Installation

The simplest way to use this gem is to build and install it locally on
the computer(s) where the importer is run and the search UI in
installed:

```sh
git clone https://github.com/larilampen/orfeo-metadata.git
cd orfeo-metadata
rake install
```


# License

GPL v3; see file LICENSE for full text of the license.
