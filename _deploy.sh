#!/bin/sh

set -e

[ -z "${GH_TOKEN}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

# configure your name and email if you have not done so
git config --global user.email "xiangyunfaith@outlook.com"
git config --global user.name "Xiangyun Huang"

# clone the repository to the book-output directory
git clone -b gh-pages \
  https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git \
  book-output
cd book-output
git rm -rf *
cp -r ../_book/* ./
git add --all *
git commit -m"Update the book (travis build ${TRAVIS_BUILD_NUMBER})"
git push -q origin gh-pages
