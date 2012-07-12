vidalia-alpha:=VIDALIA_ALPHA

VIDALIA_ALPHA_VER:=0.3.1
VIDALIA_ALPHA_PKG:=vidalia-$(VIDALIA_ALPHA_VER).tar.gz
VIDALIA_ALPHA_URI:=https://archive.torproject.org/tor-package-archive/vidalia/$(VIDALIA_ALPHA_PKG)
VIDALIA_ALPHA_HASH:=1523d31ea6a3eaa11d4665eccfcb2dc755a4c6945d9e2d311032a300a9e583d7
VIDALIA_ALPHA_SIG:=https://archive.torproject.org/tor-package-archive/vidalia/$(VIDALIA_ALPHA_PKG).asc
VIDALIA_ALPHA_KEYS:=0x9A753A6B

ifdef OS_WIN
VIDALIA_ALPHA_OPTS=-DCMAKE_BUILD_TYPE=minsizerel -DQT_QMAKE_EXECUTABLE=$(QT_DIR)/bin/qmake \
	-DMINGW_BINARY_DIR=/mingw/bin -DTOR_SOURCE_DIR=$(TOR_ALPHA_DIR) \
	-DWIX_BINARY_DIR=$(WIX_DIR) -DSCRIPT_DIR=$(QT_SCRIPT_DIR)/plugins/script \
	-DCMAKE_EXE_LINKER_FLAGS="-static-libstdc++ -Wl,--nxcompat -Wl,--dynamicbase" -DWIN2K=1
grow-vidalia-alpha: PATH+=:$(QT_DIR)/bin
grow-vidalia-alpha: grow-qt grow-tor-alpha grow-qt-script | grow-wix
	mkdir -p $(VIDALIA_ALPHA_DIR)/build
	cd $(VIDALIA_ALPHA_DIR)/build && cmake -G "MSYS Makefiles" $(VIDALIA_ALPHA_OPTS) ..
	cd $(VIDALIA_ALPHA_DIR)/build && make -j $(NUM_CORES)
	touch $(STAMP_DIR)/grow-vidalia-alpha
endif

ifdef OS_LINUX
VIDALIA_ALPHA_OPTS=-DCMAKE_BUILD_TYPE=debug -DQT_QMAKE_EXECUTABLE=$(GROW_DIR)/bin/qmake
grow-vidalia-alpha: grow-qt grow-tor-alpha grow-qt-script
	mkdir -p $(VIDALIA_ALPHA_DIR)/build
	cd $(VIDALIA_ALPHA_DIR)/build && cmake $(VIDALIA_ALPHA_OPTS) .. && make -j $(NUM_CORES)
	cd $(VIDALIA_ALPHA_DIR)/build && DESTDIR=$(GROW_DIR) make install
	touch $(STAMP_DIR)/grow-vidalia-alpha
endif

ifdef OS_OSX
VIDALIA_ALPHA_OPTS= -DQT_QMAKE_EXECUTABLE=$(GROW_DIR)/bin/qmake \
	-DCMAKE_BUILD_TYPE=debug -DCMAKE_OSX_ARCHITECTURES=$(ARCH_TYPE)
grow-vidalia-alpha: grow-qt grow-tor-alpha grow-qt-script
	mkdir -p $(VIDALIA_ALPHA_DIR)/build
	cd $(VIDALIA_ALPHA_DIR)/build \
		&& MACOSX_DEPLOYMENT_TARGET=$(OSX_VERSION) cmake $(VIDALIA_ALPHA_OPTS) .. \
		&& make -j $(NUM_CORES) \
		&& make dist-osx-libraries
	cd $(VIDALIA_ALPHA_DIR)/build \
		&& DESTDIR=$(GROW_DIR) make install
	cp -r $(QT_DIR)/src/gui/mac/qt_menu.nib $(VIDALIA)/Contents/Resources/
	touch $(STAMP_DIR)/grow-vidalia-alpha
endif
