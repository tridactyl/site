#!/bin/sh

# Nicked from https://gohugo.io/hosting-and-deployment/hosting-on-github/#put-it-into-a-script

# First time setup:
# git submodule init
# git submodule update

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

cd public

git reset --hard

git checkout master

git pull

cd -

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
        msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

cd ..

git add .

git commit -m "$msg"
