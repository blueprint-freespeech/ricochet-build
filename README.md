# Ricochet Build

This project is used to build and sign [Ricochet-Refresh](https://github.com/blueprint-freespeech/ricochet-refresh/) releases for all of our supported platforms: Windows (x86 and x86_64), Linux (x86 and x86_64), and macOS (x86_64 and aarch64). All targets may be built, packaged, and signed from a single Linux host.

A previous version of this repository was used to build Ricochet-Refresh prior to version 3.0.17. It was a fork of [tor-browser-build](https://gitlab.torproject.org/tpo/applications/tor-browser-build)) can be found in the [legacy](https://github.com/blueprint-freespeech/ricochet-build/tree/legacy) branch. This latest version is a complete re-write and no longer has any legacy `tor-browser` related cruft.

## Installing Dependencies

`ricochet-build` uses the Tor Project's [reproducible build manager](https://rbm.torproject.org/) (RBM) to manage the builds and dependencies. To build Ricochet Refresh, you need a recent Linux distribution which supports [user_namespaces(7)](https://www.man7.org/linux/man-pages/man7/user_namespaces.7.html).  You will need to install the `uidmap` package. RBM also depends on several perl modules:

- Data::Dump
- Data::UUID
- DateTime
- Digest::SHA
- File::Basename
- File::Copy::Recursive
- File::Path
- File::Slurp
- File::Temp
- Getopt::Long
- IO::CaptureOutput
- IO::Handle
- JSON
- Parallel::ForkManager
- Path::Tiny
- Sort::Versions
- String::ShellQuote
- Template
- XML::Writer
- YAML::XS

On Debian-based systems, you can install them with:

```
# apt-get install libdata-dump-perl libdata-uuid-perl libdatetime-perl \
                  libdigest-sha-perl libfile-copy-recursive-perl \
                  libfile-slurp-perl libio-all-perl libio-captureoutput-perl \
                  libio-handle-util-perl libjson-perl \
                  libparallel-forkmanager-perl libpath-tiny-perl \
                  libsort-versions-perl libstring-shellquote-perl \
                  libtemplate-perl libxml-libxml-perl libxml-writer-perl \
                  libyaml-libyaml-perl git mercurial uidmap
```

For more thorough (and up-to-date) instructions please see the `tor-browser-build` [README](https://gitlab.torproject.org/tpo/applications/tor-browser-build/-/blob/main/README).

## Building

`ricochet-build` offers three different build channels:

- `stable`: the current `ricochet-refresh` maintenance branch
- `alpha`: the current `ricochet-refresh` development branch
- `testbuild`: meant for development builds

To build each of these channels for all supported platforms, the following make targets are provided:

- `ricochet-release-stable`
- `ricochet-release-alpha`
- `ricochet-release-testbuild`

The outputs of each of these build targets will be placed under the `./release/${channel}/unsigned` directory.

For signed-releases, the additional make targets are provided:

- `ricochet-release-stable-sign`
- `ricochet-release-alpha-sign`

The outputs of each of these build targets will be placed under the `./release/${channel}/signed` directory.

To sign releases locally, you will need to configure your rbm.local.conf file to point the build system to the relevant keys, passwords, and libraries used by the various signing tools.

There are also more specific targets for building just a particular architecture's installation packages. In general, these targets are of the form:

- `ricochet-${OS}-${ARCH}-${CHANNEL}` - build packages for a particular OS (`windows`, `linux`, `macos`), CPU architecture (`x86`, `x86_64`, `aarch64`), and  channel (`stable`, `alpha`, `testbuild`); not all CPU architectures are supported for all OS
- `ricochet-${OS}-${CHANNEL}` - build packages for all supported CPU architectures for a particular OS and channel pair

For the specific supported targets, please see the [Makefile](./Makefile). The built packages will appear in the `./out/packages` directory. The following package formats are supported:

- Windows
  - NSIS installer
  - portable .zip archive
- Linux
  - AppImage
  - .deb package
  - portable .tar.gz archive
- macOS
  - DMG image

Finally, an `rbm.local.conf.example` file is provided with various options for developer use. Rename this file to `rbm.local.conf` to apply its settings over the default ones.