prefix=${HOME}/sf/filter_vcf/current

all:
	mkdir -p bin
	mkdir -p doc
	cp filter_vcf.pl vcfcmp bin/
	cp README.md doc/
	chmod 755 bin/*
	chmod 644 doc/*
install: filter_vcf.pl vcfcmp
	mkdir -p $(prefix)/bin
	mkdir -p $(prefix)/doc
	install -p -m 0755 bin/* $(prefix)/bin/
	install -p -m 0644 doc/* $(prefix)/doc/
clean:
	rm -rf bin
	rm -rf doc
