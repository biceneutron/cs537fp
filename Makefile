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
	rm -rf bin/ timings/
	mkdir bin/ timings/

	cargo build --features mm --release --timings
	cp target/release/cs537fp bin/mm-native
	cp target/cargo-timings/cargo-timing.html timings/mm-native-cargo-timing.html

	cargo build --features coding --release --timings
	cp target/release/cs537fp bin/coding-native
	cp target/cargo-timings/cargo-timing.html timings/coding-native-cargo-timing.html

	cargo build --features io --release --timings
	cp target/release/cs537fp bin/io-native
	cp target/cargo-timings/cargo-timing.html timings/io-native-cargo-timing.html

	cargo build --features networking --release --timings
	cp target/release/cs537fp bin/networking-native
	cp target/cargo-timings/cargo-timing.html timings/networking-native-cargo-timing.html

	cargo build --features tcp-server --release
	cp target/release/cs537fp bin/tcp-server

build-wasi:
	cargo clean
	rm -rf bin/ timings/
	mkdir bin/ timings/

	cargo build --target wasm32-wasi --features mm --release --timings
	cp target/wasm32-wasi/release/cs537fp.wasm bin/mm-wasi.wasm
	cp target/cargo-timings/cargo-timing.html timings/mm-wasi-cargo-timing.html

	cargo build --target wasm32-wasi --features coding --release --timings
	cp target/wasm32-wasi/release/cs537fp.wasm bin/coding-wasi.wasm
	cp target/cargo-timings/cargo-timing.html timings/coding-wasi-cargo-timing.html

	cargo build --target wasm32-wasi --features io --release --timings
	cp target/wasm32-wasi/release/cs537fp.wasm bin/io-wasi.wasm
	cp target/cargo-timings/cargo-timing.html timings/io-wasi-cargo-timing.html

	cargo build --target wasm32-wasi --features networking --release --timings
	cp target/wasm32-wasi/release/cs537fp.wasm bin/networking-wasi.wasm
	cp target/cargo-timings/cargo-timing.html timings/networking-wasi-cargo-timing.html

	cargo build --features tcp-server --release
	cp target/release/cs537fp bin/tcp-server

push-android:
	./adb push ./android ./data /data/local/tmp

clean-output:
	rm -f ./data/*/out_*.txt
	rm -f ./data/*/out_*.json
	rm -f ./data/*/out.txt
	rm -f ./data/*/*/out.txt


# matrix multiplication
run-mm-native-10:
	bin/mm-native \
	./data/mm/10-10-10/a.txt ./data/mm/10-10-10/b.txt ./data/mm/10-10-10/out.txt 10 10 10

run-mm-native-50:
	bin/mm-native \
	./data/mm/50-50-50/a.txt ./data/mm/50-50-50/b.txt ./data/mm/50-50-50/out.txt 50 50 50

run-mm-native-100:
	bin/mm-native \
	./data/mm/100-100-100/a.txt ./data/mm/100-100-100/b.txt ./data/mm/100-100-100/out.txt 100 100 100

run-mm-native-500:
	bin/mm-native \
	./data/mm/500-500-500/a.txt ./data/mm/500-500-500/b.txt ./data/mm/500-500-500/out.txt 500 500 500

run-mm-native-1000:
	bin/mm-native \
	./data/mm/1000-1000-1000/a.txt ./data/mm/1000-1000-1000/b.txt ./data/mm/1000-1000-1000/out.txt 1000 1000 1000

run-mm-wasi-10:
	wasmtime --wasi common=y --dir . bin/mm-wasi.wasm \
	./data/mm/10-10-10/a.txt ./data/mm/10-10-10/b.txt ./data/mm/10-10-10/out.txt 10 10 10

run-mm-wasi-50:
	wasmtime --dir . bin/mm-wasi.wasm \
	./data/mm/50-50-50/a.txt ./data/mm/50-50-50/b.txt ./data/mm/50-50-50/out.txt 50 50 50

run-mm-wasi-100:
	wasmtime --dir . bin/mm-wasi.wasm \
	./data/mm/100-100-100/a.txt ./data/mm/100-100-100/b.txt ./data/mm/100-100-100/out.txt 100 100 100

run-mm-wasi-500:
	wasmtime --dir . bin/mm-wasi.wasm \
	./data/mm/500-500-500/a.txt ./data/mm/500-500-500/b.txt ./data/mm/500-500-500/out.txt 500 500 500

run-mm-wasi-1000:
	wasmtime --dir . bin/mm-wasi.wasm \
	./data/mm/1000-1000-1000/a.txt ./data/mm/1000-1000-1000/b.txt ./data/mm/1000-1000-1000/out.txt 1000 1000 1000


# Huffman coding
run-coding-native-1000:
	bin/coding-native \
	./data/coding/1000.txt ./data/coding/out_1000.json

run-coding-native-5000:
	bin/coding-native \
	./data/coding/5000.txt ./data/coding/out_5000.json

run-coding-native-10000:
	bin/coding-native \
	./data/coding/10000.txt ./data/coding/out_10000.json

run-coding-native-15000:
	bin/coding-native \
	./data/coding/15000.txt ./data/coding/out_15000.json

run-coding-native-20000:
	bin/coding-native \
	./data/coding/20000.txt ./data/coding/out_20000.json

run-coding-wasi-1000:
	wasmtime --dir . bin/coding-wasi.wasm \
	./data/coding/1000.txt ./data/coding/out_1000.json

run-coding-wasi-5000:
	wasmtime --dir . bin/coding-wasi.wasm \
	./data/coding/5000.txt ./data/coding/out_5000.json

run-coding-wasi-10000:
	wasmtime --dir . bin/coding-wasi.wasm \
	./data/coding/10000.txt ./data/coding/out_10000.json

run-coding-wasi-15000:
	wasmtime --dir . bin/coding-wasi.wasm \
	./data/coding/15000.txt ./data/coding/out_15000.json

run-coding-wasi-20000:
	wasmtime --dir . bin/coding-wasi.wasm \
	./data/coding/20000.txt ./data/coding/out_20000.json


# IO
# IO uses the intput datasets from the Huffman coding experiment
run-io-native-1000:
	bin/io-native \
	./data/coding/1000.txt ./data/io/out_1000.txt

run-io-native-5000:
	bin/io-native \
	./data/coding/5000.txt ./data/io/out_5000.txt

run-io-native-10000:
	bin/io-native \
	./data/coding/10000.txt ./data/io/out_10000.txt

run-io-native-15000:
	bin/io-native \
	./data/coding/15000.txt ./data/io/out_15000.txt

run-io-native-20000:
	bin/io-native \
	./data/coding/20000.txt ./data/io/out_20000.txt

run-io-wasi-1000:
	wasmtime --dir . bin/io-wasi.wasm \
	./data/coding/1000.txt ./data/io/out_1000.txt

run-io-wasi-5000:
	wasmtime --dir . bin/io-wasi.wasm \
	./data/coding/5000.txt ./data/io/out_5000.txt

run-io-wasi-10000:
	wasmtime --dir . bin/io-wasi.wasm \
	./data/coding/10000.txt ./data/io/out_10000.txt

run-io-wasi-15000:
	wasmtime --dir . bin/io-wasi.wasm \
	./data/coding/15000.txt ./data/io/out_15000.txt

run-io-wasi-20000:
	wasmtime --dir . bin/io-wasi.wasm \
	./data/coding/20000.txt ./data/io/out_20000.txt



# Networking
# Networking uses the intput datasets from the Huffman coding experiment
run-server:
	bin/tcp-server \
	127.0.0.1:8080

run-networking-native-1000:
	bin/networking-native \
	 $(HOST_ADDR) ./data/coding/1000.txt

run-networking-native-5000:
	bin/networking-native \
	$(HOST_ADDR) ./data/coding/5000.txt

run-networking-native-10000:
	bin/networking-native \
	$(HOST_ADDR) ./data/coding/10000.txt

run-networking-native-15000:
	bin/networking-native \
	$(HOST_ADDR) ./data/coding/15000.txt

run-networking-native-20000:
	bin/networking-native \
	$(HOST_ADDR) ./data/coding/20000.txt

run-networking-wasi-1000:
	wasmedge --dir . bin/networking-wasi.wasm \
	$(HOST_ADDR) ./data/coding/1000.txt

run-networking-wasi-5000:
	wasmedge --dir . bin/networking-wasi.wasm \
	$(HOST_ADDR) ./data/coding/5000.txt

run-networking-wasi-10000:
	wasmedge --dir . bin/networking-wasi.wasm \
	$(HOST_ADDR) ./data/coding/10000.txt

run-networking-wasi-15000:
	wasmedge --dir . bin/networking-wasi.wasm \
	$(HOST_ADDR) ./data/coding/15000.txt

run-networking-wasi-20000:
	wasmedge --dir . bin/networking-wasi.wasm \
	$(HOST_ADDR) ./data/coding/20000.txt