DOC = hebrew-html-tutorial

all: html-xsl

DOCMAKE_SGML_PATH = ./sgml/shlomif-docbook/

XMLTO_PARAMS = --stringparam "docmake.output.path_to_root=$(shell perl -e '$$_=shift;$$c=tr[/][];print "../"x($$c+2)' $(call get,DOCBOOK_DIRS_MAP,$(patsubst $(DOCBOOK_INDIVIDUAL_XHTML_DIR)/%,%,$@)))"

include docbook-render.mak

$(DOC).xml: $(DOC).xml.tt
	ttml -o $@ $<

firefox: html-xsl
	mozilla-firefox $(DOC)/index.html
