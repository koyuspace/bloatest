GO=go
GOFLAGS=-mod=vendor
PREFIX=/usr/local
BINPATH=$(PREFIX)/bin
SHAREPATH=$(PREFIX)/share/bloatest

TMPL=templates/*.tmpl
SRC=main.go		\
	config/*.go 	\
	mastodon/*.go	\
	model/*.go	\
	renderer/*.go 	\
	repo/*.go 	\
	service/*.go 	\
	util/*.go 	\

all: bloatest bloatest.def.conf

bloatest: $(SRC) $(TMPL)
	$(GO) build $(GOFLAGS) -o bloatest main.go

bloatest.def.conf:
	sed -e "s%=database%=/var/bloatest%g" \
		-e "s%=templates%=$(SHAREPATH)/templates%g" \
		-e "s%=static%=$(SHAREPATH)/static%g" \
		< bloatest.conf > bloatest.def.conf

install: bloatest
	mkdir -p $(DESTDIR)$(BINPATH) \
		$(DESTDIR)$(SHAREPATH)/templates \
		$(DESTDIR)$(SHAREPATH)/static
	cp bloatest $(DESTDIR)$(BINPATH)/bloatest
	chmod 0755 $(DESTDIR)$(BINPATH)/bloatest
	cp -r templates/* $(DESTDIR)$(SHAREPATH)/templates
	chmod 0644 $(DESTDIR)$(SHAREPATH)/templates/*
	cp -r static/* $(DESTDIR)$(SHAREPATH)/static
	chmod 0644 $(DESTDIR)$(SHAREPATH)/static/*

uninstall:
	rm -f $(DESTDIR)$(BINPATH)/bloatest
	rm -fr $(DESTDIR)$(SHAREPATH)

clean: 
	rm -f bloatest
	rm -f bloatest.def.conf
