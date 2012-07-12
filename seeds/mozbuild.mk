ifdef OS_WIN

mozbuild:=MOZBUILD

MOZBUILD_VER:=1.6
MOZBUILD_PKG:=MozillaBuildSetup-$(MOZBUILD_VER).exe
MOZBUILD_URI:=https://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/$(MOZBUILD_PKG)
MOZBUILD_HASH:=cdef48aedbd240401765fc396721e3715b15b17e46127d118698d74d2b1286ba
MOZBUILD_CMD:={PKG_SOURCE_ABS} /S /D={PKG_OUTPUT_ABS}

endif
