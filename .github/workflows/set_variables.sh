#!/bin/bash

# FIXME: tags ?

#set -eu
set -x

if test "${OS_VERSION:-}" = ""; then
    echo "ERROR: OS_VERSION env is empty"
    exit 1
fi
if test "${MFBUILD:-}" = ""; then
    echo "ERROR: MFBUILD env is empty"
    exit 1
fi

R=${GITHUB_REPOSITORY#metwork-framework/}
case "${GITHUB_EVENT_NAME}" in
    repository_dispatch)
        B=${PAYLOAD_BRANCH};;
    pull_request)
        case "${GITHUB_BASE_REF}" in
            master | integration | experimental* | release_* | ci* | pci* | github*)
                B=${GITHUB_BASE_REF};;
            *)
                B=null;
        esac;;
    push)
        case "${GITHUB_REF}" in
            refs/tags/v*)
                B=`git branch -a --contains "${GITHUB_REF}" | grep remotes | grep release_ | cut -d"/" -f3`;;
            refs/heads/*)
                B=${GITHUB_REF#refs/heads/};;
            *)
                B=null;
        esac;;
esac
if [ -z ${B} ]; then
  B=null
fi
TAG=
REF_BRANCH=
TARGET_DIR=
case "${GITHUB_REF}" in
    refs/heads/experimental* | refs/heads/master | refs/heads/release_*)
        REF_BRANCH=${B}
        TARGET_DIR=${B##release_};;
    refs/heads/integration | refs/heads/ci* | refs/heads/pci* | refs/heads/github* )
        REF_BRANCH=integration
        TARGET_DIR=master;;
    refs/tags/v*)
        TAG=${GITHUB_REF#refs/tags/}
        REF_BRANCH=${B}
        TARGET_DIR=${B##release_};;
    refs/pull/*)
        REF_BRANCH=${B}
        if [ "${REF_BRANCH}" == "integration" ]; then
            TARGET_DIR=master
        else
            TARGET_DIR=${B##release_}
        fi;;
esac

echo "::set-output name=branch::${B}"
echo "::set-output name=tag::${TAG}"
echo "::set-output name=ref_branch::${REF_BRANCH}"
echo "::set-output name=repository::${R}"
echo "::set-output name=target_dir::${TARGET_DIR}"
echo "::set-output name=buildimage::metwork/${MFBUILD}-${OS_VERSION}-buildimage:${REF_BRANCH}"
echo "::set-output name=testimage::metwork/${MFBUILD}-${OS_VERSION}-testimage:${REF_BRANCH}"
echo "::set-output name=buildlog_dir::/pub/metwork/continuous_integration/buildlogs/${B}/${R}/${OS_VERSION}/${GITHUB_RUN_NUMBER}"
echo "::set-output name=rpm_dir::/pub/metwork/continuous_integration/rpms/${B}/${OS_VERSION}"
echo "::set-output name=doc_dir::/pub/metwork/continuous_integration/docs/${B}/${R}"
