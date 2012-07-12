qt-script:=QT_SCRIPT

QT_SCRIPT_VER:=0.2.0
QT_SCRIPT_PKG:=qtscriptgenerator-src-$(QT_SCRIPT_VER).tar.gz
QT_SCRIPT_URI:=http://qtscriptgenerator.googlecode.com/files/$(QT_SCRIPT_PKG)
#QT_SCRIPT_HASH:=

#$(SPROUT_DIR)/qt-script-$(QT_SCRIPT_VER):
#	git clone git://gitorious.org/qt-labs/qtscriptgenerator.git \
#		$(SPROUT_DIR)/qt-script-$(QT_SCRIPT_VER)

grow-qt-script:PATH+=:$(QT_DIR)/bin
grow-qt-script:
	cd $(QT_SCRIPT_DIR)/generator && qmake -spec win32-g++ && make
	cd $(QT_SCRIPT_DIR)/generator && QTDIR=$(QT_DIR) ./release/generator
	cd $(QT_SCRIPT_DIR)/qtbindings && qmake && make
#	cd $(QT_SCRIPT_DIR)/qtbindings && qmake -recursive CONFIG+="release"
#	cd $(QT_SCRIPT_DIR)/qtbindings/qtscript_core && qmake && make -j$(NUM_CORES)
#	cd $(QT_SCRIPT_DIR)/qtbindings/qtscript_uitools && qmake && make -j$(NUM_CORES)

#	cd $(QTSCRIPT_DIR)/generator && qmake	
#	cd $(QTSCRIPT_DIR)/generator && make -j4
#	cd $(QTSCRIPT_DIR)/generator && ./generator --include-paths=/c/Qt/2010.04/qt
#	cp ../src/current-patches/qt/000* $(QTSCRIPT_DIR)/qtbindings/qtscript_uitools
#	cp patch-any-src.sh $(QTSCRIPT_DIR)/qtbindings/qtscript_uitools
#	cd $(QTSCRIPT_DIR)/qtbindings/qtscript_uitools && ./patch-any-src.sh
#	cd $(QTSCRIPT_DIR)/generator && qmake -spec win32-g++
#	cd $(QTSCRIPT_DIR)/generator && make -j4
#	cd $(QTSCRIPT_DIR)/qtbindings && qmake -recursive CONFIG+="release"

	touch $(STAMP_DIR)/grow-qt-script
