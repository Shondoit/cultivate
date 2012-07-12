firefox-esr:=FIREFOX_ESR

FIREFOX_ESR_NAME:=firefox-esr
FIREFOX_ESR_VER:=10.0.5esr
FIREFOX_ESR_PKG:=firefox-$(FIREFOX_ESR_VER).source.tar.bz2
FIREFOX_ESR_URI:=https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$(FIREFOX_ESR_VER)/source/$(FIREFOX_ESR_PKG)
FIREFOX_ESR_HASH:=c91c0418ad199ea6950a31ad9097ba306970115887b51bbc2a5672edb462179c
FIREFOX_ESR_SIG:=https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$(FIREFOX_ESR_VER)/source/$(FIREFOX_ESR_PKG).asc
FIREFOX_ESR_KEYS:=0x1EBCAB3A

ifdef OS_WIN
grow-firefox-esr: | grow-mozbuild grow-pymake
#XXX: Autodetect MSVC
	cd $(MOZBUILD_DIR) && cmd.exe /c "start-msvc9.bat \
		$(abspath $(FIREFOX_ESR_DIR)) $(PYTHON) $(abspath $(PYMAKE_DIR)/make.py)"
	touch $(STAMP_DIR)/grow-firefox-esr
else
grow-firefox-esr:
ifdef OS_OSX
	cp $(FIREFOX_ESR_DIR)/mozconfig-osx-$(ARCH_TYPE) $(FIREFOX_ESR_DIR)/mozconfig
endif
	cd $(FIREFOX_ESR_DIR) && make -f client.mk build
ifdef OS_LINUX
	cd $(FIREFOX_ESR_DIR) && make -C obj-$(ARCH_TYPE)-* package INNER_MAKE_PACKAGE=true
endif
	touch $(STAMP_DIR)/grow-firefox-esr
endif
