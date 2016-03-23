DOC = hebrew-html-tutorial

DEST_DIR = $(DOC)
DEST_INDEX = $(DEST_DIR)/index.html

all: html-xsl

DOCMAKE_SGML_PATH = ./sgml/shlomif-docbook/

XMLTO_PARAMS = --stringparam "docmake.output.path_to_root=$(shell perl -e '$$_=shift;$$c=tr[/][];print "../"x($$c+2)' $(call get,DOCBOOK_DIRS_MAP,$(patsubst $(DOCBOOK_INDIVIDUAL_XHTML_DIR)/%,%,$@)))"

$(DOC).xml: $(DOC).xml.tt Render-TT2-to-Docbook.pl
	perl Render-TT2-to-Docbook.pl

# validate: validate-jing
validate: validate-xmllint

validate-xmllint: $(DOC).xml
	xmllint --relaxng http://www.docbook.org/xml/5.0/rng/docbook.rng $<

validate-jing: $(DOC).xml
	jing http://www.docbook.org/xml/5.0/rng/docbook.rng $<

html-xsl: $(DEST_INDEX) $(DOC)/style.css put-images


# This is to use the docbook-xsl-snapshot which should have a better
# support for xml:lang, etc. See:
# https://sourceforge.net/tracker/?func=detail&atid=373750&aid=1993833&group_id=21935

# XSL_STYLESHEETS_PATH := /usr/share/sgml/docbook/xsl-stylesheets-db5-1.73.2/xhtml
XSL_STYLESHEETS_PATH := $(HOME)/Download/unpack/file/docbook/docbook-xsl-snapshot

XSL_STYLESHEETS_XHTML_PATH := $(XSL_STYLESHEETS_PATH)/xhtml

$(DEST_INDEX): $(DOC).xml custom.xsl
	xsltproc --path $(XSL_STYLESHEETS_XHTML_PATH) -o $@ custom.xsl $<

$(DOC)/style.css: style.css
	cp -f $< $@

firefox: html-xsl
	mozilla-firefox $(DEST_INDEX)

upload: upload_local upload_remote

upload_local: html-xsl
	rsync -a -v --progress $(DEST_DIR) Summary.txt $${HOMEPAGE_SSH_PATH}/hebrew-html-tutorial-brk800/

upload_remote: html-xsl
	rsync -a -v --progress $(DEST_DIR) Summary.txt $${__HOMEPAGE_REMOTE_PATH}/hebrew-html-tutorial-brk800/

edit:
	gvim $(DOC).xml.tt style.css Summary.txt

IMAGES_PROTO = images/first-document.png \
			   images/two-paragraphs-without-markup.png \
			   images/two-paragraphs-with-p-tags.png \
			   images/a-href-sample.png \
			   images/bold-and-italics-sample.png \
			   images/complete-example-1.png \
			   images/validates-screenshot.png \
			   images/h1-h2-example.png \
			   images/with-head-style-tag.png


IMAGES = $(patsubst images/%,%,$(IMAGES_PROTO))

DEST_IMAGES_DIR = $(DEST_DIR)/images

DEST_IMAGES = $(addprefix $(DEST_IMAGES_DIR)/,$(IMAGES))

put-images: $(DEST_IMAGES_DIR) $(DEST_IMAGES)

$(DEST_IMAGES_DIR):
	mkdir -p $@

$(DEST_IMAGES) : $(DEST_IMAGES_DIR)/% : images/%
	cp -f $< $@
