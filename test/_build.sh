#!/bin/bash -e

cd "$(dirname "$0")"

if [ -z "$1" ]; then
    echo usage:
    echo "    ./build.sh fast_test.cc"
    echo "    ./build.sh flag_test.cc"
    exit 0
fi

src="$1"
sub1=""
sub2=".exe"
TGT="${src/.cc/$sub1}"
OUT="${src/_test.cc/$sub2}"

platform=`uname -m`

if [[ "$platform" == "x86_64" ]]; then
    PLAT="x64"
else
    PLAT="x86"
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	OS="linux"
    CC="g++"
    CCFLAGS="-std=c++11"
	LIBS="-lpthread"
    LIBBASE="libbase.a"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	OS="mac"
    CC="clang++"
    CCFLAGS="-std=c++11 -fno-pie"
    LIBBASE="libbase.a"
elif [[ "$OSTYPE" == "msys" ]]; then
	OS="win"
    CC="clang++"
    CCFLAGS="-Xclang -flto-visibility-public-std -Wno-deprecated"
    LIBBASE="base.lib"
else
	OS="oth"
    CC="g++"
    CCFLAGS="-std=c++11"
	LIBS="-lpthread"
    LIBBASE="libbase.a"
fi

if [[ ! -d "../build" ]]; then
    mkdir ../build
fi

#if [[ ! -f "../lib/$OS/$PLAT/$LIBBASE" ]]; then
#    ../base/_build.sh
#fi

$CC $CCFLAGS -O2 -g3 -o ../build/$OUT -I.. $src -L../lib ../lib/$LIBBASE -ljemalloc -ldl $LIBS

echo create build/$OUT ok.

exit 0
