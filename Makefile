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
else
	### On Linux and OSX, wget uses the server's modified time by default
	### so we need to use the --no-use-server-timestamps flag instead.
	WGET:=wget --no-use-server-timestamps
endif

SEED_LIST=$(basename $(notdir $(wildcard $(SEED_DIR)/*.mk)))
include $(SEED_DIR)/*.mk

### Evaluate the seed template with the seed name, package name and URI.
$(foreach seed,$(SEED_LIST),\
	$(eval $(call SOW_tmpl,$(seed),$($($(seed))_PKG),$($($(seed))_URI)))\
)
