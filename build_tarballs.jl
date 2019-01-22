# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "json-c"
version = v"0.13.1"

# Collection of sources required to build json-c
sources = [
    "https://github.com/json-c/json-c.git" =>
    "e6212b65364e81588e67591a3c1e6ee4b615123b",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd json-c/
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make -j${nproc}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:musl),
    Linux(:x86_64, libc=:glibc),
    Linux(:i686, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libjson-c", Symbol("libjson-c"))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

