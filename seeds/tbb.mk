tbb:=TBB

TBB_VER=$(TOR_VER)-1
TBB_DEPS:=tor vidalia firefox-esr relative-link \
	torbutton noscript https-everywhere
ifdef OS_LINUX
TBB_DEPS+=libpng
endif

TBB_INSTALL_EXTENSION=cp -rf $(1) \
	$(TBB_GRAFT_DIR)/$(TBB_FF_PROF_DIR)/`./extract-xpi-id.sh $(1)`

ifdef OS_WIN
	TBB_FF_BIN_DIR:=FirefoxPortable/App/Firefox
	TBB_FF_DEFPROF_DIR:=FirefoxPortable/App/DefaultData/profile
	TBB_FF_PROF_DIR:=FirefoxPortable/Data/profile
	TBB_BIN_EXT:=.exe
endif
ifdef OS_LINUX
	TBB_FF_BIN_DIR:=App/Firefox
	TBB_FF_DEFPROF_DIR:=App/Firefox/defaults/profile
	TBB_FF_PROF_DIR:=Data/profile
endif
graft-tbb:
	rm -rf $(TBB_GRAFT_DIR)

### Create directory structure
	mkdir -p $(TBB_GRAFT_DIR)/App
	mkdir -p $(TBB_GRAFT_DIR)/Data/Tor
	mkdir -p $(TBB_GRAFT_DIR)/Data/Vidalia
	mkdir -p $(TBB_GRAFT_DIR)/Docs/Tor
	mkdir -p $(TBB_GRAFT_DIR)/Docs/Qt
	mkdir -p $(TBB_GRAFT_DIR)/Docs/Tor
	mkdir -p $(TBB_GRAFT_DIR)/Docs/Vidalia
	mkdir -p $(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)
	mkdir -p $(TBB_GRAFT_DIR)/$(TBB_FF_PROF_DIR)
	mkdir -p $(TBB_GRAFT_DIR)/$(TBB_FF_DEFPROF_DIR)
ifdef OS_WIN
	mkdir -p $(TBB_GRAFT_DIR)/Docs/MinGW
endif
ifdef OS_LINUX
	mkdir -p $(TBB_GRAFT_DIR)/Lib
	mkdir -p $(TBB_GRAFT_DIR)/Lib/libz
endif

	cp $(VIDALIA_DIR)/build/src/vidalia/vidalia$(TBB_BIN_EXT) \
		$(TBB_GRAFT_DIR)/App
	cp $(TOR_DIR)/src/or/tor$(TBB_BIN_EXT) \
		$(TBB_GRAFT_DIR)/App
	cp -rf $(FIREFOX_ESR_DIR)/obj-*/dist/firefox/* \
		$(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)
### Install binaries
ifdef OS_WIN
	cp /mingw/bin/mingwm10.dll $(TBB_GRAFT_DIR)/App
	cp $(QT_DIR)/bin/QtCore4.dll $(QT_DIR)/bin/QtGui4.dll \
		$(QT_DIR)/bin/QtNetwork4.dll $(QT_DIR)/bin/QtXml4.dll \
		$(QT_DIR)/bin/libgcc_s_dw2-1.dll \
		$(TBB_GRAFT_DIR)/App

	cp $(OPENSSL_DIR)/ssleay32.dll $(OPENSSL_DIR)/libeay32.dll \
		$(TBB_GRAFT_DIR)/App
	cp $(VIDALIA_DIR)/build/src/vidalia/vidalia.exe \
		$(TBB_GRAFT_DIR)/App
	cp $(TOR_DIR)/src/or/tor.exe \
		$(TBB_GRAFT_DIR)/App

	cp -rf ./contrib/tbb/FirefoxPortable/* \
		$(TBB_GRAFT_DIR)/FirefoxPortable
	cp "/c/Program Files (x86)/Microsoft Visual Studio 9.0/VC/redist/x86/Microsoft.VC90.CRT/"msvc*90.dll \
		$(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)
	mv $(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)/firefox.exe \
		$(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)/tbb-firefox.exe

	cp $(REL_LINK_DIR)/StartTorBrowserBundle.exe \
		"$(TBB_GRAFT_DIR)/Start Tor Browser.exe"
endif

ifdef OS_LINUX
	cp -d $(QT_DIR)/lib/libQtCore.so* $(QT_DIR)/lib/libQtGui.so* \
		$(QT_DIR)/lib/libQtNetwork.so* $(QT_DIR)/lib/libQtXml.so* \
		$(TBB_GRAFT_DIR)/Lib
	cp -d $(ZLIB_DIR)/libz.so* \
		$(TBB_GRAFT_DIR)/Lib/libz
	cp -d $(GROW_DIR)/lib/libevent.so $(GROW_DIR)/lib/libevent-2.0.so* \
		$(GROW_DIR)/lib/libevent_core.so $(GROW_DIR)/lib/libevent_core-2.0.so* \
		$(GROW_DIR)/lib/libevent_extra.so $(GROW_DIR)/lib/libevent_extra-2.0.so* \
		$(TBB_GRAFT_DIR)/Lib
	cp -d $(GROW_DIR)/lib/libpng15.so* \
		$(TBB_GRAFT_DIR)/Lib
	cp -d $(OPENSSL_DIR)/libssl.so* $(OPENSSL_DIR)/libcrypto.so* \
		$(TBB_GRAFT_DIR)/Lib
	chmod 644 $(TBB_GRAFT_DIR)/Lib/libssl.so*
	chmod 644 $(TBB_GRAFT_DIR)/Lib/libcrypto.so*

	rm -f $(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)/components/libnkgnomevfs.so
	rm -f $(TBB_GRAFT_DIR)/$(TBB_FF_BIN_DIR)/components/libmozgnome.so

	chmod 700 $(TBB_GRAFT_DIR)/Data/Tor

	cp $(REL_LINK_DIR)/RelativeLink-linux.sh \
		$(TBB_GRAFT_DIR)/start-tor-browser
	chmod +x $(TBB_GRAFT_DIR)/start-tor-browser
endif

ifdef OS_OSX
	cp $(REL_LINK_DIR)/RelativeLink-osx.sh \
		$(TBB_GRAFT_DIR)/Contents/MacOS/TorBrowserBundle
	chmod +x $(TBB_GRAFT_DIR)/Contents/MacOS/TorBrowserBundle
endif

### Install extensions
	mkdir -p $(TBB_GRAFT_DIR)/$(TBB_FF_PROF_DIR)/extensions
	$(call TBB_INSTALL_EXTENSION,$(TORBUTTON_DIR))
	$(call TBB_INSTALL_EXTENSION,$(NOSCRIPT_DIR))
	$(call TBB_INSTALL_EXTENSION,$(HTTPS_EVERYWHERE_DIR))

### Install docs
	cp $(VIDALIA_DIR)/LICENSE* $(VIDALIA_DIR)/CREDITS \
		$(TBB_GRAFT_DIR)/Docs/Vidalia
	cp $(TOR_DIR)/LICENSE $(TOR_DIR)/README \
		$(TBB_GRAFT_DIR)/Docs/Tor
	cp $(QT_DIR)/LICENSE.GPL* $(QT_DIR)/LICENSE.LGPL \
		$(TBB_GRAFT_DIR)/Docs/Qt
	cp ./docs/tbb/changelog.$(PLATFORM) \
		$(TBB_GRAFT_DIR)/Docs/changelog
	cp ./docs/tbb/README.$(PLATFORM) \
		$(TBB_GRAFT_DIR)/Docs/README-TorBrowserBundle
ifdef OS_WIN
	cp /mingw/msys/1.0/share/doc/MSYS/COPYING \
		$(TBB_GRAFT_DIR)/Docs/MinGW
endif

### Install configurations
	cp -rf ./contrib/tbb/Data-$(PLATFORM)/* \
		$(TBB_GRAFT_DIR)/Data
	cp $(TOR_DIR)/src/config/geoip \
		$(TBB_GRAFT_DIR)/Data/Tor/geoip
	printf 'user_pref("torbrowser.version", "%s");\n' "$(TBB_VER)-$(PLATFORM)" \
		>> $(TBB_GRAFT_DIR)/$(TBB_FF_DEFPROF_DIR)/prefs.js
	printf 'user_pref("torbrowser.version", "%s");\n' "$(TBB_VER)-$(PLATFORM)" \
		>> $(TBB_GRAFT_DIR)/$(TBB_FF_PROF_DIR)/prefs.js

	touch $(STAMP_DIR)/graft-tbb
