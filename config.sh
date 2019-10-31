#!/usr/bin/bash
#
# リリースツール設定
#

# 読み込み識別子
readonly TMC_RELEASE_CONFIG='TMC_RELEASE_CONFIG'

# リリースツールスクリプトが配置されているディレクトリ
readonly TOOL_DIR=$(realpath $(dirname $0))

# ログ設定
readonly LOG_DIR=$TOOL_DIR/log
readonly LOG_FILE=$LOG_DIR/`date "+%Y%m%d"`.log

# リポジトリのトップディレクトリ
readonly TOP_DIR=`git rev-parse --show-toplevel`
# リリース設定ディレクトリ
readonly CONF_DIR=$TOP_DIR/release_conf
# バリエーションのタグリスト配置ディレクトリ
readonly TAGLIST_DIR=$CONF_DIR/taglist

# フルアーカイブファイルの出力先ディレクトリ
readonly OUTDIR_FULL_ARCHIVES=$TOP_DIR/../archives
# 差分アーカイブの設定ファイル
readonly CONF_DIFF_ARCHIVES=$CONF_DIR/archive_diff.csv
# 差分アーカイブファイルの出力先ディレクトリ
readonly OUTDIR_DIFF_ARCHIVES=$TOP_DIR/../archive_diffs
