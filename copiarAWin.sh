#!/bin/bash
echo "Copiando archivos a build_win..."

cp *.html ./build_win/
cp *.qml ./build_win/
cp *.js ./build_win/
cp *.png ./build_win/
cp -r comps ./build_win/
cp -r py ./build_win/
cp -r Python ./build_win/
cp -r resources ./build_win/
cp -r swe ./build_win/

echo "Se han copiando todos los archivos a build_win."
