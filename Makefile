PREFIX ?= /usr
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib

BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions
ZSHCOMPDIR ?= $(PREFIX)/share/zsh/site-functions
FISHCOMPDIR ?= $(PREFIX)/share/fish/vendor_completions.d

ifneq ($(WITH_ALLCOMP),)
WITH_BASHCOMP := $(WITH_ALLCOMP)
WITH_ZSHCOMP := $(WITH_ALLCOMP)
WITH_FISHCOMP := $(WITH_ALLCOMP)
endif
ifeq ($(WITH_BASHCOMP),)
ifneq ($(strip $(wildcard $(BASHCOMPDIR))),)
WITH_BASHCOMP := yes
endif
endif
ifeq ($(WITH_ZSHCOMP),)
ifneq ($(strip $(wildcard $(ZSHCOMPDIR))),)
WITH_ZSHCOMP := yes
endif
endif
ifeq ($(WITH_FISHCOMP),)
ifneq ($(strip $(wildcard $(FISHCOMPDIR))),)
WITH_FISHCOMP := yes
endif
endif

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
	@[ "$(WITH_BASHCOMP)" = "yes" ] || exit 0; install -v -d "$(DESTDIR)$(BASHCOMPDIR)" && install -m 0644 -v src/completion/dox.bash-completion "$(DESTDIR)$(BASHCOMPDIR)/dox"
	@[ "$(WITH_ZSHCOMP)" = "yes" ] || exit 0; install -v -d "$(DESTDIR)$(ZSHCOMPDIR)" && install -m 0644 -v src/completion/dox.zsh-completion "$(DESTDIR)$(ZSHCOMPDIR)/_dox"
	@[ "$(WITH_FISHCOMP)" = "yes" ] || exit 0; install -v -d "$(DESTDIR)$(FISHCOMPDIR)" && install -m 0644 -v src/completion/dox.fish-completion "$(DESTDIR)$(FISHCOMPDIR)/dox.fish"


uninstall:
	@rm -vrf \
		"$(DESTDIR)/$(BINDIR)/dox" \
		"$(DESTDIR)/$(LIBDIR)/dox" \
		"$(DESTDIR)$(BASHCOMPDIR)/dox" \
		"$(DESTDIR)$(ZSHCOMPDIR)/_dox" \
		"$(DESTDIR)$(FISHCOMPDIR)/dox.fish"

.PHONY: all install uninstall
