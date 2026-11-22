# Name of the package
NAME = perlmod-bin

# Version (matches upstream perlmod-bin/debian/changelog)
VERSION = 0.3.0

# Revision number
RELEASE = 1

# URL of the project
URL = https://git.proxmox.com/?p=perlmod.git

# Short summary of what the package provides
SUMMARY = Perl module generator for Proxmox Rust bindings

# Long version of the summary
DESCRIPTION = genpackage.pl helper which generates the Perl package files loading cdylibs built with the perlmod crate.

# License of the upstream project
LICENSE = AGPL-3+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:proxmox_ve:*:*:*:*:*:*:*:*

###############################################################################
# Source: pinned commit of the upstream perlmod git repository
###############################################################################

URL_GIT = https://git.proxmox.com/git/perlmod.git
REV_GIT = 3a667956097b361a9ef40fa8a2f6c0e26711b025

include buildenv/Makefile.common

# The Debian packaging lives in the "perlmod-bin" subdirectory upstream;
# stage its contents (including genpackage.pl) as the package root.
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(GS) -u $(URL_GIT) -r $(REV_GIT) -O perlmod-bin-$(VERSION).tar.gz
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/perlmod-bin-$(VERSION).tar.gz -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/perlmod-bin/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR)/debian
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
