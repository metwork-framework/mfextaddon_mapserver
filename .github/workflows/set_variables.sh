#!/bin/bash

# FIXME: tags ?
# FIXME: PRs ?

set -eu

if test "${OS_VERSION:-}" = ""; then
    echo "ERROR: OS_VERSION env is empty"
    exit 1
fi
if test "${MFBUILD:-}" = ""; then
    echo "ERROR: MFBUILD env is empty"
    exit 1
fi

R=${GITHUB_REPOSITORY#metwork-framework/}
B=${GITHUB_REF#refs/heads/}
case "${GITHUB_REF}" in
    refs/heads/experimental* | refs/heads/master | refs/heads/release_*)
        REF_BRANCH=${B};;
    *)
        REF_BRANCH=integration;;
esac

echo "::set-output name=refbranch::${REF_BRANCH}"
echo "::set-output name=buildimage::metwork/${MFBUILD}-${OS_VERSION}-buildimage:${REF_BRANCH}"
echo "::set-output name=testimage::metwork/${MFBUILD}-${OS_VERSION}-testimage:${REF_BRANCH}"
echo "::set-output name=buildlog_dir::/pub/metwork/continuous_integration/buildlogs/${B}/${R}/${OS_VERSION}/${GITHUB_RUN_NUMBER}"
echo "::set-output name=rpm_dir::/pub/metwork/continuous_integration/rpms/${B}/${OS_VERSION}"
