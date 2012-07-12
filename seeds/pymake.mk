pymake:=PYMAKE

PYMAKE_VER:=7b1a8cd06963
PYMAKE_PKG:=pymake-$(PYMAKE_VER).tar.bz2
PYMAKE_URI:=https://hg.mozilla.org/users/bsmedberg_mozilla.com/pymake/archive/$(PYMAKE_VER).tar.bz2
PYMAKE_HASH:=93fa9a5f409929b8102579281e37eb92c0e0b830ba70734a9b9b1fd0172fca6d

grow-pymake:
	touch $(STAMP_DIR)/grow-pymake
