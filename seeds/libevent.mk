libevent:=LIBEVENT

LIBEVENT_VER:=2.0.19-stable
LIBEVENT_PKG:=libevent-$(LIBEVENT_VER).tar.gz
LIBEVENT_URI:=https://github.com/downloads/libevent/libevent/$(LIBEVENT_PKG)
LIBEVENT_HASH:=1591fb411a67876a514a33df54b85417b31e01800284bcc6894fc410c3eaea21
LIBEVENT_SIG:=https://github.com/downloads/libevent/libevent/$(LIBEVENT_PKG).asc
LIBEVENT_KEYS:=0x8D29319A

LIBEVENT_OPTS:=--prefix=$(GROW_DIR)

ifdef OS_WIN
LIBEVENT_CFLAGS=CFLAGS="-I$(GROW_DIR)/include"
LIBEVENT_LDFLAGS=LDFLAGS="-L$(GROW_DIR)/lib -L$(GROW_DIR)/bin -Wl,--nxcompat -Wl,--dynamicbase"
endif

ifdef OS_OSX
LIBEVENT_CFLAGS=CFLAGS="-arch $(ARCH_TYPE) $(MIN_VERSION) $(CF_MIN_VERSION) -arch $(ARCH_TYPE)"
LIBEVENT_LDFLAGS=LDFLAGS="-L$(BUILT_DIR)/lib $(LD_MIN_VERSION)"
endif

ifndef OS_LINUX
LIBEVENT_OPTS+= --enable-static --disable-shared --disable-dependency-tracking
endif

grow-libevent: grow-zlib grow-openssl
	cd $(LIBEVENT_DIR) && $(LIBEVENT_CFLAGS) $(LIBEVENT_LDFLAGS) ./configure $(LIBEVENT_OPTS)
	cd $(LIBEVENT_DIR) && make -j $(NUM_CORES)
	cd $(LIBEVENT_DIR) && make install
	touch $(STAMP_DIR)/grow-libevent
