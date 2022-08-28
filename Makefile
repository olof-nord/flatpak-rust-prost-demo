FLATPAK=$(shell which flatpak)
FLATPAK_BUILDER=$(shell which flatpak-builder)

FLATPAK_MANIFEST=com.gitlab.flatpak-rust-prost-demo.yml
FLATPAK_APPID=com.gitlab.flatpak-rust-prost-demo

FLATPAK_BUILD_FLAGS := --verbose --force-clean --install-deps-from=flathub --ccache
FLATPAK_INSTALL_FLAGS := --verbose --force-clean --ccache --user --install
FLATPAK_DEBUG_FLAGS := --verbose --run

all: build

.PHONY: build-dependencies
build-dependencies:
	$(FLATPAK) install org.freedesktop.Platform//21.08
	$(FLATPAK) install org.freedesktop.Sdk//21.08
	$(FLATPAK) install org.freedesktop.Sdk.Extension.rust-stable//21.08

.PHONY: build
build:
	@echo "Building flatpak..."
	$(FLATPAK_BUILDER) build $(FLATPAK_BUILD_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: debug
debug:
	$(FLATPAK_BUILDER) $(FLATPAK_DEBUG_FLAGS) build $(FLATPAK_MANIFEST) sh

.PHONY: debug-installed
debug-installed:
	$(FLATPAK) run --command=sh --devel $(FLATPAK_APPID)

.PHONY: install
install:
	@echo "Installing flatpak..."
	$(FLATPAK_BUILDER) build $(FLATPAK_INSTALL_FLAGS) $(FLATPAK_MANIFEST)

.PHONY: uninstall
uninstall:
	@echo "Uninstalling flatpak..."
	$(FLATPAK) uninstall --delete-data --assumeyes $(FLATPAK_APPID)

.PHONY: run
run:
	$(FLATPAK) run $(FLATPAK_APPID)
