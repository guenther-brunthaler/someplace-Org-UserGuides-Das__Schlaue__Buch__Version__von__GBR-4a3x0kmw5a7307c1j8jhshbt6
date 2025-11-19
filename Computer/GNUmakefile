ASCIIDOCS = $(shell find -type f -name "*.asciidoc" | sed -e 's, ,\\ ,g')
HTMLS = $(patsubst %.asciidoc,%.html,$(ASCIIDOCS))
TARGETS = $(HTMLS)

all: $(TARGETS)

.PHONY: all clean
.SUFFIXES: .asciidoc .html

.asciidoc.html:
	asciidoc -a revnumber=`revisiontime -F "$@"` -o "$@" "$<"

clean:
	-rm $(TARGETS)
