# To format the Curry tutorial

# The PAKCS executable (currently: Version 2)
ifneq ("$(wildcard $(/opt/pakcs/pakcs2/bin/pakcs))","")
PAKCS=/opt/pakcs/pakcs2/bin/pakcs
else
PAKCS=$(shell which pakcs)
endif

# The executable of the Curry package manager (used to generate program URLs):
CPM=cypm -d CURRYBIN=$(PAKCS)

# main document for PDF generation
MAINPDF=main_pdf
# main document for HTML generation
MAINHTML=main_html

.PHONY: all
all: pdf

.PHONY: what
what:
	@echo pdf html programs clean publish

.PHONY: pdf
pdf:
	$(MAKE) $(MAINPDF).pdf
	xdg-open $(MAINPDF).pdf

.PHONY: html
html: output/html/$(MAINHTML).html
	xdg-open output/html/$(MAINHTML).html

%.pdf: ./*.tex browseurl.tex
	pdflatex $*
	bibtex $*
	pdflatex $*
	makeindex $*.idx
	pdflatex $*

output/$(MAINHTML).xml: $(MAINHTML).pdf
	latexml --includestyles \
		--dest=output/$(MAINHTML).xml \
		--documentid=curry-tutorial \
		$(MAINHTML).tex

output/html/$(MAINHTML).html: output/$(MAINHTML).xml css/*.css Makefile
	latexmlpost --format=html5 \
		--splitat=section \
		--css=LaTeXML-blue.css \
		--css=css/main.css \
		--dest=output/html/$(MAINHTML).html \
		output/$(MAINHTML).xml
	$(MAKE) convtilde

# convert strange encodings of tilde characters in URL
# (encoded as %C2%A0 by latexml) in HTML document back to tilde characters:
.PHONY: convtilde
convtilde:
	@cd output/html && \
	  for f in *.html ; do \
	    echo "Post-processing $$f" ; \
	    sed 's/\/%C2%A0/\/~/g' < $$f > TMP$$$$ ; mv TMP$$$$ $$f ; \
	  done

# Generate URLs for all example programs and write them into `browseurl.tex`
.PHONY: programs
programs:
	$(MAKE) browseurl.tex

browseurl.tex: PROGRAMS/*/*.curry
	cd helper-programs && $(CPM) install && $(CPM) curry :load GenerateHRefs :cd ../PROGRAMS :eval main :q

.PHONY: clean
clean:
	/bin/mv $(MAINPDF).tex $(MAINPDF).texx
	/bin/rm -f $(MAINPDF).?? $(MAINPDF).??? *.aux
	/bin/mv $(MAINPDF).texx $(MAINPDF).tex
	/bin/mv $(MAINHTML).tex $(MAINHTML).texx
	/bin/rm -f $(MAINHTML).?? $(MAINHTML).??? *.aux *.html LaTeXML.css ltx-report.css LaTeXML.cache
	/bin/mv $(MAINHTML).texx $(MAINHTML).tex


# put the current version of the PDF and all programs into my web pages:
WEBDIR=$(HOME)/public_html/curry/tutorial
publish: $(MAINPDF).pdf
	cp $(MAINPDF).pdf $(WEBDIR)/tutorial.pdf
	cd PROGRAMS && cleancurry -r
	/bin/rm -rf $(WEBDIR)/PROGRAMS
	cp -r PROGRAMS $(WEBDIR)
	cd $(WEBDIR) && rm -rf PROGRAMS/.curry PROGRAMS/*/.curry *~ */*~ */*/*~
	cd $(WEBDIR) && rm -f PROGRAMS.zip && zip -r PROGRAMS.zip PROGRAMS
	chmod -R go+rX $(WEBDIR)
