#!/bin/sh

# Copyright (C) 2020, TrussLab@University of California, Irvine. 
# Authors: Yingtong Liu
#
# This document is shared under the GNU Free Documentation License WITHOUT ANY WARRANTY. 
# See https://www.gnu.org/licenses/ for details.

export NDK=$1
export PATH=$NDK/bin:$PATH
export SYSROOT="$NDK/sysroot"
export PREFIX="arm-linux-androideabi-"
export AR=${PREFIX}ar
export AS=${PREFIX}as
export LD=${PREFIX}ld
export NM=${PREFIX}nm
export CC=${PREFIX}gcc
export CLANG=${PREFIX}clang
export CXX=${PREFIX}g++
export CXXCLANG=${PREFIX}clang++
export CPP=${PREFIX}cpp
export CXXCPP=${PREFIX}cpp
export STRIP=${PREFIX}strip
export RANLIB=${PREFIX}ranlib
export STRINGS=${PREFIX}strings
export CFLAGS="-I${NDK}/include" 
export CXXFLAGS=${CFLAGS}
export LDFLAGS="-fPIE -pie"
cd $NDK
####The sequence matters, do no change###
MAKE="make -j8"
###libiconv###
wget https://ftp.gnu.org/gnu/libiconv/libiconv-1.15.tar.gz
tar -xvf libiconv-1.15.tar.gz
cd libiconv-1.15 
./configure --prefix="${SYSROOT}/usr" --host=arm-linux-androideabi
$MAKE
make install
cd ..
###libffi###
wget https://sourceware.org/ftp/libffi/libffi-3.2.1.tar.gz
tar -xvf libffi-3.2.1.tar.gz
cd libffi-3.2.1
sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' -i include/Makefile.in
sed -e '/^includedir/ s/=.*$/=@includedir@/' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in
./configure --prefix="${SYSROOT}/usr" --host=arm-linux-androideabi --enable-static
$MAKE
make install
cd ..
###prebuilt###
tar -xvf mousse_prebuilt_deps.tar.gz
cp -r mousse_prebuilt_deps/include/* ./sysroot/usr/include 
cp -r mousse_prebuilt_deps/lib/* ./sysroot/usr/lib

###gettext###
#This will not fully succeed. But as long as you got libintl.so, you are good
wget https://ftp.gnu.org/gnu/gettext/gettext-0.18.3.tar.gz
tar -xvf gettext-0.18.3.tar.gz
cd gettext-0.18.3
./configure --prefix="${SYSROOT}/usr" --host=arm-linux-androideabi --disable-rpath --disable-libasprintf --disable-java --disable-native-java --disable-openmp --disable-curses --disable-libtool-lock
sed -i '/HAVE___FSETLOCKING/s/^/\/\//g' ./gettext-tools/config.h 
sed -i '/HAVE___FSETLOCKING/s/^/\/\//g' ./gettext-runtime/config.h 
sed -i '/stdio_ext/s/^/\/\//g' ./gettext-runtime/intl/localealias.c
$MAKE
make install
cd ..
###libdwarf###
wget https://sources.voidlinux.org/libdwarf-20180809/libdwarf-20180809.tar.gz
tar -xvf libdwarf-20180809.tar.gz
cd libdwarf-20180809 
./configure --prefix="${SYSROOT}/usr" --host=arm-linux-androideabi
$MAKE
make install
cd ..
##glib###
wget https://ftp.gnome.org/pub/gnome/sources/glib/2.48/glib-2.48.1.tar.xz
tar -xvf glib-2.48.1.tar.xz
cd glib-2.48.1
cp ../mousse_prebuilt_deps/glib/android.cache.arm ./
chmod a-x android.cache.arm
./configure --prefix="${SYSROOT}/usr" --host=arm-linux-androideabi --cache-file=android.cache.arm --enable-static --with-pcre=no --enable-included-printf --disable-dependency-tracking --disable-libelf
$MAKE
make install
cd ..
