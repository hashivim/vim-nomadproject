#!/bin/bash
VERSION=$1

function usage {
    echo -e "
    USAGE EXAMPLES:

        ./$(basename $0) 0.8.7
        ./$(basename $0) 0.9.2
    "
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

EXISTING_NOMAD_VERSION=$(nomad version | head -n1 | awk '{print $2}' | sed 's/v//g')

if [ "${EXISTING_NOMAD_VERSION}" != "${VERSION}" ]; then
    echo "-) You are trying to update this script for nomad ${VERSION} while you have"
    echo "   nomad ${EXISTING_NOMAD_VERSION} installed at $(which nomad)."
    echo "   Please update your local nomad before using this script."
    exit 1
fi

echo "+) Acquiring nomad-${VERSION}"
wget https://github.com/hashicorp/nomad/archive/v${VERSION}.tar.gz

echo "+) Extracting nomad-${VERSION}.tar.gz"
tar zxf v${VERSION}.tar.gz

echo "+) Running update_commands.rb"
./update_commands.rb

echo "+) Updating the badge in the README.md"
sed -i "/img.shields.io/c\[\![](https://img.shields.io/badge/Supports%20Nomad%20Version-${VERSION}-blue.svg)](https://github.com/hashicorp/nomad/blob/v${VERSION}/CHANGELOG.md)" README.md

echo "+) Cleaning up after ourselves"
rm -f v${VERSION}.tar.gz
rm -rf nomad-${VERSION}

git status
