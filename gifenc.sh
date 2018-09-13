#!/bin/sh

DEFAULT_OUT_DIR=${GIFENC_DIR:-.}
DEFAULT_FPS=${GIFENC_FPS:-15}
DEFAULT_WIDTH=${GIFENC_WIDTH:-1}
DEFAULT_HEIGHT=${GIFENC_HEIGH:-1}

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if [ "x$OUTPUT_FILE" = "x" ]; then
   outfile="${INPUT_FILE%.*}"
   outfile="${outfile##*/}"
   outfile="${DEFAULT_OUT_DIR}/${outfile}.gif"
   OUTPUT_FILE="$outfile"
fi

if [ "x$FPS" = "x" ]; then
    FPS="$DEFAULT_FPS"
fi

if [ "x$WIDTH" = "x" ]; then
    WIDTH="$DEFAULT_WIDTH"
fi

if [ "x$HEIGHT" = "x" ]; then
    HEIGHT="$DEFAULT_HEIGHT"
fi

palette="/tmp/palette.png"

filters="fps=$FPS,scale=$WIDTH:$HEIGHT:flags=lanczos"

ffmpeg -v warning -i $INPUT_FILE -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i $INPUT_FILE -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $OUTPUT_FILE


size=$(wc -c <"$OUTPUT_FILE")
size_kb=$(bc -l <<< "scale=2;$size / 1000")

echo "Output: $OUTPUT_FILE with size: ${size_kb}KB"
