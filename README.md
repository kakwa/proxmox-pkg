[![Build Packages Repositories](https://github.com/kakwa/proxmox-pkg/actions/workflows/repos.yml/badge.svg)](https://github.com/kakwa/proxmox-pkg/actions/workflows/repos.yml)
[![CVEs/NVD Check](https://github.com/kakwa/proxmox-pkg/actions/workflows/vulncheck.yml/badge.svg)](https://github.com/kakwa/proxmox-pkg/actions/workflows/vulncheck.yml)

# proxmox-pkg

The `.deb`/`.rpm` repositories are available at the following url: https://kakwa.github.io/proxmox-pkg/

## Ubuntu/Debian

If you are using `Ubuntu`/`Debian`, here how to install the repository:

```shell
# If you are not root
export SUDO=sudo

# Get your OS version
. /etc/os-release
# Get the architecture
ARCH=$(dpkg --print-architecture)

# Add the GPG key
${SUDO} install -dm755 /etc/apt/keyrings
wget -qO - https://kakwa.github.io/proxmox-pkg/GPG-KEY.pub | \
    ${SUDO} tee /etc/apt/keyrings/proxmox-pkg.asc >/dev/null

# Add the repository
cat << EOF | ${SUDO} tee /etc/apt/sources.list.d/proxmox-pkg.sources
Types: deb
URIs: https://kakwa.github.io/proxmox-pkg/deb.${VERSION_CODENAME}.${ARCH}/
Suites: ${VERSION_CODENAME}
Components: main
Architectures: ${ARCH}
Signed-By: /etc/apt/keyrings/proxmox-pkg.asc
EOF

# update
${SUDO} apt update
```

## RHEL/Rocky/Fedora

If you are using `RHEL`/`Rocky`/`Fedora`, here how to install the repository:

```shell
# If you are not root
export SUDO=sudo

# Get your OS version
. /etc/os-release

# Determine distro prefix (el for RHEL/Rocky, fc for Fedora)
if [[ "$ID" == "fedora" ]]; then
    DISTRO_PREFIX="fc"
else
    DISTRO_PREFIX="el"
fi

# Create the repository file
cat << EOF | ${SUDO} tee -a /etc/dnf/dnf.conf

[proxmox-pkg]
name=proxmox-pkg
baseurl=https://kakwa.github.io/proxmox-pkg/rpm.${DISTRO_PREFIX}\$releasever.\$basearch/\$releasever/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://kakwa.github.io/proxmox-pkg/GPG-KEY.pub
EOF
```

# Build The `.rpm`/`.deb` Repositories

This project uses [Pakste](https://github.com/kakwa/pakste).

Check the [Pakste Documention](https://kakwa.github.io/pakste/) for more details.
