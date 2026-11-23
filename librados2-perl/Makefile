# Name of the package
NAME = librados2-perl

# Version
VERSION = 1.5.1

# Revision number 
RELEASE = 1

# URL of the project (git repository, no release tags upstream)
URL=https://git.proxmox.com/git/librados2-perl.git

# Pinned upstream commit ("bump version to 1.5.1")
UPSTREAM_REV = a9f0d562b20b47d51e2271f05541da494eb39e36

# short summary of what the package provides
SUMMARY=Perl bindings for librados (RADOS/Ceph)

# Long version of the summary
DESCRIPTION=$(SUMMARY). Perl interface to the RADOS (Ceph) API, as used by Proxmox VE, built without its Proxmox-only (PVE::*) Perl dependencies.

# License of the upstream project
LICENSE=AGPL-3+

# NIST Vulnerability Database CPE pattern (default: cpe:2.3:*:*:$(NAME):*)
# CPE values can be discovered at: https://kakwa.github.io/cpe-search/
#NVD_CPE_PATTERN=cpe:2.3:*:*:librados2-perl:*:*:*:*:*

# Comma separated list of CVEs to ignore
#NVD_IGNORE_CVES=CVE-2023-1234,CVE-2023-5678

# Minimum Version for CVEs (default: $(VERSION))
# Set to 0 for all CVEs
#NVD_MIN_VERSION=0.0.1

# Distribution versions to skip
#
# format: space separated list of rules.
# each rule have the format "<op>:<dist>:<version>", with:
#   <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
#   <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
#   <version>: the version number to ignore
#
#SKIP=<=:deb:8 <=:el:6 <=:fc:29 <=:ubu:18.4

###############################################################################
# Rule #
########

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for sources
# source archive must be recovered here, optionaly reworked, and
# moved to $(SOURCE_ARCHIVE) (the expected path of the source archive for the
# rest of the build)
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

# Recover the upstream git source (no release tags), extract it into
# $(SOURCE_DIR) and rebuild the source archive with the expected
# <name>-<version> top directory layout.
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	@$(GS) -u $(URL) -r $(UPSTREAM_REV) -o $(SOURCE_ARCHIVE)
	@tar -xf $(SOURCE_ARCHIVE) -C $(SOURCE_DIR) --strip-components=1
	@rm -rf -- $(SOURCE_DIR)/.git $(SOURCE_DIR)/debian
	@$(SOURCE_TAR_CMD)
