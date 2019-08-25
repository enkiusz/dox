PREFIX ?= /usr
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib

all:
	@echo "dox is a shell script, so there is nothing to do. Try \"make install\" instead."

install:
	@install -v -d "$(DESTDIR)/$(LIBDIR)/dox/extensions"
	@install -v -d "$(DESTDIR)/$(LIBDIR)/dox/platform"
	@install -m 0644 -v src/platform/*.sh "$(DESTDIR)/$(LIBDIR)/dox/platform/"
	@install -v -d "$(DESTDIR)/$(BINDIR)/"
	@install -m 0755 -v src/dox "$(DESTDIR)/$(BINDIR)/dox"
	sed -i'' -e 's:.*SYSTEM_EXTENSION_DIR=".*:SYSTEM_EXTENSION_DIR="$(DESTDIR)/$(LIBDIR)/dox/extensions":' "$(DESTDIR)/$(BINDIR)/dox"
	sed -i'' -e 's:.*# LIBRARY_DIRECTORY.*:LIBDIR="$(DESTDIR)/$(LIBDIR)":' "$(DESTDIR)/$(BINDIR)/dox"

uninstall:
	@rm -vrf \
		"$(DESTDIR)/$(BINDIR)/dox" \
		"$(DESTDIR)/$(LIBDIR)/dox"

.PHONY: all install uninstall
