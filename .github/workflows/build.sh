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
