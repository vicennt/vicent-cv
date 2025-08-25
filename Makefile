# Set TeX PATH for macOS
export PATH := /Library/TeX/texbin:$(PATH)

TEX=latexmk
ENGINE=-xelatex
SRC=src/main.tex
OUTDIR=dist

.PHONY: build clean watch view

build:
	mkdir -p $(OUTDIR)
	PATH="/Library/TeX/texbin:$(PATH)" $(TEX) $(ENGINE) -pdf -interaction=nonstopmode -file-line-error -halt-on-error -output-directory=$(OUTDIR) $(SRC)

watch:
	mkdir -p $(OUTDIR)
	PATH="/Library/TeX/texbin:$(PATH)" $(TEX) $(ENGINE) -pvc -pdf -interaction=nonstopmode -file-line-error -output-directory=$(OUTDIR) $(SRC)

view:
	@if [ -f $(OUTDIR)/main.pdf ]; then \
		open $(OUTDIR)/main.pdf; \
	else \
		echo "PDF not found. Run 'make build' first."; \
	fi

clean:
	$(TEX) -C -output-directory=$(OUTDIR) $(SRC) || true
	rm -rf $(OUTDIR)/_minted* $(OUTDIR)/*.aux $(OUTDIR)/*.log $(OUTDIR)/*.out $(OUTDIR)/*.fls $(OUTDIR)/*.fdb_latexmk
