# Name of the package
NAME = libpve-rs-perl

# Version (matches upstream pve-rs/Cargo.toml)
VERSION = 0.16.5

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/proxmox-perl-rs

# Short summary of what the package provides
SUMMARY = Proxmox VE components ported to Rust (Perl bindings)

# Long version of the summary
DESCRIPTION = Compiled Rust library and Perl FFI bindings for Proxmox VE components.

# License of the upstream project
LICENSE = AGPL-3+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball of the upstream monorepo
# Build-Depends (perlmod-bin, librust-proxmox-* dev packages) come from the
# Proxmox Debian repository, not from plain Debian/Ubuntu mirrors.
###############################################################################

# Upstream does not publish tags; pin the mirror's HEAD commit.
UPSTREAM_COMMIT = 74be7b1ef54e7bbaa0419d7c01adf24f94505e2d
URL_SRC = https://codeload.github.com/proxmox/proxmox-perl-rs/tar.gz/$(UPSTREAM_COMMIT)
UPSTREAM_ARCHIVE = proxmox-perl-rs-$(VERSION).tar.gz

# Proxmox-only Rust dev packages live in Proxmox's devel repository; the
# trixie base provides older crate versions (nix 0.29, base32 0.4) that sid
# no longer carries.
EXTRA_OTHERMIRROR := deb [trusted=yes] http://download.proxmox.com/debian/devel trixie main|deb [trusted=yes] http://deb.debian.org/debian trixie main

include buildenv/Makefile.common

# The pve-rs crate includes ../common/src directly, so stage that directory
# next to it (same layout as upstream's BUILDDIR rule). Drop the upstream
# debian/ directory: the in-chroot overlay supplied by pakste is authoritative.
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O $(UPSTREAM_ARCHIVE)
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/$(UPSTREAM_ARCHIVE) -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/pve-rs/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR)/debian
	@rm -f $(SOURCE_DIR)/common
	@mkdir -p $(SOURCE_DIR)/common
	@cp -a $(SOURCE_DIR).tmp/common/src $(SOURCE_DIR)/common/
	@sed -i 's|GITVERSION:=.*|GITVERSION:=$(UPSTREAM_COMMIT)|' $(SOURCE_DIR)/Makefile
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
