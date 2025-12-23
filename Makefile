RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
BLUE    = \033[34m
RESET   = \033[0m

PROJ_DIR = .
BUILD_DIR = $(PROJ_DIR)/build

clear:
	rm -rf $(PROJ_DIR)/output

build:
	mkdir -p $(PROJ_DIR)/output

.PHONY = clear build run