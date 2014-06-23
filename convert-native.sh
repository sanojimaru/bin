#!/bin/sh

if [ $# -ne 4 ]; then
    echo "usage: ./convert.sh sample.mp4 output 0 5 " 1>&2
    echo "入力ファイル名 出力先ディレクトリの順に引数を指定 バナー開始秒数 バナー秒数" 1>&2
    exit 1
fi

BASE=$1
OUTPUT=$2
FEED_START=$3
FEED_SEC=$4
FULL=$OUTPUT/`echo $BASE | sed -e "s/\..\{3\}/-full.mp4/g"`
FIVESEC=$OUTPUT/`echo $BASE | sed -e "s/\..\{3\}/-banner.mp4/g"`

$OPTION="-c:v libx264 -profile:v baseline -c:a libfaac -movflags faststart"

ffmpeg -i $1 -y $OPTION -vf "scale=640:360" -b:v 400k -b:a 64k -ar 44100 -ac 2 $FULL
ffmpeg -i $1 -y $OPTION -vf "scale=640:360" -b:v 400k -an -ac 0 -ss $FEED_START -t $FEED_SEC $FIVESEC

echo "Done!!"
exit 0
