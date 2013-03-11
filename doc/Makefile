../bin/IIES3-ICO-romain.beaumont.pdf:IIES3-ICO-romain.beaumont.tex
	cp IIES3-ICO-romain.beaumont.tex ../temp/IIES3-ICO-romain.beaumont.tex
	cp *.png ../temp
	cp minted.sty ../temp
	cd ../temp ; pdflatex -shell-escape IIES3-ICO-romain.beaumont.tex && pdflatex -shell-escape IIES3-ICO-romain.beaumont.tex && pdflatex -shell-escape IIES3-ICO-romain.beaumont.tex && pdflatex -shell-escape IIES3-ICO-romain.beaumont.tex
	mv ../temp/IIES3-ICO-romain.beaumont.pdf ../bin/IIES3-ICO-romain.beaumont.pdf
	
run:../bin/IIES3-ICO-romain.beaumont.pdf
	evince ../bin/IIES3-ICO-romain.beaumont.pdf
	
clean:
	rm -f ../temp/*
	rm -f ../bin/*