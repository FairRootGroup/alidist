#Online Device Control
package: ODC
version: "%(tag_basename)s"
tag: "fix_62"
source: https://github.com/FairRootGroup/ODC.git
requires:
  - boost
  - protobuf
  - DDS
  - FairLogger
  - FairMQ
  - flatbuffers
  - grpc
  - libInfoLogger
  - "OpenSSL:(?!osx)"
build_requires:
  - alibuild-recipe-tools
  - CMake
  - GCC-Toolchain:(?!osx.*)
---

case $ARCHITECTURE in
  osx*)
    [[ ! $BOOST_ROOT ]] && BOOST_ROOT=`brew --prefix boost`
    [[ ! $FLATBUFFERS_ROOT ]] && GRPC_ROOT=`brew --prefix flatbuffers`
    [[ ! $GRPC_ROOT ]] && GRPC_ROOT=`brew --prefix grpc`
    [[ ! $OPENSSL_ROOT ]] && OPENSSL_ROOT=`brew --prefix openssl@1.1`
    [[ ! $PROTOBUF_ROOT ]] && PROTOBUF_ROOT=`brew --prefix protobuf`
  ;;
  *) ;;
esac

cmake $SOURCEDIR                                                \
      ${CMAKE_GENERATOR:+-G "$CMAKE_GENERATOR"}                 \
      ${CMAKE_BUILD_TYPE:+-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE} \
      ${CXX_COMPILER:+-DCMAKE_CXX_COMPILER=$CXX_COMPILER}       \
      ${CXXSTD:+-DCMAKE_CXX_STANDARD=$CXXSTD}                   \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON                        \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT                       \
      -DBoost_NO_SYSTEM_PATHS=${BOOST_NO_SYSTEM_PATHS}          \
      -DCMAKE_INSTALL_LIBDIR=lib                                \
      ${OPENSSL_ROOT_DIR:+-DOPENSSL_ROOT_DIR=$OPENSSL_ROOT}     \
      -DDISABLE_COLOR=ON                                        \
      -DBUILD_INFOLOGGER=ON

cmake --build . --target install ${JOBS:+-- -j$JOBS}

# ModuleFile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
alibuild-generate-module --bin --lib > $MODULEFILE
