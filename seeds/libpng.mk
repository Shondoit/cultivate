#ifdef OS_LINUX

libpng:=LIBPNG

LIBPNG_VER:=1.5.12
LIBPNG_PKG:=libpng-$(LIBPNG_VER).tar.bz2
LIBPNG_URI:=ftp://ftp.simplesystems.org/pub/libpng/png/src/$(LIBPNG_PKG)
LIBPNG_HASH:=e83c4897bb92a7c67e6610a56676f2fdc213fe2995e9c1fef6f0cf7d70b30976

LIBPNG_OPTS=--prefix=$(GROW_DIR)
grow-libpng:
	cd $(LIBPNG_DIR) && ./configure $(LIBPNG_OPTS)
	cd $(LIBPNG_DIR) && make
	cd $(LIBPNG_DIR) && make install
	touch $(STAMP_DIR)/grow-libpng

#endif