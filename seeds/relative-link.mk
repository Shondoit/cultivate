relative-link:=REL_LINK

REL_LINK_VER:=0

$(SPROUT_DIR)/relative-link-$(REL_LINK_VER):
	@echo [$$@]
	rm -rf $(SPROUT_DIR)/relative-link-$(REL_LINK_VER)$(TMP_EXT)
	mkdir -p $(SPROUT_DIR)/relative-link-$(REL_LINK_VER)$(TMP_EXT)
	cp ./contrib/relative-link/* \
		$(SPROUT_DIR)/relative-link-$(REL_LINK_VER)$(TMP_EXT)
	rm -rf $(SPROUT_DIR)/relative-link-$(REL_LINK_VER)
	mv $(SPROUT_DIR)/relative-link-$(REL_LINK_VER)$(TMP_EXT) \
		$(SPROUT_DIR)/relative-link-$(REL_LINK_VER)

grow-relative-link:
ifdef OS_WIN
	cd $(REL_LINK_DIR) && $(MAKE)
endif
	touch $(STAMP_DIR)/grow-relative-link
