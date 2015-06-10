# orfeo-metadata

Store metadata, particularly for linguistic annotations of a certain type.

See the [orfeo](https://github.com/orfeo-treebank/orfeo)
repository for more information about project Orfeo.


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

## Adding fields via metadata text files

Metadata fields can also be set through other methods, such as
metadata text files (with suffix .md.txt and format field=value on
each line). In these cases, note that if a field is defined to have a
single value and it is already defined when a TEI file is read, the
XPath expression will not be evaluated and the existing value will be
left unchanged. Thus values set in metadata text files override those
in TEI files. In contrast, for a field with multiple values, all
occurrences in the metadata text and TEI files will be stored
together.

## Configuring taxonomies

A number of fields in the metadata model are defined in a different
way from the others, using taxonomies or controlled
vocabularies. These are defined in an external file named
`fsOrfeo.xml`. This awkward and complex method makes it difficult to
configure changes in the metadata fields. Instead, this module handles
them through a simplistic version that does not in fact read
`fsOrfeo.xml` (so that file is not required).

The taxonomies are defined in a Ruby file,
[orfeo_hack.rb](lib/orfeo_metadata/orfeo_hack.rb). If they change,
that file needs to be edited to reflect the changes. The format of the
mappings is very simple (indeed, much simpler than the original
`fsOrfeo.xml`) and should be obvious by looking at the examples. Note
that field names in the mapping and the metadata definition file must
match.

In the metadata definition file, creating a field with `orfeo:xyz` in
the XPath field causes the XPath expression to be evaluated first. The
result is evaluated as a string, split on whitespace and the character
\#, and then the defined taxonomic mapping is applied to the result.

Consider the following example: `orfeo_hack.rb` contains these
definitions:

```ruby
'environnement_très_bruité' => ['qualiteSon', 'environnement très bruité'],
'environnement_peu_bruité'  => ['qualiteSon', 'environnement peu bruité'],
'environnement_bruité' => ['qualiteSon', 'environnement bruité'],
'enregistrement_défectueux' => ['qualiteSon', 'enregistrement défectueux'],
```

The metadata mappings file has this line:

```tsv
qualiteSon	Qualité du son	g	i	n	n	orfeo:/a/b/c/recording[@type='audio']/@ana
```

And the input TEI file contains this:

```xml
<recording type="audio" dur="01:08:46" ana="#environnement_peu_bruité #audio/x-wav">
```

The metadata field qualiteSon will be assigned the value
"environnement peu bruité".


# Installation

The simplest way to use this gem is to build and install it locally on
the computer(s) where the importer is run and the search UI in
installed:

```sh
git clone https://github.com/orfeo-treebank/orfeo-metadata.git
cd orfeo-metadata
rake install
```


# License

GPL v3; see file LICENSE for full text of the license.
