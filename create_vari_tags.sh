#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
   $(basename $0) [-h] <tag>

Description:
   <TAGLIST_DIR>配下のタグリスト(バリエーション名.csv)をスキャンし、各タグリストで指定された状態でバリエーションタグ('バリエーション名_<tag>')を作成する。非公開ディレクトリ(_private_/)およびリリース設定ディレクトリ<CONF_DIR>は除去される。

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
readonly curr_branch=`git branch | awk '/\*/ {print $2;}'`

for i in ${taglist_dir}/*.csv
do
    vari_branch=`basename ${i%.csv}`
    vari_tag_name=${vari_branch}_${tag_name}
    # 作業ブランチ作成
    git checkout -B $vari_branch 2>&1 | $LOG_CMD $LINENO
    # ブランチ配下の機能フォルダに対し、一旦削除してから最新のreleaseブランチの内容をチェックアウト
    cat $i | \
    $TOOL_DIR/conv_csv_to_tsv.sh | \
    while read i1 i2
    do
    # CSVファイル内の1列目と2列目両方に文字列が記入されていたら削除＆チェックアウト
    if [ -n "$i1" -a -n "$i2"  ]
    then
        git rm -r --ignore-unmatch $i1 | $LOG_CMD $LINENO
        git checkout release -- $i1 | $LOG_CMD $LINENO
    fi
    done
    # タグリスト反映
    $TOOL_DIR/create_vari_fileset.sh $i
    # 不要ファイルを削除
    $TOOL_DIR/remove_private.sh
    $TOOL_DIR/remove_taglist.sh
    # コミット
    git commit -a -m $vari_tag_name 2>&1 | $LOG_CMD $LINENO
    # タグ作成
    git tag -a $vari_tag_name -m $vari_tag_name 2>&1 | $LOG_CMD $LINENO
    # 元のブランチへ戻る
    git checkout $curr_branch 2>&1 | $LOG_CMD $LINENO
    # 作業ブランチ削除
    git branch -D $vari_branch 2>&1 | $LOG_CMD $LINENO
done

