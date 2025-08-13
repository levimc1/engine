rm -rf build
mkdir -p build

cmake -S . -B build
cmake --build build -j$(nproc)

cd build
./Game