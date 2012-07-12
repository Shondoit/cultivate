define SOW_tmpl
ifdef $(1)

### Define some pseudo-targets: sow-seed, fetch-seed.
.PHONY: sow-$(1) fetch-$(1)
sow-$(1): $(SOW_DIR)/$(2)
fetch-$(1): sow-$(1)

### Only if we have a URI to download will we download.
ifdef $($(1))_URI
### Make it dependent on the seed so that it will automagically re-run.
$(SOW_DIR)/$(2): $(SEED_DIR)/$(1).mk
	@echo [$$@]
	mkdir -p $(SOW_DIR)
	$(WGET) -O "$(SOW_DIR)/$(2)$(TMP_EXT)" "$(3)" \
		--no-check-certificate --tries=3
### If we have a way to verify sigs and we have an actual sig, then verify it.
ifdef SIGCHECK
ifdef $($(1))_SIG
	mkdir -p $(SIG_DIR)
	$(WGET) -O "$(SIG_DIR)/$(2).asc$(TMP_EXT)" "$($($(1))_SIG)" \
		--no-check-certificate --tries=3
	mv $(SIG_DIR)/$(2).asc$(TMP_EXT) $(SIG_DIR)/$(2).asc
	### Use verify-sig.sh with the provided list of allowed keys.
	KEY_DIR=$(KEY_DIR) $(SIGCHECK) \
		$(SIG_DIR)/$(2).asc \
		$(SOW_DIR)/$(2)$(TMP_EXT) \
		$($($(1))_KEYS)
endif
endif
### If we have a way to verify hashes and a hash is provided, then verify it.
### If the hash fails, then print the expected and actual hashes so that
### the user can easily update the hash when needed.
ifdef HASHCHECK
ifdef $($(1))_HASH
	@test `$(HASHCHECK) $(SOW_DIR)/$(2)$(TMP_EXT) | cut -d' ' -f1` = $($($(1))_HASH) \
		|| (printf "\nExpected hash: %s\nActual hash:   %s\n" \
			$($($(1))_HASH) \
			`$(HASHCHECK) $(SOW_DIR)/$(2)$(TMP_EXT) | cut -d' ' -f1` \
		&& exit 1)
endif
endif
	rm -f $(SOW_DIR)/$(2)
	mv $(SOW_DIR)/$(2)$(TMP_EXT) $(SOW_DIR)/$(2)
endif

endif
endef


define SPROUT_tmpl
ifdef $(1)

### Specify the directory where the source should be.
### Allow the user to override this folder if desired.
$($(1))_DIR?=$(SPROUT_DIR)/$(3)
### Define some pseudo-targets: sprout-seed, unpack-seed.
.PHONY: sprout-$(1) unpack-$(1)
sprout-$(1): $$($($(1))_DIR)
unpack-$(1): sprout-$(1)

### If we have an actual package to unpack/install then do so.
ifdef $($(1))_PKG
### Define some paths that sprout.py can use.
$$($($(1))_DIR): export PKG_SOURCE     := $(SOW_DIR)/$(2)
$$($($(1))_DIR): export PKG_SOURCE_PSX := $$(abspath $(SOW_DIR)/$(2))
$$($($(1))_DIR): export PKG_OUTPUT     := $$($($(1))_DIR)$(TMP_EXT)
$$($($(1))_DIR): export PKG_OUTPUT_PSX := $$(abspath $$($($(1))_DIR)$(TMP_EXT))
$$($($(1))_DIR): export PKG_CMDLINE    := $$(value $$($(1))_CMD)
### Make this target dependent on the package, the unpack script (sprout.py)
### As well as any files provided in the patches/seedname folder.
$$($($(1))_DIR): $(SOW_DIR)/$(2) sprout.py $(wildcard $(PATCH_DIR)/$(1)/*.patch)
	@echo [$$@]
	rm -rf $$($($(1))_DIR)$(TMP_EXT)
	mkdir -p $$($($(1))_DIR)$(TMP_EXT)
	### All the necessary variables are sent using the above environment variables.
	$(PYTHON) sprout.py
	rm -rf $$($($(1))_DIR)
	mv $$($($(1))_DIR)$(TMP_EXT) $$($($(1))_DIR)
endif

endif
endef
