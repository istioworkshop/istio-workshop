#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mRebuilding the book...\033[0m\n"

# Create tmp directory
tmp_dir=$(mktemp -d)

# Rebuild the book in tmp directory
gitbook build ./src $tmp_dir

# Move rendered content to public directory
mv $tmp_dir/* ./public/

# Remove tmp directory
rm -rf $tmp_dir

# Go to public folder
cd public

# Add changes to git
git add .

# Commit changes
msg="Rebuild book $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push changes
git push origin master
