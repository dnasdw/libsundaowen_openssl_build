#!/bin/bash

pushd "`dirname "$0"`"
tmpdir=/tmp/libsundaowen_openssl
target=linux_x86_32
prefix=$tmpdir/$target
openssldir=$prefix/ssl
version=`cat version.txt`
rm -rf "$tmpdir/$version"
mkdir -p "$tmpdir/$version"
cp -rf "../$version/"* "$tmpdir/$version"
pushd "$tmpdir/$version"
./Configure no-shared no-asm --prefix="$prefix" --openssldir="$openssldir" linux-generic32 -m32 -fPIC
make
make install
popd
mkdir -p "../target/include/$target"
cp -rf "$prefix/include/"* "../target/include/$target"
mkdir -p "../target/lib/$target"
cp -f "$prefix/lib/"*.a "../target/lib/$target"
popd
rm -rf "$tmpdir"
