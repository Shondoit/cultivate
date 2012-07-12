openssl:=OPENSSL

OPENSSL_VER:=1.0.1c
OPENSSL_PKG:=openssl-$(OPENSSL_VER).tar.gz
OPENSSL_URI:=http://www.openssl.org/source/$(OPENSSL_PKG)
OPENSSL_HASH:=2a9eb3cd4e8b114eb9179c0d3884d61658e7d8e8bf4984798a5f5bd48e325ebe

OPENSSL_FLAGS:=-no-rc5 -no-md2 shared zlib
ifndef OS_OSX
OPENSSL_FLAGS+= -no-idea
OPENSSL_CONFIG:=./config
endif

ifdef OS_WIN
OPENSSL_FLAGS+= -Wl,--nxcompat -Wl,--dynamicbase
endif

ifdef OS_OSX
OPENSSL_FLAGS+= -no-man $(BACKWARDS_COMPAT)
ifeq ($(ARCH_TYPE),x86_64)
OPENSSL_CONFIG:=./Configure darwin64-x86_64-cc
else
OPENSSL_CONFIG:=./Configure darwin-i386-cc
endif
endif

OPENSSL_OPTS=$(OPENSSL_FLAGS) --prefix=$(GROW_DIR) --openssldir=$(GROW_DIR) \
	-L$(GROW_DIR)/lib -I$(GROW_DIR)/include
grow-openssl: grow-zlib
	cd $(OPENSSL_DIR) && $(OPENSSL_CONFIG) $(OPENSSL_OPTS)
	cd $(OPENSSL_DIR) && make depend
	cd $(OPENSSL_DIR) && make
	cd $(OPENSSL_DIR) && make install_sw
	touch $(STAMP_DIR)/grow-openssl
