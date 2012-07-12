# Cultivate #
Cultivate is a managed Tor build environment for Windows, Linux and OS X.
It contains all the necessary tools to develop, build and package various
Tor projects.

## Makefile ##
All targets can be called with either the output or the pseudo names.
The pseudo name is `action-seedname` where seedname is the name of the seed in
the *seeds* folder without the extension (e.g. *vidalia* or *tbb*).
Using the pseudo names is the easiest way.

### Sow ###
`make sow-seedname` will download the package sources to *sow*. It will
automatically verify signatures and hashes if provided. If the signature or 
hash verification fails, the target will fail and the temporary download
is kept for troubleshooting purposes.
`make fetch-seedname` can be used as a synonym.

### Sprout ###
`make sprout-seedname` will unpack all the package sources from *sow* to
*sprout*. It will automatically apply patches found in *patches/seedname*.
If the patches do not apply cleanly then the target will fail and the
temporary directory is kept for troubleshooting purposes.
`make unpack-seedname` can be used as a synonym.

### Grow ###
`make grow-seedname` will build the package from source and install to *grow*.
If a package has the variable SEEDNAME_DEPS set, then it will build all
dependencies instead.
`make build-seedname` can be used as a synonym.

### Graft ###
`make graft-seedname` will collate all the binaries and data into one folder
in *graft*. This can be used for testing or packaging the produced bundles.
`make bundle-seedname` can be used as a synonym.

### Harvest ###
`make harvest-seedname` will package the produced folder in the *graft*
directory. It will make a tar.gz file in *harvest*.
`make package-seedname` can be used as a synonym.

### Weed ###
`make weed` will remove all temporary files. Temporary files may be left
behind when a target fails with an error.
