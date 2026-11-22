# Name of the package
NAME = lxc-pve

# Version (upstream wrapper version)
VERSION = 7.0.0-2

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/lxc

# short summary of what the package provides
SUMMARY = Proxmox VE LXC container runtime

# Long version of the summary
DESCRIPTION = LXC container runtime with Proxmox VE patches and configuration templates.

# License of the upstream project
LICENSE = LGPL-2.1+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:linuxcontainers:lxc:*:*:*:*:*:*:*:*

###############################################################################
# Source: proxmox/lxc wrapper (680dfc75) + lxc/lxc submodule (e4415af0)
###############################################################################

URL_WRAPPER = https://codeload.github.com/proxmox/lxc/tar.gz/680dfc7595269dff54d7d262f3cb7dc4b5297f3d
URL_SUBMODULE = https://codeload.github.com/lxc/lxc/tar.gz/e4415af07e3ec291205bc828e2b4e8141f91a499

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_WRAPPER) -O lxc-pve-7.0.0-2.tar.gz
	@$(WGS) -u $(URL_SUBMODULE) -O lxc-submodule-e4415af07e3ec291205bc828e2b4e8141f91a499.tar.gz
	@tar -xf $(CACHE_DIR)/lxc-pve-7.0.0-2.tar.gz -C $(SOURCE_DIR) --strip-components=1
	@tar -xf $(CACHE_DIR)/lxc-submodule-e4415af07e3ec291205bc828e2b4e8141f91a499.tar.gz -C $(SOURCE_DIR) --strip-components=1
	# patch wrapper Makefile: pin git SHA, drop lintian
	@sed -i 's|$$(shell git[ ]rev-parse[^)]*)|680dfc7595269dff54d7d262f3cb7dc4b5297f3d|g' $(SOURCE_DIR)/Makefile
	@sed -i '/^[[:space:]]*lintian /d' $(SOURCE_DIR)/Makefile
	@$(SOURCE_TAR_CMD)
