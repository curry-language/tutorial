# To format the Curry tutorial

# The executable of the Curry package manager (used to generate program URLs):
CPM=cypm

.PHONY: all
all: pdf

.PHONY: what
what:
	@echo pdf programs clean publish

.PHONY: pdf
pdf:
	$(MAKE) main.pdf
        # thumbpdf main
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

# Generate URLs for all example programs and write them into `browseurl.tex`
.PHONY: programs
programs:
	$(MAKE) browseurl.tex

browseurl.tex: PROGRAMS/*/*.curry
	cd helper-programs && $(CPM) install && $(CPM) curry :load GenerateHRefs :cd ../PROGRAMS :eval main :q

.PHONY: clean
clean:
	/bin/mv main.tex main.texx
	/bin/rm -f main.?? main.??? *.aux
	/bin/mv main.texx main.tex


# put the current version of the PDF and all programs into my web pages:
WEBDIR=$(HOME)/public_html/curry/tutorial
publish: main.pdf
	cp main.pdf $(WEBDIR)/tutorial.pdf
	cd PROGRAMS && cleancurry -r
	cp -r PROGRAMS $(WEBDIR)
	cd $(WEBDIR) && rm -rf PROGRAMS/GenerateHRefs.curry PROGRAMS/.curry PROGRAMS/*/.curry *~ */*~ */*/*~
	cd $(WEBDIR) && rm -f PROGRAMS.zip && zip -r PROGRAMS.zip PROGRAMS
	chmod -R go+rX $(WEBDIR)
