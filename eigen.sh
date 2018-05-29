package: eigen
version: "%(tag_basename)s"
tag: "3.3.4"
source: https://github.com/eigenteam/eigen-git-mirror
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
module load BASE/1.0                                                                    \\
# Our environment
setenv EIGEN_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
EoF
MODULEDIR="$INSTALLROOT/etc/modulefiles"
mkdir -p $MODULEDIR && rsync -a --delete etc/modulefiles/ $MODULEDIR
