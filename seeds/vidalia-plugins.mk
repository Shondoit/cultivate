vidalia-plugins:=VIDALIA_PLUGINS

VIDALIA_PLUGINS_VER:=0

$(SPROUT_DIR)/vidalia-plugins-$(VIDALIA_PLUGINS_VER):
	rm -rf $(SPROUT_DIR)/vidalia-plugins-$(VIDALIA_PLUGINS_VER)$(TMP_EXT)
	git clone https://git.torproject.org/vidalia-plugins.git \
		$(SPROUT_DIR)/vidalia-plugins-$(VIDALIA_PLUGINS_VER)$(TMP_EXT)
	rm -rf $(SPROUT_DIR)/vidalia-plugins-$(VIDALIA_PLUGINS_VER)
	mv $(SPROUT_DIR)/vidalia-plugins-$(VIDALIA_PLUGINS_VER)$(TMP_EXT) \
		$(SPROUT_DIR)/vidalia-plugins-$(VIDALIA_PLUGINS_VER)

grow-vidalia-plugins:
	touch $(STAMP_DIR)/grow-vidalia-plugins
