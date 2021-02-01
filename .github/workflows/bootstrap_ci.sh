#!/bin/bash

set -eu


    

cd /src

mkdir -p /opt/metwork-mfext-${TARGET_DIR}
./bootstrap.sh /opt/metwork-mfext-${TARGET_DIR}

cat adm/root.mk
env | sort
