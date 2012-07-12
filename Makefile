include osdetect.mk
include settings.mk
include templates.mk

.DEFAULT: specify-target
.PHONY: specify-target
specify-target:
	@echo Please call a specific target:
	@echo sow-seed sprout-seed grow-seed graft-seed harvest-seed weed

PWD:=$(shell pwd)
TMP_EXT?=~

ifdef OS_WIN
	### MinGW's wget uses the download time as modified time (which is what we want),
	### but it does not support the --no-use-server-timestamps flag.
	WGET:=wget
	PYTHON:=/c/Python27/python
else
	### On Linux and OSX, wget uses the server's modified time by default
	### so we need to use the --no-use-server-timestamps flag instead.
	WGET:=wget --no-use-server-timestamps
	PYTHON:=$(shell which python)
endif
SIGCHECK:=./verify-sig.sh
HASHCHECK:=shasum -a 256

SEED_LIST=$(basename $(notdir $(wildcard $(SEED_DIR)/*.mk)))
vpath grow-% $(STAMP_DIR)
vpath graft-% $(STAMP_DIR)
include $(SEED_DIR)/*.mk

$(STAMP_DIR): ; mkdir -p $@
$(GRAFT_DIR)/%: ; mkdir -p $@

### Evaluate the seed template with the seed name, package name and URI.
$(foreach seed,$(SEED_LIST),\
	$(eval $(call SOW_tmpl,$(seed),$($($(seed))_PKG),$($($(seed))_URI)))\
)
### Evaluate the sprout template with the seed name,
### the desired folder name and the package name.
$(foreach seed,$(SEED_LIST),\
	$(eval $(call SPROUT_tmpl,$(seed),$($($(seed))_PKG),$(seed)-$($($(seed))_VER)))\
)
### Evaluate the grow template with the seed name and the sprout folder name.
$(foreach seed,$(SEED_LIST),\
	$(eval $(call GROW_tmpl,$(seed),$(seed)-$($($(seed))_VER)))\
)
### Evaluate the graft template with the seed name and the graft folder name.
$(foreach seed,$(SEED_LIST),\
	$(eval $(call GRAFT_tmpl,$(seed),$(seed)-$($($(seed))_VER)))\
)

### Clean all the temporary/failed target files.
.PHONY: weed clean
clean: weed
weed:
	@echo [$@]
	rm -f $(SOW_DIR)/*$(TMP_EXT)
	rm -rf $(SIG_DIR)/*$(TMP_EXT)
	rm -rf $(SPROUT_DIR)/*$(TMP_EXT)
