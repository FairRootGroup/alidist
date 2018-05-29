package: GenFit
version:  "%(tag_basename)s"
source: https://github.com/GenFit/GenFit
tag: master
requires:
  - ROOT
  - eigen
build_requires:
  - CMake
---
#!/bin/sh -e

cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}                     \
      -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}                      \
      ${CXX_COMPILER:+-DCMAKE_CXX_COMPILER=$CXX_COMPILER}        \
      $SOURCEDIR

cmake --build . --target install ${JOBS:+-- -j$JOBS}

# ModuleFile
mkdir -p etc/modulefiles
cat > etc/modulefiles/$PKGNAME <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0                                                \\
            ${EIGEN_VERSION:+eigen/$EIGEN_VERSION-$EIGEN_REVISION}  \\
# Our environment
setenv GENFIT_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
EoF
MODULEDIR="$INSTALLROOT/etc/modulefiles"
mkdir -p $MODULEDIR && rsync -a --delete etc/modulefiles/ $MODULEDIR
