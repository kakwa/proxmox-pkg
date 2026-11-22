# Name of the package
NAME = pve-cluster-stub

# Version (matches the pve-cluster source this was extracted from)
VERSION = 9.1.15

# Revision number
RELEASE = 2

# URL of the project
URL = https://git.proxmox.com/?p=pve-cluster.git

# short summary of what the package provides
SUMMARY = pve-cluster Perl modules as a from-scratch build stub

# Long version of the summary
DESCRIPTION = Provides PVE::Cluster and the libpve-cluster-perl Perl modules (extracted from pve-cluster 9.1.15) as Architecture:all packages, so that packages which need them at build time (notably pve-access-control, whose doc generation loads PVE::Cluster) can be built from scratch without the real pve-cluster binary package (which requires corosync, fuse, libqb and friends).

# License of the upstream project
LICENSE = AGPL-3+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: vendored Perl modules from pve-cluster 9.1.15
#
# pve-cluster's Perl modules are normally shipped by its binary packages.
# The real binary package is Architecture:any and needs the full corosync
# stack to build. To break the build-time cycle between pve-cluster and
# pve-access-control in a from-scratch build, these modules are vendored
# here and shipped as Architecture:all packages.
#
# PVE/Cluster/IPCConst.pm is generated from the vendored cfs-ipc-ops.h,
# exactly like pve-cluster's own PVE/Cluster/Makefile does it.
###############################################################################

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) Makefile $(DIRECTORIES)
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a pve-cluster libpve-cluster-perl $(SOURCE_DIR)/
	@awk -f $(SOURCE_DIR)/pve-cluster/PVE/Cluster/IPCConst.pm.awk \
	    $(SOURCE_DIR)/pve-cluster/pmxcfs/cfs-ipc-ops.h \
	    > $(SOURCE_DIR)/pve-cluster/PVE/Cluster/IPCConst.pm
	@$(SOURCE_TAR_CMD)
