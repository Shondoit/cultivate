vidalia:=VIDALIA

VIDALIA_VER:=0.2.19
VIDALIA_PKG:=vidalia-$(VIDALIA_VER).tar.gz
VIDALIA_URI:=https://archive.torproject.org/tor-package-archive/vidalia/$(VIDALIA_PKG)
VIDALIA_HASH:=34da5fbfed9a1455b527104f1a34a6d863b62e854a0aa6bcba5a1013743e8153
VIDALIA_SIG:=https://archive.torproject.org/tor-package-archive/vidalia/$(VIDALIA_PKG).asc
VIDALIA_KEYS:=0x9A753A6B

ifdef OS_WIN
VIDALIA_OPTS=-DCMAKE_BUILD_TYPE=minsizerel -DQT_QMAKE_EXECUTABLE=$(QT_DIR)/bin/qmake \
	-DMINGW_BINARY_DIR=/mingw/bin -DWIX_BINARY_DIR=$(WIX_DIR) \
	-DCMAKE_EXE_LINKER_FLAGS="-static-libstdc++ -Wl,--nxcompat -Wl,--dynamicbase" -DWIN2K=1
grow-vidalia: PATH+=:$(QT_DIR)/bin
grow-vidalia: $(QT_LIB) | grow-wix
	mkdir -p $(VIDALIA_DIR)/build
	cd $(VIDALIA_DIR)/build && cmake -G "MSYS Makefiles" $(VIDALIA_OPTS) ..
	cd $(VIDALIA_DIR)/build && make -j $(NUM_CORES)
	touch $(STAMP_DIR)/grow-vidalia
endif

ifdef OS_LINUX
VIDALIA_OPTS=-DCMAKE_BUILD_TYPE=debug -DQT_QMAKE_EXECUTABLE=$(GROW_DIR)/bin/qmake
grow-vidalia: grow-qt
	mkdir -p $(VIDALIA_DIR)/build
	cd $(VIDALIA_DIR)/build && cmake $(VIDALIA_OPTS) .. && make -j $(NUM_CORES)
	cd $(VIDALIA_DIR)/build && DESTDIR=$(GROW_DIR) make install
	touch $(STAMP_DIR)/grow-vidalia
endif

ifdef OS_OSX
VIDALIA_OPTS= -DQT_QMAKE_EXECUTABLE=$(GROW_DIR)/bin/qmake \
	-DCMAKE_BUILD_TYPE=debug -DCMAKE_OSX_ARCHITECTURES=$(ARCH_TYPE)
grow-vidalia: grow-qt
	mkdir -p $(VIDALIA_DIR)/build
	cd $(VIDALIA_DIR)/build \
		&& MACOSX_DEPLOYMENT_TARGET=$(OSX_VERSION) cmake $(VIDALIA_OPTS) .. \
		&& make -j $(NUM_CORES) \
		&& make dist-osx-libraries
	cd $(VIDALIA_DIR)/build \
		&& DESTDIR=$(GROW_DIR) make install
	cp -r $(QT_DIR)/src/gui/mac/qt_menu.nib $(VIDALIA)/Contents/Resources/
	touch $(STAMP_DIR)/grow-vidalia
endif
