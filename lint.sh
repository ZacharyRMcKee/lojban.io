#!/usr/bin/env bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Haskell
echo "===> Haskell"
echo "Running hlint..."

ALL_FILES_OKAY="true"
for file in $(hlint -j8 --json src | jq --raw-output ".[].file" | uniq); do
    ALL_FILES_OKAY="false"
    echo -e "${RED}$file${NC}"
done

if [ "$ALL_FILES_OKAY" == "true" ]; then
    echo -e "${GREEN}All files passed.${NC}"
else
    echo -e "Code style issues found in the above file(s). Forgot to check hlint?"
fi

# Javascript
echo ""
echo "===> Javascript"
echo "Checking formatting..."

JAVASCRIPT_OK="true"
for file in $(prettier --list-different "static/scripts/*.js" | grep -v "\.min\.js$"); do
    JAVASCRIPT_OK="false"
    echo -e "${RED}$file${NC}"
done

if [ "$JAVASCRIPT_OK" == "true" ]; then
    echo -e "${GREEN}All files passed.${NC}"
else
    echo -e "Code style issues found in the above file(s). Forgot to run Prettier?"
fi

# CSS/Less
echo ""
echo "===> Less"
echo "Checking formatting..."

LESS_OK="true"
for file in $(prettier --list-different "static/style/*.less"); do
    LESS_OK="false"
    echo -e "${RED}$file${NC}"
done

if [ "$LESS_OK" == "true" ]; then
    echo -e "${GREEN}All files passed.${NC}"
else
    echo -e "Code style issues found in the above file(s). Forgot to run Prettier?"
fi
