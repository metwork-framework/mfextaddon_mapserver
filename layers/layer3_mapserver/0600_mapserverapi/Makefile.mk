include ../../../adm/root.mk
include $(MFEXT_HOME)/share/package.mk

export NAME=mapserverapi
export VERSION=0.1.6
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=9b997553af735a4a127871cc052c7ce6
DESCRIPTION=\
tiny C library to invoke mapserver engine as a library
WEBSITE=https://github.com/metwork-framework/mapserverapi
LICENSE=BSD

all::$(PREFIX)/lib/libmapserverapi.so
$(PREFIX)/lib/libmapserverapi.so:
	$(MAKE) --file=$(MFEXT_HOME)/share/Makefile.standard MAKEOPT="PREFIX=$(PREFIX) MAPSERVER_LIB_DIR=$(PREFIX)/lib" download uncompress build install
