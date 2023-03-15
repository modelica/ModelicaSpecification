#!/bin/sh -xe

sed -i.bak 's/<body>/<body tabindex=0>/' *.html
rm *.html.bak # MacOS sed does not support -i without extension
