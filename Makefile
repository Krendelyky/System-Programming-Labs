IMAGE ?= stm32-build
BIN_PATH ?= firmware/build/firmware.bin
SERIAL_PORT ?= /dev/ttyACM0
BAUD ?= 115200

.PHONY: all build clean flash monitor probe

all: build

build:
        docker run --rm -v $(PWD):/workspace -w /workspace \
                --user $(shell id -u):$(shell id -g) $(IMAGE) \
                make -C firmware all

clean:
        docker run --rm -v $(PWD):/workspace -w /workspace \
                --user $(shell id -u):$(shell id -g) $(IMAGE) \
                make -C firmware clean

probe:
        st-info --probe

flash: build
        st-flash --reset write $(BIN_PATH) 0x08000000

monitor:
        picocom -b $(BAUD) --imap lfcrlf $(SERIAL_PORT)
IMAGE ?= stm32-build
build:
	docker run --rm -v $(PWD):/workspace -w /workspace \
		--user $(id -u):$(id -g) $(IMAGE) \
		make -C firmware all
