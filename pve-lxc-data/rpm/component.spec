%define pkgname @NAME@

%global debug_package %{nil}

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz

URL: @URL@
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
#BuildArch: noarch
BuildRequires: shadow-utils
Requires: shadow-utils
Requires: uidmap

%description
@DESCRIPTION@
The LXC ostype configuration templates (the files referenced by
lxc.include in Proxmox container configs) and the dhclient-script
with RFC3442 classless static route support, which the stock LXC
packages do not provide.

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf -- $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/usr/share/lxc/config
install -m 0644 config/*.conf $RPM_BUILD_ROOT/usr/share/lxc/config/
install -d $RPM_BUILD_ROOT/usr/share/lxc/hooks
install -m 0755 hooks/dhclient-script $RPM_BUILD_ROOT/usr/share/lxc/hooks/

%post
true

%preun
true

%postun
true

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
/usr/share/lxc/config/*.conf
%attr(0755, root, root) /usr/share/lxc/hooks/dhclient-script

%changelog
* Sun Nov 22 2026 @MAINTAINER@ <@MAINTAINER_EMAIL@> 1.0-1
- Initial release: LXC data files for Proxmox VE containers on stock LXC
