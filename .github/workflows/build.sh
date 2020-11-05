#!/bin/bash

set -eu

B=${GITHUB_REF#refs/heads/}
R=${GITHUB_REPOSITORY#metwork-framework/}

yum install -y metwork-mfext-layer-python2-${BRANCH##release_}

cd /src
mkdir -p "/opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}"
MAKE_LOG="/pub/metwork/continuous_integration/buildlogs/${B}/${R}/${OS_VERSION}/${GITHUB_RUN_NUMBER}/make.log"

mkdir -p "$(dirname "${MAKE_LOG}")"
make >"${MAKE_LOG}" 2>&1 || ( tail -200 "${MAKE_LOG}" ; exit 1 )
OUTPUT=$(git status --short)
if test "${OUTPUT}" != ""; then
    echo "ERROR non empty git status output ${OUTPUT}"
    echo "git diff output"
    git diff
    exit 1
fi
MAKE_DOC="/pub/metwork/continuous_integration/buildlogs/${B}/${R}/${OS_VERSION}/${GITHUB_RUN_NUMBER}/make_doc.log"
if test -d docs; then make docs >"${MAKE_DOC}" 2>&1 || ( tail -200 "${MAKE_DOC}" ; exit 1 ); fi
if test -d doc; then make doc >"${MAKE_DOC}" 2>&1 || ( tail -200 "${MAKE_DOC}" ; exit 1 ); fi
rm -Rf html_doc
if test -d /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/html_doc; then cp -Rf /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/html_doc . ; fi
MAKE_TEST="/pub/metwork/continuous_integration/buildlogs/${B}/${R}/${OS_VERSION}/${GITHUB_RUN_NUMBER}/make_test.log"
make test >"${MAKE_TEST}" 2>&1 || ( tail -200 "${MAKE_TEST}" ; exit 1 )
MAKE_RPM="/pub/metwork/continuous_integration/buildlogs/${B}/${R}/${OS_VERSION}/${GITHUB_RUN_NUMBER}/make_rpm.log"
make RELEASE_BUILD=${GITHUB_RUN_NUMBER} rpm >"${MAKE_RPM}" 2>&1 || ( tail -200 "${MAKE_RPM}" ; exit 1 )
mv /opt/metwork-${MFMODULE_LOWERCASE}-${TARGET_DIR}/*.rpm .
