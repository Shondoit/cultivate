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
	rm -f $(SOW_DIR)/$(2)
	mv $(SOW_DIR)/$(2)$(TMP_EXT) $(SOW_DIR)/$(2)
endif

endif
endef
