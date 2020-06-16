#!/bin/bash
# SIZE is WOLFBOOT_PARTITION_SIZE - 5
SIZE=131067 
VERSION=8
APP=test-app/image_v"$VERSION"_signed_and_encrypted.bin

# Create test key
echo -n "0123456789abcdef0123456789abcdef" > enc_key.der

./tools/keytools/sign.py --encrypt enc_key.der test-app/image.bin ecc256.der $VERSION
dd if=/dev/zero bs=$SIZE count=1 2>/dev/null | tr "\000" "\377" > update.bin
dd if=$APP of=update.bin bs=1 conv=notrunc
printf "pBOOT"  >> update.bin


