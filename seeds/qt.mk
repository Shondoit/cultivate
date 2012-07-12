ifdef OS_WIN

QT_VER:=4.8.1
QT_DIR:=/c/Qt/$(QT_VER)

grow-qt: | $(QT_DIR)
	touch $(STAMP_DIR)/grow-qt	

else

qt=QT

QT_VER:=4.8.1
QT_PKG:=qt-everywhere-opensource-src-$(QT_VER).tar.gz
QT_URI:=http://releases.qt-project.org/qt4/source/$(QT_PKG)
QT_HASH:=ef851a36aa41b4ad7a3e4c96ca27eaed2a629a6d2fa06c20f072118caed87ae8

QT_BUILD_PREFS=-system-zlib -confirm-license -opensource -openssl-linked \
	-no-qt3support -fast -release -no-webkit -nomake demos -nomake examples
ifdef OS_OSX
QT_BUILD_PREFS+=  -no-framework $(SDK) -arch $(ARCH_TYPE)
endif
QT_OPTS=$(QT_BUILD_PREFS) -prefix $(GROW_DIR) \
	-I $(GROW_DIR)/include -I $(GROW_DIR)/include/openssl/ -L $(GROW_DIR)/lib

grow-qt: grow-zlib grow-openssl
	cd $(QT_DIR) && ./configure $(QT_OPTS)
	cd $(QT_DIR) && make -j $(NUM_CORES)
	cd $(QT_DIR) && make install
	touch $(STAMP_DIR)/grow-qt

endif
