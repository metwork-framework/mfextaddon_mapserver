#!/bin/bash

mkdir -p ${BUILDCACHE}
mkdir -p ${CACHED_BUILDCACHE}
rm -rf ${CACHED_BUILDCACHE}/tmp
for file in `ls ${CACHED_BUILDCACHE}`; do
cp $file ${BUILDCACHE}
done
