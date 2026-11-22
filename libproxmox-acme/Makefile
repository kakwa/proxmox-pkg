# Name of the package
NAME = libproxmox-acme

# Version
VERSION = 1.7.3

# Revision number
RELEASE = 1

# URL of the project
URL = https://git.proxmox.com/?p=proxmox-acme.git

# short summary of what the package provides
SUMMARY = Proxmox VE ACME client integration

# Long version of the summary
DESCRIPTION = Proxmox ACME client helper scripts and DNS plugins for Proxmox VE.

# License of the upstream project
LICENSE = LGPL-2.1+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:proxmox_ve:*:*:*:*:*:*:*:*

###############################################################################
# Source: proxmox-acme git wrapper (1d4f7d22) + acme.sh (807da649)
###############################################################################

URL_GIT = git://git.proxmox.com/git/proxmox-acme.git
REV_GIT = 1d4f7d227db8c8b7eeedb7a312aa6e809de0aa17
URL_ACMESH = https://codeload.github.com/acmesh-official/acme.sh/tar.gz/807da6498377ee5e0cf43a78091f46f12dc59a89

include buildenv/Makefile.common

# The upstream root Makefile is a repoman wrapper: its "all" target
# (all: $(DEB)) is a no-op under dpkg-buildpackage and it has no install
# target, so a plain dh build would ship empty packages. Proxmox's own
# build stages the *contents* of src/ as the package root (see the
# upstream Makefile's $(BUILDDIR) rule) so that dh runs the real
# build/install Makefile from src/. Reproduce that layout here.
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(GS) -u $(URL_GIT) -r $(REV_GIT) -O libproxmox-acme-1.7.3.tar.gz
	@$(WGS) -u $(URL_ACMESH) -O acme.sh-807da649.tar.gz
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/libproxmox-acme-1.7.3.tar.gz -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR).tmp/.git
	@mkdir -p $(SOURCE_DIR).tmp/src/acme.sh
	@tar -xf $(CACHE_DIR)/acme.sh-807da649.tar.gz -C $(SOURCE_DIR).tmp/src/acme.sh --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/src/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
