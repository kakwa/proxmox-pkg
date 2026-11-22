# Name of the package
NAME = libproxmox-rs-perl

# Version (matches upstream common/pkg/debian/changelog)
VERSION = 0.4.3

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/proxmox-perl-rs

# Short summary of what the package provides
SUMMARY = Common Perl bindings for Proxmox Rust libraries

# Long version of the summary
DESCRIPTION = Perl-side modules shared by the Proxmox VE and Proxmox Mail Gateway Rust FFI binding libraries.

# License of the upstream project
LICENSE = AGPL-3+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:proxmox_ve:*:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball of the upstream monorepo
# Build-Depends (perlmod-bin, librust-proxmox-* dev packages) come from the
# Proxmox Debian repository, not from plain Debian/Ubuntu mirrors.
###############################################################################

# Upstream does not publish tags; pin the mirror's HEAD commit.
UPSTREAM_COMMIT = 74be7b1ef54e7bbaa0419d7c01adf24f94505e2d
URL_SRC = https://codeload.github.com/proxmox/proxmox-perl-rs/tar.gz/$(UPSTREAM_COMMIT)
UPSTREAM_ARCHIVE = proxmox-perl-rs-$(VERSION).tar.gz

include buildenv/Makefile.common

# This source package is the "common/pkg" subdirectory of the monorepo.
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O $(UPSTREAM_ARCHIVE)
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/$(UPSTREAM_ARCHIVE) -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/common/pkg/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR)/debian
	@sed -i 's|GITVERSION:=.*|GITVERSION:=$(UPSTREAM_COMMIT)|' $(SOURCE_DIR)/Makefile
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
