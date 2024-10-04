include ../../../adm/root.mk
include $(MFEXT_HOME)/share/package.mk

export NAME=mapserver
export VERSION=8.2.2
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=9bc8e375493f59ac1ef282b127096ec4
DESCRIPTION=\
MapServer is an Open Source platform for publishing spatial data and interactive mapping applications to the web.
WEBSITE=http://mapserver.org
LICENSE=MIT

all:: $(PREFIX)/bin/mapserv $(PREFIX)/etc/mapserver.conf
$(PREFIX)/bin/mapserv:
	$(MAKE) --file=$(MFEXT_HOME)/share/Makefile.standard OPTIONS="-DWITH_CURL=1 -DWITH_GIF=0 -DWITH_FCGI=0 -DWITH_PROTOBUFC=1 -DWITH_RSVG=1 -DCMAKE_PREFIX_PATH='$(PREFIX);$(PREFIX)/../scientific_core;$(PREFIX)/../core'" download uncompress configure_cmake cmake build_cmake install_cmake
	mkdir -p $(PREFIX)/etc $(PREFIX)/tests $(PREFIX)/share/ogcapi
	cp build/$(NAME)-$(VERSION)/tests/test.map $(PREFIX)/tests
	cp -R build/$(NAME)-$(VERSION)/share/ogcapi/templates $(PREFIX)/share/ogcapi

$(PREFIX)/etc/mapserver.conf:
	cat mapserver.conf | sed "s:PREFIX:$(PREFIX):" > $(PREFIX)/etc/mapserver.conf
