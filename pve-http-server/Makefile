# Name of the package
NAME = libpve-http-server-perl

# Version (pinned upstream commit)
VERSION = 6.0.7

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-http-server

# short summary of what the package provides
SUMMARY = Proxmox VE HTTP server framework (Perl)

# Long version of the summary
DESCRIPTION = Asynchronous HTTP server framework used by the Proxmox VE API daemons.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/pve-http-server/tar.gz/3d0d58d940d42bce4e5a5020e1f1b776cc437ec5

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O pve-http-server-6.0.7.tar.gz
	@tar -xf $(CACHE_DIR)/pve-http-server-6.0.7.tar.gz -C $(SOURCE_DIR) --strip-components=1
	# patch wrapper Makefile: pin git SHA, drop lintian
	@sed -i 's|$$(shell git[ ]rev-parse[^)]*)|3d0d58d940d42bce4e5a5020e1f1b776cc437ec5|g' $(SOURCE_DIR)/Makefile
	@sed -i '/^[[:space:]]*lintian /d' $(SOURCE_DIR)/Makefile
	@$(SOURCE_TAR_CMD)
