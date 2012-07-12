tbb-alpha:=TBB_ALPHA

TBB_ALPHA_VER=$(TOR_ALPHA_VER)-1
TBB_ALPHA_DEPS:=tor-alpha vidalia-alpha firefox relative-link \
	torbutton noscript https-everywhere-alpha vidalia-plugins

TBB_ALPHA_INSTALL_EXTENSION=cp -rf $(1) \
	$(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/Data/profile/extensions/`./extract-xpi-id.sh $(1)`

graft-tbb-alpha:
	rm -rf $(TBB_ALPHA_GRAFT_DIR)

### Create directory structure
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/App
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/App/script
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Data/Tor
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Data/Vidalia
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Data/Vidalia/plugins
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Docs/Tor
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Docs/Qt
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Docs/Tor
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Docs/Vidalia
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/Docs/MinGW

### Install binaries
	cp /mingw/bin/mingwm10.dll $(TBB_ALPHA_GRAFT_DIR)/App
	cp $(QT_DIR)/bin/QtCore4.dll $(QT_DIR)/bin/QtGui4.dll \
		$(QT_DIR)/bin/QtNetwork4.dll $(QT_DIR)/bin/QtXml4.dll \
		$(QT_DIR)/bin/QtScript4.dll $(QT_DIR)/bin/libgcc_s_dw2-1.dll \
		$(TBB_ALPHA_GRAFT_DIR)/App
	cp $(OPENSSL_DIR)/ssleay32.dll $(OPENSSL_DIR)/libeay32.dll \
		$(TBB_ALPHA_GRAFT_DIR)/App
	cp $(VIDALIA_ALPHA_DIR)/build/src/vidalia/vidalia.exe \
		$(TBB_ALPHA_GRAFT_DIR)/App
	cp $(TOR_ALPHA_DIR)/src/or/tor.exe \
		$(TBB_ALPHA_GRAFT_DIR)/App
	cp $(QT_SCRIPT_DIR)/plugins/script/*.dll \
		$(TBB_ALPHA_GRAFT_DIR)/App/script
### Install FirefoxPortable
	cp -rf ./contrib/tbb-alpha/FirefoxPortable $(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable
	cp "/c/Program Files (x86)/Microsoft Visual Studio 9.0/VC/redist/x86/Microsoft.VC90.CRT/"msvc*90.dll \
		$(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/App/Firefox
	cp -rf $(FIREFOX_DIR)/obj-*/dist/firefox/* \
		$(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/App/Firefox
### Install launcher
ifdef OS_WIN
	cp $(REL_LINK_DIR)/StartTorBrowserBundle.exe \
		"$(TBB_ALPHA_GRAFT_DIR)/Start Tor Browser.exe"
endif
ifdef OS_LINUX
	cp $(REL_LINK_DIR)/RelativeLink-linux.sh \
		$(TBB_ALPHA_GRAFT_DIR)/start-tor-browser
	chmod +x $(TBB_ALPHA_GRAFT_DIR)/start-tor-browser
endif
ifdef OS_OSX
	cp $(REL_LINK_DIR)/RelativeLink-osx.sh \
		$(TBB_ALPHA_GRAFT_DIR)/Contents/MacOS/TorBrowserBundle
	chmod +x $(TBB_ALPHA_GRAFT_DIR)/Contents/MacOS/TorBrowserBundle
endif

### Install extensions
	mkdir -p $(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/Data/profile/extensions
	$(call TBB_ALPHA_INSTALL_EXTENSION,$(TORBUTTON_DIR))
	$(call TBB_ALPHA_INSTALL_EXTENSION,$(NOSCRIPT_DIR))
	$(call TBB_ALPHA_INSTALL_EXTENSION,$(HTTPS_EVERYWHERE_ALPHA_DIR))

### Install docs
	cp $(VIDALIA_ALPHA_DIR)/LICENSE* $(VIDALIA_ALPHA_DIR)/CREDITS \
		$(TBB_ALPHA_GRAFT_DIR)/Docs/Vidalia
	cp $(TOR_ALPHA_DIR)/LICENSE $(TOR_ALPHA_DIR)/README \
		$(TBB_ALPHA_GRAFT_DIR)/Docs/Tor
	cp $(QT_DIR)/LICENSE.GPL* $(QT_DIR)/LICENSE.LGPL \
		$(TBB_ALPHA_GRAFT_DIR)/Docs/Qt
	cp /mingw/msys/1.0/share/doc/MSYS/COPYING \
		$(TBB_ALPHA_GRAFT_DIR)/Docs/MinGW
	cp ./docs/tbb-alpha/changelog.$(PLATFORM) \
		$(TBB_ALPHA_GRAFT_DIR)/Docs/changelog
	cp ./docs/tbb-alpha/README.$(PLATFORM) \
		$(TBB_ALPHA_GRAFT_DIR)/Docs/README-TorBrowserBundle

### Install configurations
	mv $(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/App/Firefox/firefox.exe \
		$(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/App/Firefox/tbb-firefox.exe
	cp -rf ./contrib/tbb-alpha/Data/* \
		$(TBB_ALPHA_GRAFT_DIR)/Data
	cp $(TOR_ALPHA_DIR)/src/config/geoip \
		$(TBB_ALPHA_GRAFT_DIR)/Data/Tor/geoip
	cp -r $(VIDALIA_PLUGINS_DIR)/tbb \
		$(TBB_ALPHA_GRAFT_DIR)/Data/Vidalia/plugins
	printf 'user_pref("torbrowser.version", "%s");\n' "$(TBB_VER)-$(PLATFORM)" \
		>> $(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/Data/profile/prefs.js
	printf 'user_pref("torbrowser.version", "%s");\n' "$(TBB_VER)-$(PLATFORM)" \
		>> $(TBB_ALPHA_GRAFT_DIR)/FirefoxPortable/App/DefaultData/profile/prefs.js

	touch $(STAMP_DIR)/graft-tbb-alpha
