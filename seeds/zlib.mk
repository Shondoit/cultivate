zlib:=ZLIB

ZLIB_VER:=1.2.7
ZLIB_PKG:=zlib-$(ZLIB_VER).tar.gz
ZLIB_URI:=http://zlib.net/$(ZLIB_PKG)
ZLIB_HASH:=fa9c9c8638efb8cb8ef5e4dd5453e455751e1c530b1595eed466e1be9b7e26c5

ifdef OS_WIN

ZLIB_OPTS:=prefix="$(GROW_DIR)" BINARY_PATH="$(GROW_DIR)/bin" \
	INCLUDE_PATH="$(GROW_DIR)/include" LIBRARY_PATH="$(GROW_DIR)/lib"
ZLIB_LDFLAGS:=LDFLAGS="-Wl,--nxcompat -Wl,--dynamicbase"
grow-zlib:
	cd $(ZLIB_DIR) && $(ZLIB_LDFLAGS) make -f win32/Makefile.gcc -j $(NUM_CORES)
	cd $(ZLIB_DIR) && $(ZLIB_OPTS) make -f win32/Makefile.gcc install
	touch $(STAMP_DIR)/grow-zlib
	
else

ZLIB_OPTS:=--prefix=$(GROW_DIR)
ifdef OS_OSX
ZLIB_CFLAGS:=CFLAGS="-arch $(ARCH_TYPE)"
endif
grow-zlib:
	cd $(ZLIB_DIR) && $(ZLIB_CFLAGS) ./configure $(ZLIB_OPTS)
	cd $(ZLIB_DIR) && make -j $(NUM_CORES)
	cd $(ZLIB_DIR) && make install
	touch $(STAMP_DIR)/grow-zlib
	
endif
