#!/bin/bash

set -eu

B=${GITHUB_REF#refs/heads/}
R=${GITHUB_REPOSITORY#metwork-framework/}

yum install -y metwork-mfext-layer-python2-${BRANCH##release_}

cd /src
mkdir -p "/opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}"

export DRONE_BRANCH=${B}
export DRONE=true

mkdir -p "${BUILDLOG}"
make >"${BUILDLOG}/make.log" 2>&1 || ( tail -200 "${BUILDLOG}/make.log" ; exit 1 )
OUTPUT=$(git status --short)
if test "${OUTPUT}" != ""; then
    echo "ERROR non empty git status output ${OUTPUT}"
    echo "git diff output"
    git diff
    exit 1
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
