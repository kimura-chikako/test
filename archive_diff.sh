#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <tag1> <tag2> <outdir>

Description:
    タグ<tag1>から<tag2>間で差分のあるファイル群を、アーカイブファイルとして<outdir>ディレクトリへ出力する。出力ファイル名は<tag2>_diff.zipとなる。

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

unset workdir
onexit() {
  if [ -n ${workdir-} ]; then
    rm -rf "$workdir"
  fi
}
trap onexit EXIT

readonly tagname1=$1
readonly tagname2=$2
readonly outdir=`realpath $3`
readonly outfile="$outdir/${tagname2}_diff.zip"

workdir=$(mktemp --tmpdir -d tmc_release.XXXXXX)

[ ! -e $outdir ] && mkdir $outdir

if $TOOL_DIR/test_having_diff.sh $tagname1 $tagname2;
then
    # 引数長がMAX_ARGを超える可能性があるため、一時ディレクトリに展開して再zipする
    $TOOL_DIR/get_diff_list.sh $tagname1 $tagname2 | tr '\n' '\0' |
	xargs -0 git archive --format=tar $tagname2 -- | (cd $workdir && tar xf -)

    # git for windowsにzipコマンドがないため、git archiveで代用する
    pushd $workdir > /dev/null
    git init 2>&1 | $LOG_CMD $LINENO
    git add . 2>&1 | $LOG_CMD $LINENO
    git commit -m "commit for zip" 2>&1 | $LOG_CMD $LINENO
    popd > /dev/null

    git archive --format=zip -o "$outfile" --remote="$workdir" HEAD 2>&1 | $LOG_CMD $LINENO

    echo "Created $outfile."
    echo "Created $outfile." | $LOG_CMD $LINENO
else
    echo "There is no diff."
    echo "There is no diff." | $LOG_CMD $LINENO
fi
