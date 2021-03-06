#!/usr/bin/env bash
set -exo pipefail

# Enable git+ssh. Env variables are created on the fly with the gitCheckout
git config remote.origin.url "git@github.com:${ORG_NAME}/${REPO_NAME}.git"

# Enable to fetch branches when cloning with a detached and shallow clone
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

# Force the git user details when pushing using the last commit details
USER_MAIL=$(git log -1 --pretty=format:'%ae')
USER_NAME=$(git log -1 --pretty=format:'%an')
git config user.email "${USER_MAIL}"
git config user.name "${USER_NAME}"

# Checkout the branch as it's detached based by default.
# See https://issues.jenkins-ci.org/browse/JENKINS-33171
git fetch --all
git checkout "${BRANCH_NAME}"

# Checkout the master branch to be able to rebase the *.x branch
git checkout master

# Ensure the master branch points to the original commit to avoid commit injection
# when running the release pipeline.
# used GIT_BASE_COMMIT instead GIT_COMMIT to support the MultiBranchPipelines.
git reset --hard "${GIT_BASE_COMMIT}"
