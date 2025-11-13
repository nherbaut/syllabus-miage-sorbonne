SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables

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
.PHONY: all precheck md pdf clean print-%

# Helper for consistent logs per-target
define log
	@printf '[%s] %s\n' '$@' "$(1)"
endef

all: precheck md pdf
	$(call log,Completed full build)

# Convert Windows-1252 CSV to UTF-8
%-UTF8.csv: %.csv
	$(call log,iconv $< -> $@ (WINDOWS-1252 to UTF-8))
	$(ICONV) -f WINDOWS-1252 -t UTF-8 $< >$@

# Generate markdown files (any .md depends on CSVs and script)
$(MD): $(UTF8_CSV) L3S1.csv L3S2.csv csvToMD.py
	$(call log,Generating Markdown with $(PYTHON) csvToMD.py)
	$(PYTHON) --version
	$(PYTHON) csvToMD.py

# Phony convenience target to build all markdown
md: $(MD)

# Build all PDFs
pdf: $(PDF)
	$(call log,Requested PDFs: $(PDF))

# Generic rule: *.md -> *.pdf, identical to your working pandoc line
%.pdf: %.md
	$(call log,pandoc $< -> $@ using template $(PANDOC_TEMPLATE))
	@$(PANDOC) --version | head -n1 || true
	$(PANDOC) $(PANDOC_COMMON_OPTS) --verbose -V titlepage-background=$(TITLE_BG) -i $< -o $@

clean:
	$(call log,Cleaning generated files)
	rm -f $(UTF8_CSV) $(MD) $(PDF)

# Print a variable: `make print-VAR`
print-%:
	@printf '%s = %s\n' '$*' '$($*)'

# Environment and tool sanity checks before build
precheck:
	$(call log,PWD=$$(pwd))
	$(call log,PATH=$$PATH)
	$(call log,Locale: $$(locale 2>/dev/null | paste -sd ' ' - || true))
	$(call log,Tools present and versions)
	@command -v $(PYTHON) && $(PYTHON) --version || { echo 'python not found'; exit 1; }
	@command -v $(PANDOC) && $(PANDOC) --version | head -n1 || { echo 'pandoc not found'; exit 1; }
	@command -v $(ICONV) && $(ICONV) --version | head -n1 || { echo 'iconv not found'; exit 1; }
	$(call log,Make variables)
	@printf 'PYTHON=%s\nPANDOC=%s\nICONV=%s\nPANDOC_TEMPLATE=%s\nTITLE_BG=%s\nMD=%s\nPDF=%s\n' "$(PYTHON)" "$(PANDOC)" "$(ICONV)" "$(PANDOC_TEMPLATE)" "$(TITLE_BG)" "$(MD)" "$(PDF)"
	$(call log,Repository listing)
	@ls -la || true
