#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <taglist>

Description:
    タグリスト<taglist>をスキャンし、アプリディレクトリ配下に対応するタグをチェックアウトする。タグリストには、アプリディレクトリ名とタグ名のペアを列挙していく。Excelで編集するため文字コードはSJISとする。
　　　なお、タグリスト内の空行は無視する。

    アプリディレクトリ名, タグ名
    ...

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

readonly taglist=$1

cat $taglist | \
    $TOOL_DIR/conv_csv_to_tsv.sh | \
    while read i1 i2
    do
	# CSVファイル内の1列目と2列目両方に文字列が記入されていたらチェックアウト実施
	if [ -n "$i1" -a -n "$i2"  ]
	then
		$TOOL_DIR/partial_checkout.sh $i1 $i2
	fi
    done
