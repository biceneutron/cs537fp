# tool macros
CC ?= # FILL: the compiler
CXX ?= # FILL: the compiler
CFLAGS := # FILL: compile flags
CXXFLAGS := # FILL: compile flags
DBGFLAGS := -g
COBJFLAGS := $(CFLAGS) -c

# path macros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := debug

# compile macros
TARGET_NAME := # FILL: target name
ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
                  $(OBJ_DEBUG)
CLEAN_LIST := $(TARGET) \
			  $(TARGET_DEBUG) \
			  $(DISTCLEAN_LIST)

# default rule
default: makedir all

# non-phony targets
$(TARGET): $(OBJ)
	$(CC) -o $@ $(OBJ) $(CFLAGS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(COBJFLAGS) -o $@ $<

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(COBJFLAGS) $(DBGFLAGS) -o $@ $<

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CC) $(CFLAGS) $(DBGFLAGS) $(OBJ_DEBUG) -o $@

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH)

.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(DISTCLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)


##################################################

HOST_ADDR := 127.0.0.1:8080

build-native: 
	cargo clean
	cargo build --features $(task) --release --timings

build-wasi:
	cargo clean
	cargo build --target wasm32-wasi --features $(task) --release --timings

# build-android: 
# 	rm -rf bin/
# 	mkdir bin/
# 	$(MAKE) build-wasi task=mm
# 	cp ./target/wasm32-wasi/release/cs537fp.wasm bin/mm.wasm
# 	$(MAKE) build-wasi task=coding
# 	cp ./target/wasm32-wasi/release/cs537fp.wasm bin/coding.wasm
# 	$(MAKE) build-wasi task=io
# 	cp ./target/wasm32-wasi/release/cs537fp.wasm bin/io.wasm
# 	$(MAKE) build-wasi task=networking
# 	cp ./target/wasm32-wasi/release/cs537fp.wasm bin/networking.wasm
# 	cargo build --features networking --release

clean-output:
	rm -f ./data/*/out_*.txt
	rm -f ./data/*/out_*.json
	rm -f ./data/*/out.txt
	rm -f ./data/*/*/out.txt


# matrix multiplication
run-mm-native-10:
	./target/release/cs537fp \
	./data/mm/10-10-10/a.txt ./data/mm/10-10-10/b.txt ./data/mm/10-10-10/out.txt 10 10 10

run-mm-native-50:
	./target/release/cs537fp \
	./data/mm/50-50-50/a.txt ./data/mm/50-50-50/b.txt ./data/mm/50-50-50/out.txt 50 50 50

run-mm-native-100:
	./target/release/cs537fp \
	./data/mm/100-100-100/a.txt ./data/mm/100-100-100/b.txt ./data/mm/100-100-100/out.txt 100 100 100

run-mm-native-500:
	./target/release/cs537fp \
	./data/mm/500-500-500/a.txt ./data/mm/500-500-500/b.txt ./data/mm/500-500-500/out.txt 500 500 500

run-mm-native-1000:
	./target/release/cs537fp \
	./data/mm/1000-1000-1000/a.txt ./data/mm/1000-1000-1000/b.txt ./data/mm/1000-1000-1000/out.txt 1000 1000 1000

run-mm-wasi-10:
	wasmtime --wasi common=y --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/mm/10-10-10/a.txt ./data/mm/10-10-10/b.txt ./data/mm/10-10-10/out.txt 10 10 10

run-mm-wasi-50:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/mm/50-50-50/a.txt ./data/mm/50-50-50/b.txt ./data/mm/50-50-50/out.txt 50 50 50

run-mm-wasi-100:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/mm/100-100-100/a.txt ./data/mm/100-100-100/b.txt ./data/mm/100-100-100/out.txt 100 100 100

run-mm-wasi-500:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/mm/500-500-500/a.txt ./data/mm/500-500-500/b.txt ./data/mm/500-500-500/out.txt 500 500 500

run-mm-wasi-1000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/mm/1000-1000-1000/a.txt ./data/mm/1000-1000-1000/b.txt ./data/mm/1000-1000-1000/out.txt 1000 1000 1000


# Huffman coding
run-coding-native-1000:
	./target/release/cs537fp \
	./data/coding/1000.txt ./data/coding/out_1000.json

run-coding-native-5000:
	./target/release/cs537fp \
	./data/coding/5000.txt ./data/coding/out_5000.json

run-coding-native-10000:
	./target/release/cs537fp \
	./data/coding/10000.txt ./data/coding/out_10000.json

run-coding-native-15000:
	./target/release/cs537fp \
	./data/coding/15000.txt ./data/coding/out_15000.json

run-coding-native-20000:
	./target/release/cs537fp \
	./data/coding/20000.txt ./data/coding/out_20000.json

run-coding-wasi-1000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/1000.txt ./data/coding/out_1000.json

run-coding-wasi-5000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/5000.txt ./data/coding/out_5000.json

run-coding-wasi-10000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/10000.txt ./data/coding/out_10000.json

run-coding-wasi-15000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/15000.txt ./data/coding/out_15000.json

run-coding-wasi-20000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/20000.txt ./data/coding/out_20000.json


# IO
# IO uses the intput datasets from the Huffman coding experiment
run-io-native-1000:
	./target/release/cs537fp \
	./data/coding/1000.txt ./data/io/out_1000.txt

run-io-native-5000:
	./target/release/cs537fp \
	./data/coding/5000.txt ./data/io/out_5000.txt

run-io-native-10000:
	./target/release/cs537fp \
	./data/coding/10000.txt ./data/io/out_10000.txt

run-io-native-15000:
	./target/release/cs537fp \
	./data/coding/15000.txt ./data/io/out_15000.txt

run-io-native-20000:
	./target/release/cs537fp \
	./data/coding/20000.txt ./data/io/out_20000.txt

run-io-wasi-1000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/1000.txt ./data/io/out_1000.txt

run-io-wasi-5000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/5000.txt ./data/io/out_5000.txt

run-io-wasi-10000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/10000.txt ./data/io/out_10000.txt

run-io-wasi-15000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/15000.txt ./data/io/out_15000.txt

run-io-wasi-20000:
	wasmtime --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	./data/coding/20000.txt ./data/io/out_20000.txt



# Networking
# Networking uses the intput datasets from the Huffman coding experiment
run-server:
	cargo build --features tcp-server --release
	./target/release/cs537fp \
	127.0.0.1:8080

run-networking-native-1000:
	./target/release/cs537fp \
	 $(HOST_ADDR) ./data/coding/1000.txt

run-networking-native-5000:
	./target/release/cs537fp \
	$(HOST_ADDR) ./data/coding/5000.txt

run-networking-native-10000:
	./target/release/cs537fp \
	$(HOST_ADDR) ./data/coding/10000.txt

run-networking-native-15000:
	./target/release/cs537fp \
	$(HOST_ADDR) ./data/coding/15000.txt

run-networking-native-20000:
	./target/release/cs537fp \
	$(HOST_ADDR) ./data/coding/20000.txt

run-networking-wasi-1000:
	wasmedge --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	$(HOST_ADDR) ./data/coding/1000.txt

run-networking-wasi-5000:
	wasmedge --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	$(HOST_ADDR) ./data/coding/5000.txt

run-networking-wasi-10000:
	wasmedge --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	$(HOST_ADDR) ./data/coding/10000.txt

run-networking-wasi-15000:
	wasmedge --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	$(HOST_ADDR) ./data/coding/15000.txt

run-networking-wasi-20000:
	wasmedge --dir . ./target/wasm32-wasi/release/cs537fp.wasm \
	$(HOST_ADDR) ./data/coding/20000.txt