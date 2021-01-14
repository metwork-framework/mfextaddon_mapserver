#!/bin/bash

#set -eu
set -x

yum install -y metwork-mfext-layer-python2-${REF_BRANCH##release_}

if test -d /buildcache; then export BUILDCACHE=/buildcache; fi

export DRONE_BRANCH=${BRANCH}
export DRONE_TAG=""
export DRONE=true

cd /src

mkdir -p "/opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}"

mkdir -p buildlogs
export BUILDLOGS=buildlogs

make >${BUILDLOGS}/make.log 2>&1 || ( tail -200 ${BUILDLOGS}/make.log ; exit 1 )

OUTPUT=$(git status --short | grep -v buildlogs | grep -v buildcache)
echo ${OUTPUT}
if test "${OUTPUT}" != ""; then
    echo "ERROR non empty git status output ${OUTPUT}"
    echo "git diff output"
    git diff
    exit 1
fi

ls -l /opt
ls -l /opt/metwork-mfext-integration
ls -l /opt/metwork-mfext-master

MODULEHASH=`/opt/metwork-mfext-${TARGET_DIR}/bin/mfext_wrapper module_hash 2>module_hash.debug`
if test -f /opt/metwork-mfext-${TARGET_DIR}/.dhash; then cat /opt/metwork-mfext-${TARGET_DIR}/.dhash; fi
cat module_hash.debug |sort |uniq ; rm -f module_hash.debug
echo "$${MODULEHASH}${DRONE_TAG}${DRONE_BRANCH}" |md5sum |cut -d ' ' -f1 >.build_hash
if test -f "${BUILDCACHE}/build_hash_`cat .build_hash`"; then
    echo "::set-output name=bypass::true"
    exit 0
fi

if test -d docs; then make docs >${BUILDLOGS}/make_doc.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_doc.log ; exit 1 ); fi
if test -d doc; then make doc >${BUILDLOGS}/make_doc.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_doc.log ; exit 1 ); fi
rm -Rf html_doc
if test -d /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/html_doc; then cp -Rf /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/html_doc . ; fi
make test >${BUILDLOGS}/make_test.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_test.log ; exit 1 )
make RELEASE_BUILD=${GITHUB_RUN_NUMBER} rpm >${BUILDLOGS}/make_rpm.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_rpm.log ; exit 1 )

mkdir rpms
mv /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/*.rpm rpms

echo cached > ${BUILDCACHE}/build_hash_`cat .build_hash`

echo "::set-output name=bypass::false"

