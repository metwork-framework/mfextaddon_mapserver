#!/bin/bash

set -eu

yum install -y metwork-mfext-layer-python2-${REF_BRANCH##release_}

export DRONE_BRANCH=${BRANCH}
export DRONE_TAG=""
export DRONE=true

cd /src
mkdir -p "/opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}"

mkdir -p "${BUILDLOG}"
mkdir -p "${BUILDCACHE}"
make >"${BUILDLOG}/make.log" 2>&1 || ( tail -200 "${BUILDLOG}/make.log" ; exit 1 )
OUTPUT=$(git status --short)
if test "${OUTPUT}" != ""; then
    echo "ERROR non empty git status output ${OUTPUT}"
    echo "git diff output"
    git diff
    exit 1
fi
MODULEHASH=`/opt/metwork-mfext-${TARGET_DIR}/bin/mfext_wrapper module_hash 2>module_hash.debug`
if test -f /opt/metwork-mfext-${TARGET_DIR}/.dhash; then cat /opt/metwork-mfext-${TARGET_DIR}/.dhash; fi
cat module_hash.debug |sort |uniq ; rm -f module_hash.debug
echo "$${MODULEHASH}${DRONE_TAG}${DRONE_BRANCH}" |md5sum |cut -d ' ' -f1 >.build_hash
if test -f "$${BUILDCACHE}/build_hash_`cat .build_hash`"; then
    echo "next bypass"
    touch .drone_downstream_bypass
    echo "::set-output name=bypass::true"
    exit 0
fi

if test -d docs; then make docs >"${BUILDLOG}/make_doc.log" 2>&1 || ( tail -200 "${BUILDLOG}/make_doc.log" ; exit 1 ); fi
if test -d doc; then make doc >"${BUILDLOG}/make_doc.log" 2>&1 || ( tail -200 "${BUILDLOG}/make_doc.log" ; exit 1 ); fi
rm -Rf html_doc
if test -d /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/html_doc; then cp -Rf /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/html_doc . ; fi
make test >"${BUILDLOG}/make_test.log" 2>&1 || ( tail -200 "${BUILDLOG}/make_test.log" ; exit 1 )
make RELEASE_BUILD=${GITHUB_RUN_NUMBER} rpm >"${BUILDLOG}/make_rpm.log" 2>&1 || ( tail -200 "${BUILDLOG}/make_rpm.log" ; exit 1 )

mkdir rpms
mv /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/*.rpm rpms
mkdir buildlogs
mv ${BUILDLOG}/make*.log  buildlogs

echo "::set-output name=bypass::false"
