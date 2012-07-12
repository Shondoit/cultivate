include osdetect.mk
include settings.mk

.DEFAULT: specify-target
.PHONY: specify-target
specify-target:
	@echo Please call a specific target:
	@echo sow-seed sprout-seed grow-seed graft-seed harvest-seed weed

PWD:=$(shell pwd)
TMP_EXT?=~

SEED_LIST=$(basename $(notdir $(wildcard $(SEED_DIR)/*.mk)))
include $(SEED_DIR)/*.mk
