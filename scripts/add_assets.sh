#!/bin/bash

################################################################################
# Compile css

mkdir -vp ./static/css 2>/dev/null || true

command -v sass >/dev/null
if [ $? != 0 ]
then
    command -v sassc >/dev/null
    if [ $? != 0 ]
    then
        echo "Build failed. No sass or sassc in $PATH"
        exit 1
    else
        SASS=sassc
    fi
else
    SASS=sass
fi

for f in ./assets/sass/*
do
    filename="$(basename -- $f | cut -d '.' -f1)"
    if [[ ! $filename =~ ^_.* ]]
    then
        echo "Compiling $filename"
        $SASS $f ./static/css/$filename.css
    fi
done

################################################################################
# Write to .go file
GO_FILE="./mdserver/assets/genCss.go"

command -v cleancss >/dev/null
if [ $? != 0 ]
then
    echo "Build failed. No cleancss in \$PATH"
    echo "Run 'npm install clean-css -g'"
    exit 1
fi

rm -v $GO_FILE
echo -e "package assets\n\n// Stylesheets\n//This file is autogenerated from assets directory\nconst (\n" > $GO_FILE

for f in ./static/css/*
do
    filename="$(basename -- $f | cut -d '.' -f1)"
    filename=`echo ${filename:0:1} | tr  '[a-z]' '[A-Z]'`${filename:1}
    cleancss -o $f $f
    echo -e "    ${filename} = \`\n$(cat $f)\`\n" >> $GO_FILE
done

echo ")" >> $GO_FILE

rm -rf ./static/css

################################################################################
# Add js
echo "Adding the script"

GO_FILE="./mdserver/assets/genJs.go"
JS="./assets/js/JS.js"
ReloadJs="./assets/js/ReloadJs.js"

rm -v $GO_FILE
echo -e "package assets\n\n//This file is autogenerated from assets directory\nimport \"fmt\"\n\n// The script\nconst (" > $GO_FILE
echo -e "    JS = \`$(cat $JS)\`\n)\n" >> $GO_FILE
echo "//ReloadJs returns js responsible for a websocket reloading a page" >> $GO_FILE
echo "func ReloadJs(bindAddr string) string {" >> $GO_FILE
echo "    	return fmt.Sprintf(\`$(cat $ReloadJs)\`, bindAddr, bindAddr)" >> $GO_FILE
echo "}" >> $GO_FILE