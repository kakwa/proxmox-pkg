# Name of the package
NAME = pve-docs

# Version (pinned upstream commit)
VERSION = 9.2.20

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-docs

# short summary of what the package provides
SUMMARY = Proxmox VE documentation

# Long version of the summary
DESCRIPTION = Documentation and API viewer for Proxmox VE.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/pve-docs/tar.gz/cf7935c8b09f7360602b82119c2db032e5c0ccf6

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O pve-docs-9.2.20.tar.gz
	@tar -xf $(CACHE_DIR)/pve-docs-9.2.20.tar.gz -C $(SOURCE_DIR) --strip-components=1
	# patch wrapper Makefile: pin git SHA, drop lintian
	@sed -i 's|$$(shell git[ ]rev-parse[^)]*)|cf7935c8b09f7360602b82119c2db032e5c0ccf6|g' $(SOURCE_DIR)/Makefile
	@sed -i '/^[[:space:]]*lintian /d' $(SOURCE_DIR)/Makefile
	# pve-admin-guide.epub: a2x validates the generated DocBook with
	# xmllint --valid, but anchors on sections deeper than DocBook's 5-level
	# book cap (sect5) are flattened away by asciidoc, leaving dangling
	# IDREFs (xref -> <link linkend=...> without a matching id=) and aborting
	# the build. The pdf rule already uses a2x -L (loose: skip xmllint) for
	# the same reason; apply it to the epub build too.
	@sed -i 's|a2x -D .*\.tmp -f epub --asciidoc-opts|a2x -D $$@.tmp -f epub -L --asciidoc-opts|' $(SOURCE_DIR)/Makefile
	@$(SOURCE_TAR_CMD)
