#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <tag> <outdir>

Description:
    タグ<tag>のファイル群を、アーカイブファイルとして<outdir>ディレクトリへ出力する。出力ファイル名は<tag>.zipとなる。

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

readonly tagname=$1
readonly output_dir=$2

[ ! -e $output_dir ] && mkdir $output_dir
git archive $tagname -o $output_dir/$tagname.zip
