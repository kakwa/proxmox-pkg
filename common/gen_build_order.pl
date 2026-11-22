#!/usr/bin/perl
# gen_build_order.pl - compute a dependency-ordered build order for the
# packages in this repository from their debian/control Build-Depends.
#
# Default (no option): one line per top-level dir containing
# debian/control, in build order (dirs with no local build dependencies
# first).
#
# --pkgs: for each dir in build order, print the dir followed by its
# binary Package: names (sorted):
#   <dir>:
#   \t- <pkg>
#
# --names: one line per locally-resolved dependency name (names
# referenced in Build-Depends* and Depends/Recommends that are provided
# by a Package: or Provides: in the repository).
#
# May be run from any directory; the repository root is derived from the
# script's own location.
#
# Uses libdpkg-perl (Dpkg::Deps) for genuine Build-Depends parsing.
# A naive fallback parser is used if the module is unavailable.

use strict;
use warnings;
use Getopt::Long;
use File::Spec;
use FindBin qw($Bin);
use Cwd qw(abs_path);

my ($opt_pkgs, $opt_names, $opt_help);
GetOptions(
    'pkgs'  => \$opt_pkgs,
    'names' => \$opt_names,
    'help'  => \$opt_help,
) or exit 2;

if ($opt_help) {
    print <<'USAGE';
gen_build_order.pl [options]

Compute a dependency-ordered build order for the packages in this
repository from their debian/control files. May be run from any
directory; the repository root is derived from the script's
location.

Options:
  --pkgs   For each top-level directory containing a debian/control,
           in build order, print the directory followed by its binary
           Package: names (sorted):
               <dir>:
               \t- <pkg>
  --names  Print one line per locally-resolved dependency name
           (names referenced in Build-Depends* and Depends/Recommends
           that are provided by a Package: or Provides: in the
           repository).
  --help   Show this help and exit.

Without options, prints one line per top-level directory containing a
debian/control, in build order (directories with no local build
dependencies first).
USAGE
    exit 0;
}

if ($opt_pkgs && $opt_names) {
    die "gen_build_order.pl: --pkgs and --names are mutually exclusive\n";
}

# The script lives in <root>/common; resolve the repository root from its
# own location so it can be run from any working directory.
my $root = abs_path(File::Spec->catdir($Bin, '..'))
    or die "gen_build_order.pl: cannot resolve repository root from $Bin\n";
chdir($root) or die "gen_build_order.pl: cannot chdir to $root: $!\n";

my $have_deps_parse = eval {
    require Dpkg::Deps;
    1;
};
unless ($have_deps_parse) {
    warn "gen_build_order.pl: Dpkg::Deps unavailable, falling back to naive parsing\n";
}

# ---------------------------------------------------------------------------
# Discover package directories (matches top-level Makefile:
#   find ./* -maxdepth 0 -type d | grep -v '^./common\|^./out'
# i.e. top-level dirs, excluding dotdirs, common and out).
# ---------------------------------------------------------------------------
opendir(my $dh, '.') or die "cannot read current directory: $!\n";
my @dirs = sort grep {
    -d $_ && !m{^\.} && $_ ne 'common' && $_ ne 'out'
} readdir($dh);
closedir($dh);

# ---------------------------------------------------------------------------
# DEB822 control file parsing.
# Fields are lowercased; continuation lines (indented) are appended to the
# previous field with a single space.
# ---------------------------------------------------------------------------
sub parse_control {
    my ($file) = @_;
    open(my $fh, '<', $file) or do {
        warn "gen_build_order.pl: cannot read $file: $!\n";
        return;
    };
    my @stanzas;
    my $cur;
    my $lastfield;
    while (my $line = <$fh>) {
        $line =~ s/\r?\n$//;
        if ($line =~ /^\s*$/) {
            # blank line ends the current stanza
            if ($cur && %$cur) {
                push @stanzas, $cur;
            }
            $cur = undef;
            $lastfield = undef;
            next;
        }
        # column-0 comment lines (debcargo emits "# FIXME ..." between stanzas;
        # not part of DEB822 but present in the tree) are silently skipped
        if ($line =~ /^#/) {
            next;
        }
        if ($line =~ /^([A-Za-z0-9-]+):\s?(.*)$/) {
            $cur = {} unless defined $cur;
            $lastfield = lc $1;
            $cur->{$lastfield} = $2;
        }
        elsif ($line =~ /^\s+(.*)$/ && defined $lastfield) {
            # continuation of the previous field
            $cur->{$lastfield} .= ' ' . $1;
        }
        else {
            warn "gen_build_order.pl: $file: ignoring malformed line: $line\n";
        }
    }
    push @stanzas, $cur if defined $cur && %$cur;
    close($fh);
    return \@stanzas;
}

# Strip a version constraint "(...)" and an arch/qualifier suffix ":..." from
# a bare package name (used for Package:, Provides: and fallback dep tokens).
sub strip_name {
    my ($s) = @_;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    $s =~ s/\s*\(.*\)\s*$//;    # drop trailing version constraint
    $s =~ s/\s+$//;
    $s =~ s/:.*$//;             # drop :arch / :qualifier suffix
    return $s;
}

# ---------------------------------------------------------------------------
# Extract dependency names from a Build-Depends (or Depends/Recommends)
# string. $build_dep selects the Dpkg::Deps parsing context.
# ---------------------------------------------------------------------------
sub collect_names {
    my ($node) = @_;
    my @names;
    # AND/OR nodes carry a 'list' of child nodes; recurse into both.
    if ($node->isa('Dpkg::Deps::AND') || $node->isa('Dpkg::Deps::OR')) {
        for my $child (@{$node->{list}}) {
            push @names, collect_names($child);
        }
    }
    else {
        my $pkg = $node->{package};
        if (defined $pkg) {
            $pkg =~ s/:.*$//;    # drop :arch / :qualifier
            push @names, $pkg;
        }
    }
    return @names;
}

sub dep_names {
    my ($str, $build_dep) = @_;
    $build_dep = 1 unless defined $build_dep;
    return () unless defined $str && $str ne '';
    # drop ${...} substvar tokens (e.g. ${shlibs:Depends}); deps_parse
    # tolerates them but emits a warning to stderr
    $str =~ s/\$\{[^}]*\}\s*,?\s*//g;
    return () if $str !~ /\S/;
    if ($have_deps_parse) {
        my @names;
        my $err = eval {
            my $deps = Dpkg::Deps::deps_parse($str, build_dep => $build_dep);
            @names = collect_names($deps);
            '';
        };
        unless (defined $err) {
            warn "gen_build_order.pl: deps_parse failed for: $str ($@)\n";
        }
        else {
            return @names;
        }
    }
    # naive fallback: split on commas and pipes, strip constraints
    my @names;
    for my $tok (split /,/, $str) {
        for my $alt (split /\|/, $tok) {
            $alt =~ s/<!.*?>//g;     # drop build restrictions
            my $n = strip_name($alt);
            push @names, $n if $n ne '';
        }
    }
    return @names;
}

# ---------------------------------------------------------------------------
# Walk packages: collect name->dirs mapping and raw dependency names.
# ---------------------------------------------------------------------------
my %name2dirs;    # binary package name (Package: or Provides:) -> [dirs]
my %dirpkgs;      # dir -> { binary Package: name => 1 }
my %pkgdeps;      # dir -> subpkg -> { dep_name => 1 }
my %deprefs;      # dep_name => total reference count across all packages
my %allnames;     # every name mentioned in local Build-Depends
my %localdeps;    # dir -> { depdir => 1 } (seeded here, filled in below)

for my $dir (@dirs) {
    my $ctrl = "$dir/debian/control";
    next unless -f $ctrl;
    $localdeps{$dir} = {};    # every dir participates in layering
    my $stanzas = parse_control($ctrl);
    my $found_pkg = 0;
    for my $st (@$stanzas) {
        my $pkg = (defined $st->{package} && $st->{package} ne '')
            ? strip_name($st->{package}) : undef;

        # Register this dir's binary package names (Package: and Provides:)
        # from any stanza that carries them.
        if (defined $pkg) {
            push @{$name2dirs{$pkg}}, $dir;
            $dirpkgs{$dir}{$pkg} = 1;
            $found_pkg = 1;
            if (defined $st->{provides}) {
                for my $p (split /,/, $st->{provides}) {
                    my $n = strip_name($p);
                    push @{$name2dirs{$n}}, $dir if $n ne '';
                }
            }
        }

        # Build-Depends* live in the *source* stanza (no Package: field)
        # as well as in binary stanzas. Collect from whichever stanza
        # carries them; the sub-package key is used for reporting only.
        my %deps;
        for my $f (qw(build-depends build-depends-arch build-depends-indep)) {
            next unless defined $st->{$f};
            for my $n (dep_names($st->{$f}, 1)) {
                next if defined $pkg && $n eq $pkg;    # skip self-dep
                $deps{$n} = 1;
                $deprefs{$n}++;
                $allnames{$n} = 1;
            }
        }
        # Runtime dependency fields (Depends/Recommends) widen the names we
        # count, but they must not feed the build graph (%deps/%pkgdeps).
        for my $f (qw(depends recommends)) {
            next unless defined $st->{$f};
            for my $n (dep_names($st->{$f}, 0)) {
                next if defined $pkg && $n eq $pkg;    # skip self-dep
                $deprefs{$n}++;
                $allnames{$n} = 1;
            }
        }
        if (keys %deps) {
            my $subpkg = defined $pkg ? $pkg : '(source)';
            %{$pkgdeps{$dir}{$subpkg}} =
                (%{$pkgdeps{$dir}{$subpkg} || {}}, %deps);
        }
    }
    warn "gen_build_order.pl: $ctrl: no Package: field found\n"
        unless $found_pkg;
}

# ---------------------------------------------------------------------------
# Build the local dependency graph: dir -> set of local dirs it depends on.
# A dependency name resolving to several local packages edges to all of them
# (conservative).
# ---------------------------------------------------------------------------
my %localseen;    # dep name => 1 (only names resolved to a local package)
for my $dir (sort keys %localdeps) {
    my %deps;
    for my $subpkg (keys %{$pkgdeps{$dir} || {}}) {
        %deps = (%deps, %{$pkgdeps{$dir}{$subpkg}});
    }
    for my $n (sort keys %deps) {
        my @d = @{$name2dirs{$n} || []};
        next unless @d;
        $localseen{$n} = 1;
        for my $d2 (@d) {
            next if $d2 eq $dir;       # skip self
            $localdeps{$dir}{$d2} = 1;
        }
    }
}

# ---------------------------------------------------------------------------
# Layering via Kahn topological sort by levels.
# ---------------------------------------------------------------------------
my @layers;
my %remaining = map { $_ => 1 } keys %localdeps;

while (keys %remaining) {
    my @ready;
    for my $dir (sort keys %remaining) {
        my $ok = 1;
        for my $d2 (keys %{$localdeps{$dir} || {}}) {
            if ($remaining{$d2}) {
                $ok = 0;
                last;
            }
        }
        push @ready, $dir if $ok;
    }
    if (!@ready) {
        # dependency cycle: dump the rest as a final layer
        warn "gen_build_order.pl: WARNING: dependency cycle among:\n";
        for my $dir (sort keys %remaining) {
            warn "  $dir: ", join(' ', sort keys %{$localdeps{$dir} || {}}), "\n";
        }
        push @layers, [ sort keys %remaining ];
        last;
    }
    push @layers, \@ready;
    delete @remaining{@ready};
}

# ---------------------------------------------------------------------------
# Emit the Makefile fragment (stdout) and coverage report (stderr).
# ---------------------------------------------------------------------------
#print "# Generated by gen_build_order.pl - do not edit.\n";
#printf "# %d package directories, %d layers.\n", scalar(@dirs), scalar(@layers);
#print "ORDER_LAYER_COUNT := ", scalar(@layers), "\n";
#print ".PHONY: ", join(' ', map { "deb_chroot_layer_$_" } 1 .. scalar(@layers)), "\n";
#for my $i (0 .. $#layers) {
#    my $line = "deb_chroot_layer_" . ($i + 1) . ": ";
#    $line .= join(' ', map { "deb_chroot_$_" } @{$layers[$i]});
#    $line .= " " if @{$layers[$i]};
#    print $line, "\n";
#}

# coverage report on stderr
my @uniq = sort keys %allnames;
# Locally resolved names: names referenced in any scanned field
# (Build-Depends* and Depends/Recommends) that are provided by a local
# Package: or Provides:.
my %locall;
for my $n (@uniq) {
    my @d = @{ $name2dirs{$n} || [] };
    $locall{$n} = 1 if @d;
}
my @local = sort keys %locall;
my @external = grep { !$locall{$_} } @uniq;

if ($opt_pkgs) {
    # --pkgs: for each dir in build order, print the dir, then its binary
    # Package: names (sorted).
    for my $layer (@layers) {
        for my $dir (@$layer) {
            print "$dir:\n";
            print "\t- $_\n" for sort keys %{$dirpkgs{$dir} || {}};
        }
    }
    exit 0;
}

if ($opt_names) {
    # --names: one line per locally-resolved dependency name.
    for my $n (@local) {
        print "$n\n";
    }
    exit 0;
}

# Default: one top-level dir per line, in build order. Every dir with a
# debian/control is seeded into @localdeps, so the flattened layers are
# exactly that set; layer 1 (no local build deps) comes first.
for my $layer (@layers) {
    print "$_\n" for @$layer;
}
#if (@external) {
#    print STDERR "  external (ignored):\n";
#    for my $n (@external) {
#        print STDERR "    $n ($deprefs{$n} refs)\n";
#    }
#}
