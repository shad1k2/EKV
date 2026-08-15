PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
EC = ec
ECF = ekv.ecf
BIN = ./EIFGENs/ekv/W_code/ekv

.PHONY: all build run clean reset install uninstall

all: build

build:
	@echo "==> Building EKV Database..."
	$(EC) -config $(ECF) -finalize -c_compile -batch

run: build
	@echo "==> Running EKV CLI..."
	@$(BIN)

install: build
	@echo "==> Installing ekv to $(BINDIR)..."
	mkdir -p $(DESTDIR)$(BINDIR)
	install -m 755 $(BIN) $(DESTDIR)$(BINDIR)/ekv

uninstall:
	@echo "==> Uninstalling ekv from $(BINDIR)..."
	rm -f $(DESTDIR)$(BINDIR)/ekv

clean:
	@echo "==> Cleaning build artifacts..."
	rm -rf EIFGENs

reset: clean
	@echo "==> Resetting database log..."
	rm -f ekv.log