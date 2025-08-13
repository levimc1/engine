
set -e

BUILD_TYPE="DEBUG"
BUILD_DIR="build"
INSTALL_DIR="install"
ENABLE_LOGGING="ON"
RUN="OFF"

while getops "drel" opt; do
  case $opt in
    d) BUILD_TYPE="DEBUG" ;;
    r) BUILD_TYPE="RELEASE" ;;
    e) RUN="ON" ;;
    l) ENABLE_LOGGING="OFF" ;;
    *) echo "Használat: -d debug (alapértelmezett)"
       echo "           -r release                "
       echo "           -e futtatás               "
       echo "           -l logging kikapcsolása   "
       exit 1
  esac
done

echo "-=== Projekt építése ===-"
echo "Build típus: $BUILD_TYPE"
echo "Logging:     $ENABLE_LOGGING"

# TODO: implementálni több argumentet stb, jelenleg semmi értelme sincs :/

cmake .. \ # ChatGPT azt mondta ezzel tudok majd ilyen izéket hozzáadni, jelenleg nem megy
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DENABLE_CMAKE_LOGGING=$ENABLE_LOGGING \
  -DCMAKE_INSTALL_PREFIX=../$INSTALL_DIR

cmake --build . --config $BUILD_TYPE -- -j$(nproc)
cmake --install .

echo "-=== Sikeresen építve ===-"
echo "Futtatható file: $INSTALL_DIR/bin"


if [ "$RUN_EXECUTABLE" = "ON" ]; then
  echo "-=== Futtatás ===-"
  EXEC_PATH="../$INSTALL_DIR/bin/Game"
  if [ -f "$EXEC_PATH" ]; then
    echo "------------------------- OUTPUT -------------------------"
    "$EXEC_PATH"
    echo "---------------------------------------------------------"
    echo "-=== Futtatás befejezve ===-"
  else
    echo "Hiba: futtatható file nem találva: $EXEC_PATH"
    exit 1
  fi
fi