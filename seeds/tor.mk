tor:=TOR

TOR_VER:=0.2.2.37
TOR_PKG:=tor-$(TOR_VER).tar.gz
TOR_URI:=https://archive.torproject.org/tor-package-archive/$(TOR_PKG)
TOR_HASH:=ae2c1fb52babd9e92264ac7c4486d3e941be6deb91b8a590965848fbbcbd9e88
TOR_SIG:=https://archive.torproject.org/tor-package-archive/$(TOR_PKG).asc
TOR_KEYS:=0x28988BF5 0x19F78451 0x165733EA 0x8D29319A

ifdef OS_LINUX
TOR_OPTS=--with-openssl-dir=$(GROW_DIR) --with-zlib-dir=$(GROW_DIR) \
	--with-libevent-dir=$(GROW_DIR)/lib
endif

ifdef OS_OSX
TOR_CFLAGS=CFLAGS="-arch $(ARCH_TYPE) -I$(GROW_DIR)/include $(MIN_VERSION) $(CF_MIN_VERSION)"
TOR_LDFLAGS=LDFLAGS="-L$(GROW_DIR)/lib $(LD_MIN_VERSION)"
TOR_OPTS=--enable-static-openssl --enable-static-libevent \
	--with-openssl-dir=$(GROW_DIR)/lib --with-libevent-dir=$(GROW_DIR)/lib \
	--disable-dependency-tracking $(CC)
endif

ifdef OS_WIN
TOR_CFLAGS=CFLAGS="-I$(GROW_DIR)/include"
TOR_LDFLAGS=LDFLAGS="-L$(GROW_DIR)/lib -L$(GROW_DIR)/bin"
TOR_OPTS=--enable-static-libevent --with-libevent-dir=$(GROW_DIR)/lib --disable-asciidoc
grow-tor:PATH+=:$(GROW_DIR)/bin
endif

grow-tor: grow-zlib grow-openssl grow-libevent
	cd $(TOR_DIR) && $(TOR_CFLAGS) $(TOR_LDFLAGS) ./configure $(TOR_OPTS) \
		--enable-gcc-warnings-advisory --prefix=$(GROW_DIR)
	cd $(TOR_DIR) && make -j $(NUM_CORES)
	cd $(TOR_DIR) && make install
	touch $(STAMP_DIR)/grow-tor
