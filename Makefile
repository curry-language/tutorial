# To format the Curry tutorial

# Curry system used to generate program URLs:
CURRYSYSTEM=pakcs

.PHONY: all
all:	programs pdf

.PHONY: what
what:
	@echo programs pdf publish

.PHONY: pdf
pdf: programs
	$(MAKE) main.pdf
	thumbpdf main
	pdflatex main
	rm -f thumb* main.out
	@echo acroread main.pdf \&

main.pdf: main.tex introduction.tex start.tex features.tex programming.tex \
	  html.tex libraries.tex browseurl.tex
	pdflatex main
	bibtex main
	pdflatex main
	makeindex main.idx
	pdflatex main

# Generate URLs for all example programs:
.PHONY: programs
programs:
	cd PROGRAMS && $(CURRYSYSTEM) :load GenerateHRefs :eval main :q

.PHONY: clean
clean:
	/bin/mv main.tex main.texx
	/bin/rm -f main.?? main.??? *.aux
	/bin/mv main.texx main.tex


# put the current version of the PDF and all programs into my web pages:
WEBDIR=$(HOME)/public_html/curry/tutorial
publish: pdf
	cp main.pdf $(WEBDIR)/tutorial.pdf
	cd PROGRAMS ; cleancurry -r
	cp -r PROGRAMS $(WEBDIR)
	cd $(WEBDIR) && rm -rf PROGRAMS/GenerateHRefs.curry PROGRAMS/.curry PROGRAMS/*/.curry *~ */*~ */*/*~
	cd $(WEBDIR) && rm -f PROGRAMS.zip && zip -r PROGRAMS.zip PROGRAMS
	chmod -R go+rX $(WEBDIR)
