#!/bin/bash

DIR="$(cd "$(dirname "${0}")" && pwd)"

echo -n "Installing doc "

ln -s $DIR/src/main/scripts/doc /usr/local/bin/doc
echo -n "."

ln -s $DIR/src/main/scripts/doc-prompt.sh /etc/bash_completion.d/
echo -n "."

echo "done."
