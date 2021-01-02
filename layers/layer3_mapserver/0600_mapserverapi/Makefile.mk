include ../../../adm/root.mk
include $(MFEXT_HOME)/share/package.mk

export NAME=mapserverapi
export VERSION=0.1.5
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=2156883fa301113c61350fb31ebbceb8
DESCRIPTION=\
tiny C library to invoke mapserver engine as a library
WEBSITE=https://github.com/metwork-framework/mapserverapi
LICENSE=BSD

all::$(PREFIX)/lib/libmapserverapi.so
$(PREFIX)/lib/libmapserverapi.so:
	$(MAKE) --file=$(MFEXT_HOME)/share/Makefile.standard MAKEOPT="PREFIX=$(PREFIX) MAPSERVER_LIB_DIR=$(PREFIX)/lib" download uncompress build install
