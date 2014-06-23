#!/bin/sh

if [ $# -ne 2 ]; then
    echo "usage: ./convert.sh sample.mp4 output" 1>&2
    echo "入力ファイル名 出力先ディレクトリの順に引数を指定" 1>&2
    exit 1
fi

BASE=$1
OUTPUT=$2
FULL=$OUTPUT/`echo $BASE | sed -e "s/\..\{3\}/-full.mp4/g"`
BANNER=$OUTPUT/`echo $BASE | sed -e "s/\..\{3\}/-banner.mp4/g"`
SQUARE=$OUTPUT/`echo $BASE | sed -e "s/\..\{3\}/-square.mp4/g"`

$OPTION="-c:v libx264 -profile:v baseline -r 23.976 -c:a libfaac -movflags faststart"

ffmpeg -i $1 -y $OPTION -vf "scale=640:360" -b:v 512k -b:a 64k $FULL
ffmpeg -i $1 -y $OPTION -vf "crop=640:100" -b:v 128k -an $BANNER
ffmpeg -i $1 -y $OPTION -vf "scale=iw*120/ih:120,crop=120:120" -b:v 64k -an $SQUARE

echo "Done!!"
exit 0
