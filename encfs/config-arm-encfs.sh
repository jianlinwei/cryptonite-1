#! /bin/bash

NDKDIR=${HOME}/android-ndk-r7
TOOLCHAIN=${HOME}/android-toolchain
FUSEDIR=`pwd`/../../fuse/fuse-android
OPENSSLDIR=`pwd`/../../openssl/openssl-android
BOOSTDIR=`pwd`/../../boost/boost_1_46_1
RLOGDIR=`pwd`/../../rlog/rlog-1.4
MYAR=arm-linux-androideabi-ar
MYRANLIB=arm-linux-androideabi-ranlib
MYNM=arm-linux-androideabi-nm
MYSTRIP=arm-linux-androideabi-strip

if test -n "$1"; then
    MYAGCC=agcc-vfp
    ARCH=armeabi-v7a
else
    MYAGCC=agcc
    ARCH=armeabi
fi

LIBSTDCXXINC="-I${NDKDIR}/sources/cxx-stl/gnu-libstdc++/include -I${NDKDIR}/sources/cxx-stl/gnu-libstdc++/libs/armeabi/include"
LIBSTDCXXLIB="-L${NDKDIR}/sources/cxx-stl/gnu-libstdc++/libs/armeabi -lgnustl_static"

TARGET=`pwd`/${ARCH}

AR=${MYAR} RANLIB=${MYRANLIB} NM=${MYNM} STRIP=${MYSTRIP} CC=${MYAGCC} CXX=${MYAGCC} \
    PKG_CONFIG="" \
    OPENSSL_CFLAGS="-DOPENSSL_NO_ENGINE -DHAVE_EVP_AES -DHAVE_EVP_BF -D__STDC_FORMAT_MACROS -I${OPENSSLDIR}/include" \
    OPENSSL_LIBS="-L${OPENSSLDIR}/libs/armeabi -lssl -lcrypto -ldl" \
    RLOG_CFLAGS="-I${RLOGDIR}/armeabi/include" \
    RLOG_LIBS="${RLOGDIR}/rlog/.libs/librlog.a -L${RLOGDIR}/rlog/.libs -lrlog" \
    CPPFLAGS="-DBOOST_FILESYSTEM_VERSION=2 -I${TOOLCHAIN}/sysroot/usr/include -I${FUSEDIR}/jni/include -I${BOOSTDIR} ${OPENSSL_CFLAGS} ${RLOG_CFLAGS}" \
    CXXFLAGS="${LIBSTDCXXINC} -fexceptions -frtti" \
    LDFLAGS="${LIBSTDCXXLIB} ${OPENSSL_LIBS} -L${BOOSTDIR}android/lib -L${FUSEDIR}/obj/local/armeabi -lgcc ${RLOG_LIBS}" \
    ./configure --prefix=${TARGET} --host=x86-linux --build=arm-eabi --enable-static --disable-shared --with-boost=${BOOSTDIR}/android