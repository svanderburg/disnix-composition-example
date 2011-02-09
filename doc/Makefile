INSTALL = install
docdir = /share/doc/HelloWorldExample

XMLLINT = xmllint
XSLTPROC = xsltproc \
 --param section.autolabel 1 \
 --param section.label.includes.component.label 1 \
 --param html.stylesheet \'style.css\' \
 --param make.valid.html 1 \
 --param xref.with.number.and.title 1 \
 --param toc.section.depth 3 \
 --param admon.style \'\' \
 --param callout.graphics.extension \'.gif\' \
 --param contrib.inline.enabled 0

dblatex = dblatex

dblatex_opts = \
 -P doc.collab.show=0 \
 -P latex.output.revhistory=0

VERSION = $(shell cat ../version)

MANUAL_SRCS = index.xml introduction.xml architecture.xml usage.xml

FIGURES = architecture-simple.png architecture-composition.png architecture-lookup.png architecture-loadbalancing.png

all: index.html index.pdf

version.txt:
	echo -n $(VERSION) > version.txt

manual.is-valid: $(MANUAL_SRCS) version.txt
	$(XMLLINT) --noout --nonet --xinclude --noxincludenode --relaxng $(docbookrng)/docbook.rng $<
	touch $@

index.html: $(MANUAL_SRCS) manual.is-valid
	$(XSLTPROC) --nonet --xinclude --output index.html \
	  $(docbookxsl)/html/docbook.xsl index.xml

index.pdf: $(MANUAL_SRCS) manual.is-valid
	if test "$(dblatex)" != ""; then \
		$(dblatex) $(dblatex_opts) index.xml; \
	else \
		echo "Please install dblatex and rerun configure."; \
		exit 1; \
	fi

install: index.html
	$(INSTALL) -d $(DESTDIR)$(docdir)/manual
	$(INSTALL) index.html $(DESTDIR)$(docdir)/manual
	$(INSTALL) style.css $(DESTDIR)$(docdir)/manual
	$(INSTALL) $(FIGURES) $(DESTDIR)$(docdir)/manual
