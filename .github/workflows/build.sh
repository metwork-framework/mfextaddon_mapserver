#!/bin/bash

#set -eu
set -x

if test -d /buildcache; then export BUILDCACHE=/buildcache; fi

#We keep the names DRONE_* with github_actions because they are used by guess_version.sh
export DRONE_BRANCH=${BRANCH}
export DRONE_TAG=${TAG}
export DRONE=true



    if test "${OS_VERSION}" = "centos8"; then export METWORK_BUILD_OS=generic; else export METWORK_BUILD_OS=${OS_VERSION}; fi


git config --global --add safe.directory /src
cd /src




mkdir -p "/opt/metwork-mfext-${TARGET_DIR}"

mkdir -p buildlogs
export BUILDLOGS=buildlogs

make >${BUILDLOGS}/make.log 2>&1 || ( tail -200 ${BUILDLOGS}/make.log ; exit 1 )

OUTPUT=$(git status --short | grep -v buildlogs | grep -v buildcache)

if test "${OUTPUT}" != ""; then
    echo "ERROR non empty git status output ${OUTPUT}"
    echo "git diff output"
    git diff
    exit 1
fi

 

if test -d docs; then make docs >${BUILDLOGS}/make_doc.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_doc.log ; exit 1 ); fi
if test -d doc; then make doc >${BUILDLOGS}/make_doc.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_doc.log ; exit 1 ); fi
rm -Rf html_doc
if test -d /opt/metwork-mfext-${TARGET_DIR}/html_doc; then cp -Rf /opt/metwork-mfext-${TARGET_DIR}/html_doc . ; fi
make test >${BUILDLOGS}/make_test.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_test.log ; exit 1 )
make RELEASE_BUILD=${GITHUB_RUN_NUMBER} rpm >${BUILDLOGS}/make_rpm.log 2>&1 || ( tail -200 ${BUILDLOGS}/make_rpm.log ; exit 1 )

mkdir rpms
mv /opt/metwork-mfext-${TARGET_DIR}/*.rpm rpms

 

echo "bypass=false" >> github_output
