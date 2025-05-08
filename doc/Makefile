DOC := proyecto.tex

all: doc

doc: $(DOC:.tex=.pdf)

all: proyecto.pdf

%.pdf: %.tex FORCE
	pdflatex $< && biber $* && pdflatex $< && pdflatex $<

FORCE: 


