# Name of the package
NAME = proxmox-widget-toolkit

# Version (pinned upstream commit)
VERSION = 5.2.18
HASH=934a3751c921eda7161e64d714e84835b4f5f8b0

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/proxmox-widget-toolkit

# short summary of what the package provides
SUMMARY = ExtJS widget toolkit for Proxmox web UIs

# Long version of the summary
DESCRIPTION = Shared ExtJS widgets, models and helpers used by Proxmox web interfaces.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

#https://github.com/proxmox/proxmox-widget-toolkit/archive/934a3751c921eda7161e64d714e84835b4f5f8b0.zip
URL_SRC = https://github.com/proxmox/proxmox-widget-toolkit/archive/$(HASH).tar.gz

include buildenv/Makefile.common

# The GitHub tarball is the full git repository, whose top-level Makefile
# only assembles the real source package: the *contents* of src/ plus
# debian/ (see upstream Makefile's $(BUILDDIR) rule). Reproduce that layout
# so that dpkg-buildpackage runs the build Makefile that lives in src/
# upstream (dh_auto_build / dh_auto_install), instead of the empty driver
# Makefile at the repository root.
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O proxmox-widget-toolkit-$(VERSION).tar.gz
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/proxmox-widget-toolkit-$(VERSION).tar.gz -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/src/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
