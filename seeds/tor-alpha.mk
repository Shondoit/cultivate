tor-alpha:=TOR_ALPHA

TOR_ALPHA_VER:=0.2.3.19-rc
TOR_ALPHA_PKG:=tor-$(TOR_ALPHA_VER).tar.gz
TOR_ALPHA_URI:=https://archive.torproject.org/tor-package-archive/$(TOR_ALPHA_PKG)
TOR_ALPHA_HASH:=af9722675e525b915647f0d1f871db5a1562e7a18681ea259e04ce26b8425d73
TOR_ALPHA_SIG:=https://archive.torproject.org/tor-package-archive/$(TOR_ALPHA_PKG).asc
TOR_ALPHA_KEYS:=0x28988BF5 0x19F78451 0x165733EA 0x8D29319A

ifdef OS_LINUX
TOR_ALPHA_OPTS=--with-openssl-dir=$(GROW_DIR) --with-zlib-dir=$(GROW_DIR) \
	--with-libevent-dir=$(GROW_DIR)/lib
endif

ifdef OS_OSX
TOR_ALPHA_CFLAGS=CFLAGS="-arch $(ARCH_TYPE) -I$(GROW_DIR)/include $(MIN_VERSION) $(CF_MIN_VERSION)"
TOR_ALPHA_LDFLAGS=LDFLAGS="-L$(GROW_DIR)/lib $(LD_MIN_VERSION)"
TOR_ALPHA_OPTS=--enable-static-openssl --enable-static-libevent \
	--with-openssl-dir=$(GROW_DIR)/lib --with-libevent-dir=$(GROW_DIR)/lib \
	--disable-dependency-tracking $(CC)
endif

ifdef OS_WIN
TOR_ALPHA_CFLAGS=CFLAGS="-I$(GROW_DIR)/include"
TOR_ALPHA_LDFLAGS=LDFLAGS="-L$(GROW_DIR)/lib -L$(GROW_DIR)/bin"
TOR_ALPHA_OPTS=--enable-static-libevent --with-libevent-dir=$(GROW_DIR)/lib --disable-asciidoc
grow-tor-alpha:PATH+=:$(GROW_DIR)/bin
endif

grow-tor-alpha: grow-zlib grow-openssl grow-libevent
	cd $(TOR_ALPHA_DIR) && $(TOR_ALPHA_CFLAGS) $(TOR_ALPHA_LDFLAGS) ./configure $(TOR_ALPHA_OPTS) \
		--enable-gcc-warnings-advisory --prefix=$(GROW_DIR)
	cd $(TOR_ALPHA_DIR) && make -j $(NUM_CORES)
	cd $(TOR_ALPHA_DIR) && make install
	touch $(STAMP_DIR)/grow-tor-alpha
