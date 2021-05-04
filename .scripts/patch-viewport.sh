#!/bin/sh -xe

sed -i.bak 's;</head>;<meta name="viewport" content="width=device-width, initial-scale=1">\
</head>;' *.html
rm *.html.bak # MacOS sed does not support -i without extension
