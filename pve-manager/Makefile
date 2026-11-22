# Name of the package
NAME = pve-manager

# Version (pinned upstream commit)
VERSION = 9.2.36

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-manager

# short summary of what the package provides
SUMMARY = Proxmox VE management daemon and web interface

# Long version of the summary
DESCRIPTION = Management API, web interface and control daemon for Proxmox VE.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/pve-manager/tar.gz/ae511b85e2d474ebb5e2fe31273a8dbde24b1774

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O pve-manager-9.2.36.tar.gz
	@tar -xf $(CACHE_DIR)/pve-manager-9.2.36.tar.gz -C $(SOURCE_DIR) --strip-components=1
	@sed -i 's|^BIOME ?= proxmox-biome|BIOME ?= true|' $(SOURCE_DIR)/www/manager6/Makefile
	# patch wrapper Makefile: pin git SHA, drop lintian
	@sed -i 's|$$(shell git[ ]rev-parse[^)]*)|ae511b85e2d474eb|g' $(SOURCE_DIR)/Makefile
	@sed -i '/^[[:space:]]*lintian /d' $(SOURCE_DIR)/Makefile
	@$(SOURCE_TAR_CMD)
