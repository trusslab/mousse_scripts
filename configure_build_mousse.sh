###################################
# Cross build mousse for armv7    #
###################################
# !/bin/bash
MOUSSE_ROOT="/home/$USER/Mousse"
export NDK=${MOUSSE_ROOT}/mousse_dependencies
export PATH=$NDK/bin:$PATH
export SYSROOT="$NDK/sysroot"
export PREFIX="$NDK/bin/arm-linux-androideabi-"
export AR=${PREFIX}ar
export AS=${PREFIX}as
export LD=${PREFIX}ld
export NM=${PREFIX}nm
export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export CLANG=${PREFIX}clang
export CXXCLANG=${PREFIX}clang++
export CPP=${PREFIX}cpp
export CXXCPP=${PREFIX}cpp
export STRIP=${PREFIX}strip
export RANLIB=${PREFIX}ranlib
export STRINGS=${PREFIX}strings
export CFLAGS="-I${NDK}/include" 
export CXXFLAGS="-I${NDK}/include"
export PKG_CONFIG_PATH="$SYSROOT/usr/lib/pkgconfig"
MOUSSE_SRC=${MOUSSE_ROOT}/mousse_source
QEMUSRC=${MOUSSE_ROOT}/mousse_qemu
make -j36 -f ${MOUSSE_SRC}/Makefile all-debug
mkdir qemu-debug
cd qemu-debug

export LDFLAGS="-lm -fPIE -pie -Wl,--export-dynamic-symbol -Wl,qemu_coroutine_create -Wl,--export-dynamic-symbol -Wl,qemu_coroutine_enter -Wl,--export-dynamic-symbol -Wl,qemu_coroutine_yield -Wl,--export-dynamic-symbol -Wl,mmap_next_start -Wl,--export-dynamic-symbol -Wl,user_kvm_cpu_exec -Wl,--export-dynamic-symbol -Wl,qemu_uname_release -Wl,--export-dynamic-symbol -Wl,exec_path" 

$QEMUSRC/configure --prefix="$SYSROOT/usr" --cpu="arm" --target-list=arm-linux-user --disable-system --disable-bsd-user --disable-zlib-test --disable-guest-agent --disable-docs --disable-seccomp
make -j60
cd ..
