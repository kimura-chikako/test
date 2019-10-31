#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h]

Description:
    設定ファイル<CONF_DIFF_ARCHIVES>に指定されたタグ間の差分アーカイブファイル作成する。設定ファイルには、差分をとるタグ名のペアを列挙していく。Excelで編集するため文字コードはSJISとする。

    更新前タグ名, 更新後タグ名
    ...

    アーカイブファイルは<OUTDIR_DIFF_ARCHIVES>ディレクトリに出力される。指定されたタグ間で差分が存在しない場合は、アーカイブファイルは作成されない。出力ファイル名は<更新後タグ名>_diff.zipとなる。

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

readonly diff_taglist=$CONF_DIFF_ARCHIVES
readonly outdir=$OUTDIR_DIFF_ARCHIVES

rm -rf $outdir

cat $diff_taglist | \
    $TOOL_DIR/conv_csv_to_tsv.sh | \
    while read i1 i2
    do
	$TOOL_DIR/archive_diff.sh $i1 $i2 $outdir
    done
