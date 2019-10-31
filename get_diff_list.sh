#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <tag1> <tag2>

Description:
    指定されたタグ間(<tag1>と<tag2>)で差分が生じたファイルをリスト表示する。ただし、非公開ディレクトリ(_private_/)およびリリース設定ディレクトリ<CONF_DIR>配下の変更は無視する。

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

readonly tagname1=$1
readonly tagname2=$2

git diff --name-only --diff-filter=d $tagname1 $tagname2 -- ":(exclude)_private_" ":(exclude)**/_private_/*" ":(exclude)release_conf/"
