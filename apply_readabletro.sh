#!/bin/bash
FILE=Balatro.exe

if [ ! -f $FILE ]; then
  echo "Couldn't find $FILE. Copy these files to Balatro's game directory and run apply_readabletro.sh again."
  exit 1
fi

EXPECTED_SIZE=55575314
ACTUAL_SIZE="$(du -b $FILE | cut -f1)"

if [ $ACTUAL_SIZE != $EXPECTED_SIZE ]; then
  echo "$FILE has an unexpected size - only an unmodified version 1.0.1g-FULL is supported."
  exit 1
fi

dd if=$FILE of=b.exe bs=394752 count=1 || exit 1
dd if=$FILE of=b.zip bs=394752 skip=1 || exit 1

pushd readabletro/mod > /dev/null
zip -r ../../b.zip * || exit 1
popd > /dev/null
mv Balatro.exe Balatro.exe.bak || exit 1
cat b.exe b.zip > Balatro.exe || exit 1
rm b.exe
rm b.zip

echo "Successfully patched Balatro.exe"
