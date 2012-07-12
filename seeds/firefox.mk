firefox:=FIREFOX

FIREFOX_NAME:=firefox-esr
FIREFOX_VER:=13.0.1
FIREFOX_PKG:=firefox-$(FIREFOX_VER).source.tar.bz2
FIREFOX_URI:=https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$(FIREFOX_VER)/source/$(FIREFOX_PKG)
FIREFOX_HASH:=c196d07db249735cbe61949ecafe20b9df262b817b44b8a595d3e6daf2d09be3
FIREFOX_SIG:=https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$(FIREFOX_VER)/source/$(FIREFOX_PKG).asc
FIREFOX_KEYS:=0x1EBCAB3A

ifdef OS_WIN
grow-firefox: | grow-mozbuild grow-pymake
#XXX: Autodetect MSVC
	cd $(MOZBUILD_DIR) && cmd.exe /c "start-msvc9.bat \
		$(abspath $(FIREFOX_DIR)) $(PYTHON) $(abspath $(PYMAKE_DIR)/make.py)"
	touch $(STAMP_DIR)/grow-firefox
else
grow-firefox:
ifdef OS_OSX
	cp $(FIREFOX_DIR)/mozconfig-osx-$(ARCH_TYPE) $(FIREFOX_DIR)/mozconfig
endif
	cd $(FIREFOX_DIR) && make -f client.mk build
ifdef OS_LINUX
	cd $(FIREFOX_DIR) && make -C obj-$(ARCH_TYPE)-* package INNER_MAKE_PACKAGE=true
endif
	touch $(STAMP_DIR)/grow-firefox
endif
