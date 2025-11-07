all:
	iconv -f WINDOWS-1252 -t UTF-8 M1S2.csv -o M1S2-UTF8.csv
	iconv -f WINDOWS-1252 -t UTF-8 M1S1.csv -o M1S1-UTF8.csv
	python csvToMD.py 
	pandoc --toc -i M1IBI.md -o M1IBI.pdf --from markdown --template=templates/eisvogel.latex --syntax-highlighting=idiomatic --number-section 
	pandoc --toc -i M1SBI.md -o M1SBI.pdf --from markdown --template=templates/eisvogel.latex --syntax-highlighting=idiomatic --number-section 
	iconv -f WINDOWS-1252 -t UTF-8 M2S2.csv -o M2S2-UTF8.csv
	iconv -f WINDOWS-1252 -t UTF-8 M2S1.csv -o M2S1-UTF8.csv
	python csvToMD.py 
	pandoc --toc -i M2IBI.md -o M2IBI.pdf --from markdown --template=templates/eisvogel.latex --syntax-highlighting=idiomatic --number-section  -V titlepage-background=background11.pdf -V titlepage-text-color="000000"
	pandoc --toc -i M2SBI.md -o M2SBI.pdf --from markdown --template=templates/eisvogel.latex --syntax-highlighting=idiomatic --number-section  -V titlepage-background=background11.pdf -V titlepage-text-color="000000"
	
	
