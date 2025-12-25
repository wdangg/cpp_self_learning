RED     = \033[0;31m
GREEN   = \033[0;32m
YELLOW  = \033[0;33m
BLUE    = \033[34m
RESET   = \033[0m

CXX := g++

PRO_DIR = .
SRC_DIR := $(PRO_DIR)/src
BUILD_DIR := $(PRO_DIR)/build
PRE_DIR := $(BUILD_DIR)/preprocessed
ASM_DIR := $(BUILD_DIR)/assembly
OBJ_DIR := $(BUILD_DIR)/objects
BIN_DIR := $(BUILD_DIR)/bin
LIBS_DIR += $(PRO_DIR)/libs
INC_DIR += $(PRO_DIR)/inc
SRC_DIR += $(wildcard $(LIBS_DIR)/*)
INC_DIR += $(wildcard $(LIBS_DIR)/*)

CXXFLAGS := -std=c++17 -Wall -Wextra -g -Wpedantic $(foreach DIR, $(INC_DIR), -I$(DIR))
MAP_FLAG := -Wl,-Map=$(BIN_DIR)/app.map

SRC_FILES := $(foreach dir, $(SRC_DIR), $(wildcard $(dir)/*.cpp))
SRC_FILES += $(wildcard $(LIBS_DIR)/*/*.cpp)
PREPROCESSED := $(patsubst %.cpp, $(PRE_DIR)/%.i, $(notdir $(SRC_FILES)))
COMPILED := $(patsubst %.i, $(ASM_DIR)/%.s, $(notdir $(PREPROCESSED)))
ASSEMBLED := $(patsubst %.s, $(OBJ_DIR)/%.o, $(notdir $(COMPILED)))

TARGET := $(BIN_DIR)/app.exe

vpath %.cpp $(SRC_DIR)
vpath %.i $(PRE_DIR)
vpath %.s $(ASM_DIR)
vpath %.o $(OBJ_DIR)

# ------------------------------
# Action: all = clear + build + run
# ------------------------------
all: clear build run

# ------------------------------
# Action: build
# ------------------------------
build: compile assemble link

clear:
	@echo "[clear] Processing clear output"
	@rm -rf $(BUILD_DIR)/*

# 01. Preprocessing: .cpp -> .i
preprocess: $(PREPROCESSED)

$(PRE_DIR)/%.i: %.cpp
	@mkdir -p $(dir $@)
	@echo "[preprocessing] $< -> $@"
	@$(CXX) $(CXXFLAGS) -E $< -o $@

# Compiling: .i -> .s
compile: preprocess $(COMPILED)

$(ASM_DIR)/%.s: %.i
	@mkdir -p $(dir $@)
	@echo "[compiling] $^ -> $@"
	@$(CXX) $(CXXFLAGS) -S $< -o $@

# Assembling: .s -> .o
assemble: preprocess compile $(ASSEMBLED)

$(OBJ_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@echo "[assembling] $< -> $@"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

# Linking + file .map
link: $(TARGET)

$(TARGET): $(ASSEMBLED)
	@mkdir -p $(BIN_DIR)
	@echo "[linking] $^ -> $@"
	@$(CXX) $(CXXFLAGS) $^ -o $(TARGET) $(MAP_FLAG)

run: 
	@$(TARGET)
# Generic print action: make print-<VAR>
print-%:
	@echo $($*)

.PHONY: clear build run all preprocess compile assemble link
