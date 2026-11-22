# Name of the package
NAME = pve-lxc-data

# Version (pinned upstream commit)
VERSION = 1.0

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-container

# short summary of what the package provides
SUMMARY = Proxmox VE LXC data files

# Long version of the summary
DESCRIPTION = LXC configuration templates and hooks for Proxmox VE containers on stock LXC.

# License of the upstream project
LICENSE = LGPL-2.1+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: vendored data files (no upstream download)
#
# The LXC ostype configuration templates and the RFC3442-patched
# dhclient-script are vendored in this package (config/ and hooks/).
# They used to be shipped by the lxc-pve fork; with stock LXC they are
# provided by this data package instead.
###############################################################################

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) Makefile $(DIRECTORIES)
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a config hooks $(SOURCE_DIR)/
	@$(SOURCE_TAR_CMD)
