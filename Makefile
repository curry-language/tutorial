# To format the Curry tutorial

# bibliography?  programs?
main.pdf: main.tex introduction.tex start.tex features.tex programming.tex \
	  html.tex libraries.tex baseurl.sty
	pdflatex main
	bibtex main
	pdflatex main
	makeindex main.idx
	pdflatex main

.PHONY: clean
clean:
	/bin/mv main.tex main.texx
	/bin/rm -f main.?? main.??? *.aux
	/bin/mv main.texx main.tex

.PHONY: what
what:
	@echo index biblio programs pdf tutorial.zip publish

.PHONY: programs
programs:
	#./PROGRAMS/gen-exec-progs
	#./PROGRAMS/pdf-progs
	cd PROGRAMS && pakcs :l GenerateHRefs :eval main :q

.PHONY: pdf
pdf: baseurl.sty
	@echo Have you done the programs?
	$(MAKE) main.pdf
	thumbpdf main
	pdflatex main
	rm -f thumb* main.out
	@echo acroread main.pdf \&


.PHONY: all
all:	programs pdf

# produce a zip file containing the pdf file and all programs:
TMPDIR=/tmp/tutorial
tutorial.zip: pdf programs
	rm -rf tutorial.zip ${TMPDIR}  # remove old version
	mkdir ${TMPDIR}
	cp -r -p . ${TMPDIR}/tutorial
	cd ${TMPDIR}/tutorial ; rm -rf PROGRAMS/pdf-progs PROGRAMS/gen-exec-progs */CVS */*/CVS *~ */*~ */*/*~
	cd ${TMPDIR} ; zip -r tutorial.zip tutorial/main.pdf tutorial/PROGRAMS
	mv ${TMPDIR}/tutorial.zip .
	rm -rf ${TMPDIR}

# put the current version into the web:
WEBDIR=${HOME}/public_html/curry/tutorial
publish: tutorial.zip
	mv baseurl.sty baseurl.sty.save
	echo "\\def\\baseurl{http://www.informatik.uni-kiel.de/~curry/tutorial/}" > baseurl.sty
	$(MAKE) programs
	$(MAKE) pdf
	mv baseurl.sty.save baseurl.sty
	cd PROGRAMS ; cleancurry -r
	cp -r PROGRAMS ${WEBDIR}
	cd ${WEBDIR} ; rm -rf PROGRAMS/pdf-progs PROGRAMS/gen-exec-progs */CVS */*/CVS *~ */*~ */*/*~
	cp main.pdf ${WEBDIR}/tutorial.pdf
	cp main.ps ${WEBDIR}/tutorial.ps
	cp tutorial.zip ${WEBDIR}/tutorial.zip
	chmod -R go+rX ${WEBDIR}
