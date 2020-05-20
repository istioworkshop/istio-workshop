#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mRebuilding book...\033[0m\n"

# Remove present content
rm -rf docs

# Rebuild the book
gitbook build . docs

# Stage changes
git add docs

# Commit changes
msg="Rebuild book $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push changes
git push origin master
