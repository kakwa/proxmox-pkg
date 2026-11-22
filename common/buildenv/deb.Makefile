#### DEB Build System
# -----------------

# Find distribution-specific Debian files
DEB_CONTENT_DIST := $(filter-out debian/control.dist.$(DIST) \
  debian/rules.dist.$(DIST), \
  $(wildcard debian/*.dist.$(DIST)) \
)

# Find base Debian files (excluding distribution-specific ones)
DEB_CONTENT_BASE := $(filter-out $(wildcard debian/*.dist.*) \
  debian/changelog \
  debian/control \
  debian/rules \
  debian/copyright, \
  $(wildcard debian/*) \
)

# Select files to include in package
DEB_CONTENT_IN := $(DEB_CONTENT_DIST) \
  $(shell for f in $(DEB_CONTENT_BASE); do \
      if ! [ -e $$f.dist.$(DIST) ]; then echo $$f; fi; \
    done \
  )

# Output paths for processed files
DEB_CONTENT_OUT := $(subst .dist.$(DIST),,\
  $(addprefix $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/, \
    $(DEB_CONTENT_IN) \
  ) \
)

# Select distribution-specific files when available
ifneq ("$(wildcard debian/rules.dist.$(DIST))","")
DEB_RULE_IN := debian/rules.dist.$(DIST)
else
DEB_RULE_IN := debian/rules
endif

ifneq ("$(wildcard debian/control.dist.$(DIST))","")
DEB_CONTROL_IN := debian/control.dist.$(DIST)
else
DEB_CONTROL_IN := debian/control
endif

ifneq ("$(wildcard debian/copyright.dist.$(DIST))","")
DEB_COPYRIGHT_IN := debian/copyright.dist.$(DIST)
else
DEB_COPYRIGHT_IN := debian/copyright
endif

# Package source archive
DEB_ARCHIVE := $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)_$(VERSION).orig.tar.gz

# Full deb version
FULL_VERSION_DEB := $(VERSION)-$(RELEASE)~$(PKG_ORG)+$(DIST_CODE)$(DIST_TAG)

# Preparation dependencies
DEB_PREPARE := $(DEB_ARCHIVE) $(DEB_CONTENT_OUT) \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/changelog \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/control \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/rules \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/copyright

# Core Debian control files
DEB_CONTROL_RULE_COPYRIGHT := \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/control \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/rules \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/copyright

# Debian changelog file
DEB_CHANGELOG := \
  $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/changelog

# Copy Debian packaging files
$(DEB_CONTENT_OUT): $(DEB_CONTENT_IN)
	@mkdir -p $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian/
	@f=$(subst $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/,,$@); \
	if [ -e $$f.dist.$(DIST) ]; then \
		cp -rf $$f.dist.$(DIST) $@; \
	else \
		cp -rf $$f $@; \
	fi

# Process control files with variable substitution
$(DEB_CONTROL_RULE_COPYRIGHT): $(DEB_CONTROL_IN) $(DEB_RULE_IN) $(DEB_COPYRIGHT_IN) Makefile
	@f=$(subst $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/,,$@); \
	if [ -e $$f.dist.$(DIST) ]; then \
		cp -rf $$f.dist.$(DIST) $@; \
	else \
		cp -rf $$f $@; \
	fi
	@sed -i 's|@NAME@|$(PKGNAME)|'                      $@ || (rm -f $@; exit 1)
	@sed -i 's|@VERSION@|$(VERSION)|'                   $@ || (rm -f $@; exit 1)
	@sed -i 's|@LICENSE@|$(LICENSE)|'                   $@ || (rm -f $@; exit 1)
	@sed -i 's|@RELEASE@|$(RELEASE)|'                   $@ || (rm -f $@; exit 1)
	@sed -i 's|@DESCRIPTION@|$(DESCRIPTION)|'           $@ || (rm -f $@; exit 1)
	@sed -i 's|@SUMMARY@|$(SUMMARY)|'                   $@ || (rm -f $@; exit 1)
	@sed -i 's|@URL@|$(URL)|'                           $@ || (rm -f $@; exit 1)
	@sed -i 's|@MAINTAINER@|$(MAINTAINER)|'             $@ || (rm -f $@; exit 1)
	@sed -i 's|@MAINTAINER_EMAIL@|$(MAINTAINER_EMAIL)|' $@ || (rm -f $@; exit 1)
	@sed -i 's|@FULL_VERSION_DEB@|$(FULL_VERSION_DEB)|' $@ || (rm -f $@; exit 1)

# Generate Debian changelog file
$(DEB_CHANGELOG): ./debian/changelog
	@mkdir -p $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION)/debian
	@printf "$(PKGNAME) ($(FULL_VERSION_DEB)) $(DIST); urgency=low\n" > $@
	@printf "\n  * New version\n\n" >> $@
	@printf " -- $(MAINTAINER) <$(MAINTAINER_EMAIL)>  %s\n" "Thu, 1 Jan 1970 00:00:00 +0000" >> $@
	# Pin the mtime: dpkg-deb embeds this file as changelog.Debian.gz and the
	# gzip header records the source mtime, so an unpinned mtime makes every
	# rebuild byte-different. Byte-identical debs mean apt's cached hashes stay
	# valid across rebuilds (no "Hash Sum mismatch" while the repo index lags).
	@touch -d '1970-01-01 00:00:00 +0000' $@

# Copy source archive to Debian build directory
$(DEB_ARCHIVE): $(SOURCE_ARCHIVE) | $(DIRECTORIES)
	@cp -f $(SOURCE_ARCHIVE) $(DEB_ARCHIVE)

# Ensure local repository directory exists
$(INDIVIDUAL_DEB_LOCAL_REPO_PATH)/Packages:
	@mkdir -p $(INDIVIDUAL_DEB_LOCAL_REPO_PATH)
	@touch $(INDIVIDUAL_DEB_LOCAL_REPO_PATH)/Packages

# Build Debian packages (local build)
$(BUILD_DIR)/pkg_built.deb.$(DIST): $(DEB_PREPARE) | $(DIRECTORIES) $(INDIVIDUAL_DEB_LOCAL_REPO_PATH)/Packages
	@tar -xf $(DEB_ARCHIVE) -C $(BUILD_DIR)/deb.$(DIST)
	@cd $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION) && \
	dpkg-buildpackage -us -uc; \
	if [ $$? -ne 0 ]; then \
		touch ../failure.$(DIST); \
		exit 1; \
	else \
		rm -f ../failure.$(DIST); \
	fi
	@find $(BUILD_DIR)/ -type f -name "*.deb" -print0 | xargs -0 -r mv -t $(OUT_DIR)/
	@find $(BUILD_DIR)/ -type f -name "*.orig.tar.gz" -print0 | xargs -0 -r cp -t $(OUT_SRC)/
	@find $(BUILD_DIR)/ -type f -name "*.dsc" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	@find $(BUILD_DIR)/ -type f -name "*debian.tar.xz" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	@touch $@

# Build Debian packages in a clean chroot environment (cowbuilder/pbuilder)
#
# Note: dpkg-source -b only needs the debian/ directory (populated by the
# DEB_PREPARE rules above) plus the existing orig tarball (DEB_ARCHIVE) in
# the parent directory; it does not require the full source tree to be
# extracted here. pbuilder extracts the orig tarball inside the chroot.
$(BUILD_DIR)/pkg_built_chroot.deb.$(DIST): $(DEB_PREPARE) | $(DIRECTORIES) $(INDIVIDUAL_DEB_LOCAL_REPO_PATH)/Packages
	@cd $(BUILD_DIR)/deb.$(DIST)/$(PKGNAME)-$(VERSION) && dpkg-source -b ./
	@$(SUDO) mkdir -p $(COW_DIR)/aptcache/
	
	# Setup or update cowbuilder environment if needed
	@if ! [ "$(SKIP_COWBUILDER_SETUP)" = "true" ]; then \
		flock -x /tmp/cowbuilder.$(DIST).lock -c ' \
		if [ "$(BUILDER)" = "cowbuilder" ]; then \
			TEST_FILE="$(COW_BASEPATH)/etc/hosts"; \
		else \
			TEST_FILE="$(COW_BASEPATH)"; \
		fi; \
		if ! [ -f $$TEST_FILE ]; then \
			export TMPDIR=/tmp/; \
			$(SUDO) rm -rf -- $(COW_BASEPATH); \
			$(SUDO) $(BUILDER) --create $(COWBUILDER_CREATE_ARGS) ; \
			ret=$$?; \
		else \
			export TMPDIR=/tmp/; \
			$(SUDO) $(BUILDER) --update $(COWBUILDER_UPDATE_ARGS) ; \
			        ret=$$?; \
		fi; exit $$ret;'; \
	fi
	
	# Drop stale result debs first: the repository holds hardlinks to them, and
	# an in-place overwrite of a shared inode is not atomic (a parallel chroot
	# reading the repo could observe the file truncated). Fresh inodes are
	# created by the build and atomically relinked into the repo below.
	@rm -f $(OUT_DIR)/*.deb
	# Build package in chroot.
	# --hookdir installs the shared pbuilder hooks (notably D10update-local-repo,
	# which refreshes the local file:// repo's apt index inside the chroot
	# before satisfydepends, so deps built earlier in the same pass are visible).
	@export TMPDIR=/tmp/; \
	$(SUDO) $(BUILDER) --build \
		--buildresult $(shell pwd)/$(OUT_DIR)/ \
		--hookdir=$(shell pwd)/buildenv/pbuilder.hooks/ \
		$(COWBUILDER_BUILD_ARGS) \
		$(BUILD_DIR)/deb.$(DIST)/*.dsc; \
	if [ $$? -ne 0 ]; then \
		touch $(BUILD_DIR)/failure.chroot.$(DIST).$(ARCH); \
		exit 1; \
	else \
		rm -f $(BUILD_DIR)/failure.chroot.$(DIST).$(ARCH); \
	fi
	
	# Move build artifacts to appropriate directories
	@find $(OUT_DIR)/ -type f -name "*.orig.tar.gz" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	@find $(OUT_DIR)/ -type f -name "*.dsc" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	@find $(OUT_DIR)/ -type f -name "*.changes" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	@find $(OUT_DIR)/ -type f -name "*.buildinfo" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	@find $(OUT_DIR)/ -type f -name "*debian.tar.xz" -print0 | xargs -0 -r mv -t $(OUT_SRC)/
	
	# Link built packages to local repository.
	# The repository is a file:// source bind-mounted into every running
	# chroot, so updates must be atomic (temp name + rename); a non-atomic
	# in-place rewrite can be observed half-written by apt in a parallel
	# build (hash sum mismatch / unresolvable dependencies).
	# The mv is guarded: if the repository already holds a hardlink to this
	# exact file (same inode, e.g. a previous build whose result file was
	# reused), "mv" reports "same file" and would fail the whole build.
	@find $(OUT_DIR) -type f -name "*$(DIST_CODE)$(DIST_TAG)*$(ARCH)*.deb" -print0 | \
		xargs -0 -r -I{} sh -c 'b=$$(basename "$$1"); t="$$2/$$b.tmp"; f="$$2/$$b"; ln -f "$$1" "$$t" 2>/dev/null; if [ "$$(readlink -f "$$t")" = "$$(readlink -f "$$f")" ]; then rm -f "$$t"; else mv -f "$$t" "$$f"; fi' _ {} $(INDIVIDUAL_DEB_LOCAL_REPO_PATH)
	@find $(OUT_DIR) -type f -name "*$(DIST_CODE)$(DIST_TAG)*all*.deb" -print0 | \
		xargs -0 -r -I{} sh -c 'b=$$(basename "$$1"); t="$$2/$$b.tmp"; f="$$2/$$b"; ln -f "$$1" "$$t" 2>/dev/null; if [ "$$(readlink -f "$$t")" = "$$(readlink -f "$$f")" ]; then rm -f "$$t"; else mv -f "$$t" "$$f"; fi' _ {} $(INDIVIDUAL_DEB_LOCAL_REPO_PATH)

	# Rescan the package index after every relink (serialized with flock for
	# parallel builds, atomic rename so apt never sees a half-written file).
	# The build chroots re-read this file on their own apt-get update (see
	# pbuilder.hooks/D10update-local-repo), so the index and the repository
	# contents stay consistent and packages built earlier in the same pass
	# are visible to satisfydepends of later builds.
	@REPO_PATH="$(INDIVIDUAL_DEB_LOCAL_REPO_PATH)" flock -x /tmp/debrepo.$(DIST).$(ARCH).lock sh -c \
		'cd "$$REPO_PATH" && dpkg-scanpackages . /dev/null > Packages.new.$$$$ && mv -f Packages.new.$$$$ Packages'
	
	# Set the build success marker
	@touch $@

# Helper target to get chroot path
deb_get_chroot_path:
	@echo $$(readlink -f $(COW_BASEPATH))


deb_shell_chroot:
	@-$(MAKE) deb_chroot

# Conditional targets based on the TO_SKIP variable
ifneq ($(TO_SKIP), true)
# Build .deb in chroot (using cowbuilder or pbuilder)
deb_chroot: $(BUILD_DIR)/pkg_built_chroot.deb.$(DIST)

# Build .deb locally
deb: $(BUILD_DIR)/pkg_built.deb.$(DIST)
else
deb_chroot:
deb:
endif
#### END DEB targets
