#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <tag1> <tag2>

Description:
    指定されたタグ間(<tag1>,<tag2>)に差分が存在するかチェックする。

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

readonly tagname1=$1
readonly tagname2=$2

test $($cmd_path/get_diff_list.sh $tagname1 $tagname2 | wc -l) -ne 0
