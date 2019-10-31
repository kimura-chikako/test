#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
    $(basename $0) [-h] <directory> <tag>

Description:
    �w�肵���f�B���N�g��<directory>�z���Ɏw�肵���^�O<tag>���`�F�b�N�A�E�g����B

Options:
    -h: �w���v�\��
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

readonly output_dir=$1
readonly tagname=$2

# �^�O�̃R�~�b�g���e���`�F�b�N�A�E�g
git cherry-pick -n $2 | $LOG_CMD $LINENO
