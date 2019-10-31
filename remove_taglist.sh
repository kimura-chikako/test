#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h]

Description:
    リリース設定ディレクトリ<CONF_DIR>を削除する。

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
echo "Start:"  ${PROC_NAME} $@ | $LOG_CMD $LINENO

# 削除対象が存在しない場合でもエラーにならずに続行させるため--ignore-unmatchを指定
git rm -r --ignore-unmatch $CONF_DIR | $LOG_CMD $LINENO
# git rmのみでは空のディレクトリが残ってしまうため、管理対象から外れたファイル、ディレクトリを明示的に削除する
git clean -df | $LOG_CMD $LINENO
