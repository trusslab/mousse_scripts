#!/bin/bash
export NDK=/home/$USER/Mousse/mousse_dependencies
export SYSROOT="$NDK/sysroot"
export PREFIX="$NDK/bin/arm-linux-androideabi-"
export GCC=${PREFIX}gcc
FILE="$1"
$GCC -g -I./include -fPIE -pie $FILE -o ${FILE%.*} 
