# ==== Tools ====
PYTHON := python3
PANDOC := pandoc
ICONV  := iconv

# ==== CSV sources and UTF-8 conversions ====
CSV_WIN   := M1S1.csv M1S2.csv M2S1.csv M2S2.csv
UTF8_CSV  := $(CSV_WIN:%.csv=%-UTF8.csv)

# ==== Markdown and PDF outputs ====
MD  := M1IBI.md M1SBI.md M2IBI.md M2SBI.md L3.md
PDF := $(MD:.md=.pdf)

# ==== Pandoc configuration (mirrors your working call) ====
PANDOC_TEMPLATE      := templates/eisvogel.latex
TITLE_BG             := background11.pdf
TITLE_TEXT_COLOR     := 000000

PANDOC_COMMON_OPTS := \
	--toc \
	--from markdown \
	--template=$(PANDOC_TEMPLATE) \
	--syntax-highlighting=idiomatic \
	--number-section \
	-V titlepage-text-color="$(TITLE_TEXT_COLOR)"

# ==== Phony targets ====
.PHONY: all md pdf clean

all: pdf

# Convert Windows-1252 CSV to UTF-8
%-UTF8.csv: %.csv
	$(ICONV) -f WINDOWS-1252 -t UTF-8 $< -o $@

# Generate all markdown in one pass
md: $(UTF8_CSV) L3S1.csv L3S2.csv csvToMD.py
	$(PYTHON) csvToMD.py

# Build all PDFs
pdf: $(PDF)

# Generic rule: *.md -> *.pdf, identical to your working pandoc line
%.pdf: %.md
	$(PANDOC) $(PANDOC_COMMON_OPTS) -V titlepage-background=$(TITLE_BG) -i $< -o $@

clean:
	rm -f $(UTF8_CSV) $(MD) $(PDF)
