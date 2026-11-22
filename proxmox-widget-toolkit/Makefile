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

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O proxmox-widget-toolkit-$(VERSION).tar.gz
	@tar -xf $(CACHE_DIR)/proxmox-widget-toolkit-$(VERSION).tar.gz -C $(SOURCE_DIR) --strip-components=1
	@$(SOURCE_TAR_CMD)
