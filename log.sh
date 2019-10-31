#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <PROCNAME> <LINENO>

Description:
    標準入力より受け取った文字列を、プロセス名<PROCNAME>および行番号<LINENO>と共にログファイル<LOG_FILE>へ出力する。

Options:
    -h: このヘルプを表示する
_EOT_
exit 1
}

while getopts h OPT
do
  case $OPT in
      "h" ) usage
	    ;;
  esac
done

shift `expr $OPTIND - 1`

readonly cmd_path=$(realpath $(dirname $0))
. $cmd_path/config.sh

readonly PROC_NAME=$1
shift
readonly LINE_NO=$1
shift

[ ! -e "$LOG_DIR" ] && mkdir -p $LOG_DIR

echo -n "$(date '+%Y-%m-%dT%H:%M:%S') [${PROC_NAME} ${LINE_NO}]: " >> $LOG_FILE
cat - >> $LOG_FILE
echo >> $LOG_FILE
