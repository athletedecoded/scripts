#!/bin/bash

# Script to compile multimodal llamafiles
# Usage: ./build-mm-llamafile.sh <MODEL_GGUF> <MMPROJ_GGUF> <LLAMAFILE_NAME>

# Check if llamafile is installed
MODEL_GGUF="$1"
MMPROJ_GGUF="$2"
LLAMAFILE="$3.llamafile"

LLAMAFILE_VERSION=$(llamafile --version 2>/dev/null)

if [ $? -eq 0 ]; then
    echo "${LLAMAFILE_VERSION} detected"

    # Check gguf paths exist
    if [ ! -e ${MODEL_GGUF} ]; then
        echo "Error: ${MODEL_GGUF} does not exist."
        exit 1
    fi

    if [ ! -e ${MMPROJ_GGUF} ]; then
        echo "Error: ${MMPROJ_GGUF} does not exist."
        exit 1
    fi

    # Write .args file
    cat << EOF > .args
-m
${MODEL_GGUF}
--mmproj
${MMPROJ_GGUF}
--host
0.0.0.0
-ngl
9999
EOF

    echo "Building ${LLAMAFILE}..."
    cp /usr/local/bin/llamafile $3.llamafile

    zipalign -j0 \
    $3.llamafile \
    $1 \
    $2 \
    .args

    chmod +x ${LLAMAFILE}
    
    echo "Success! You can now run ./${LLAMAFILE}"
else
    echo "llamafile not detected. Run ./install-llamafile.sh first"
fi