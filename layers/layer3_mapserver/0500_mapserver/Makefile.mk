include ../../../adm/root.mk
include $(MFEXT_HOME)/share/package.mk

export NAME=mapserver
export VERSION=7.6.5
export EXTENSION=tar.gz
export CHECKTYPE=MD5
export CHECKSUM=8b19c5ba98ce567a5eae8eb09068f71f
DESCRIPTION=\
MapServer is an Open Source platform for publishing spatial data and interactive mapping applications to the web.
WEBSITE=http://mapserver.org
LICENSE=MIT

all:: $(PREFIX)/bin/mapserv
$(PREFIX)/bin/mapserv:
	$(MAKE) --file=$(MFEXT_HOME)/share/Makefile.standard OPTIONS="-DWITH_CURL=1 -DWITH_GIF=0 -DWITH_FCGI=0 -DWITH_PROTOBUFC=0 -DWITH_RSVG=1 -DCMAKE_PREFIX_PATH='$(PREFIX);$(PREFIX)/../scientific_core;$(PREFIX)/../core'" download uncompress configure_cmake cmake build_cmake install_cmake
