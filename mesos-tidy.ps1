$TOOL = "mesos-tidy"
$VERSION = "2017-11-17"
$PREFIX = "${TOOL}/${VERSION}"

wget https://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz -OutFile llvm-5.0.0.src.tar.xz
7z e llvm-5.0.0.src.tar.xz
7z x llvm-5.0.0.src.tar
mv llvm-5.0.0.src llvm

git clone -q --depth 1 -b mesos_50 https://github.com/mesos/clang.git llvm/tools/clang
git clone -q --depth 1 -b mesos_50 https://github.com/mesos/clang-tools-extra.git llvm/tools/clang/tools/extra

cmake -G "Visual Studio 15 2017 Win64" -Thost=x64 -DCMAKE_INSTALL_PREFIX="${PREFIX}" llvm

cmake --build . --target tools/clang/tools/extra/clang-tidy/install --config Release -- /m:2
cmake --build . --target tools/clang/tools/extra/clang-apply-replacements/install --config Release -- /m:2
rm -r "${PREFIX}/lib"
cmake --build . --target tools/clang/lib/Headers/install --config Release -- /m:2

Compress-Archive -DestinationPath "${TOOL}-${VERSION}.windows.zip" -Path "${TOOL}"
