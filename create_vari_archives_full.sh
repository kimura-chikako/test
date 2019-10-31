#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <tag>

Description:
     <TAGLIST_DIR>ディレクトリ配下のタグリスト(バリエーション名.csv)をスキャンし、バリエーションタグ('バリエーション名'_<tag>)のフルアーカイブファイルを作成する。アーカイブファイルは<OUTDIR_FULL_ARCHIVES>ディレクトリに出力される。出力ファイル名は'タグリスト名'_<tag>.zipとなる。

Options:
    -h: ヘルプ表示
_EOT_
exit 1
}

while getopts h OPT
do
  case $OPT in
      "h" ) usage
  esac
done

shift `expr $OPTIND - 1`

readonly cmd_path=$(realpath $(dirname $0))
. $cmd_path/config.sh

readonly PROC_NAME=${0##*/}
readonly LOG_CMD="$TOOL_DIR/log.sh ${PROC_NAME}"
echo "Start:"  ${PROC_NAME} $@
echo "Start:"  ${PROC_NAME} $@ | $LOG_CMD $LINENO 

readonly tag_name=$1
readonly taglist_dir=$TAGLIST_DIR
readonly outdir=$OUTDIR_FULL_ARCHIVES

rm -rf $outdir
for i in ${taglist_dir}/*.csv
do
    vari_branch=`basename ${i%.csv}`
    vari_tag_name=${vari_branch}_${tag_name}
    $TOOL_DIR/archive_full.sh $vari_tag_name $outdir
done
