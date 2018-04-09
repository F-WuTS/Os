.PHONY: all setup build
all: build

setup:
	sudo ./scripts/setup-host.sh

build: 
	./prepare.sh
	./combine.sh