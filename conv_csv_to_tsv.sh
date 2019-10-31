#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h]

Description:
    Excelで編集可能なcsvデータを標準入力より受け取り、タブ区切りデータに変換して表示する。

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
echo "Start:"  ${PROC_NAME} $@ >&2
echo "Start:"  ${PROC_NAME} $@ | $LOG_CMD $LINENO 

readonly diff_taglist=$CONF_DIFF_ARCHIVES

# - 改行文字変換 \r\n -> \n
# - 文字コード変換 SJIS -> UTF-8
# - ダブルクォーテーションで囲まれるた文字列を正しく処理する(gawk & tr)
# - 末尾のタブを削除
cat - | sed 's/\r//g' | \
    iconv -f SJIS -t UTF-8 | \
    gawk -v FPAT="([^,]*)|(\"[^\"]+\")" '{for(i=1;i<=NF;i++){printf "%s\t",$i};printf "\n"}' | \
    tr -d '"' | \
    sed 's/\t$//'
