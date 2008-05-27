DOC = hebrew-html-tutorial

all: html-xsl

DOCMAKE_SGML_PATH = ./sgml/shlomif-docbook/

XMLTO_PARAMS = --stringparam "docmake.output.path_to_root=$(shell perl -e '$$_=shift;$$c=tr[/][];print "../"x($$c+2)' $(call get,DOCBOOK_DIRS_MAP,$(patsubst $(DOCBOOK_INDIVIDUAL_XHTML_DIR)/%,%,$@)))"

$(DOC).xml: $(DOC).xml.tt
	ttml -o $@ $<

html-xsl: $(DOC)/index.html $(DOC)/style.css

$(DOC)/index.html: $(DOC).xml
	xsltproc -o $@ /usr/share/sgml/docbook/xsl-stylesheets-db5-1.73.2/xhtml/docbook.xsl $<

$(DOC)/style.css: style.css
	cp -f $< $@

firefox: html-xsl
	mozilla-firefox $(DOC)/index.html

edit:
	gvim $(DOC).xml.tt style.css Summary.txt
