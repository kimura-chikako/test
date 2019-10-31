#!/usr/bin/bash

set -eu

function usage() {
cat <<_EOT_
Usage:
   $(basename $0) [-h] <tag>

Description:
   <TAGLIST_DIR>�z���̃^�O���X�g(�o���G�[�V������.csv)���X�L�������A�e�^�O���X�g�Ŏw�肳�ꂽ��ԂŃo���G�[�V�����^�O('�o���G�[�V������_<tag>')���쐬����B����J�f�B���N�g��(_private_/)����у����[�X�ݒ�f�B���N�g��<CONF_DIR>�͏��������B

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

readonly tag_name=$1
readonly taglist_dir=$TAGLIST_DIR
readonly curr_branch=`git branch | awk '/\*/ {print $2;}'`

for i in ${taglist_dir}/*.csv
do
    vari_branch=`basename ${i%.csv}`
    vari_tag_name=${vari_branch}_${tag_name}
    # ��ƃu�����`�쐬
    git checkout -B $vari_branch 2>&1 | $LOG_CMD $LINENO
    # �u�����`�z���̋@�\�t�H���_�ɑ΂��A��U�폜���Ă���ŐV��release�u�����`�̓��e���`�F�b�N�A�E�g
    cat $i | \
    $TOOL_DIR/conv_csv_to_tsv.sh | \
    while read i1 i2
    do
    # CSV�t�@�C������1��ڂ�2��ڗ����ɕ����񂪋L������Ă�����폜���`�F�b�N�A�E�g
    if [ -n "$i1" -a -n "$i2"  ]
    then
        git rm -r --ignore-unmatch $i1 | $LOG_CMD $LINENO
        git checkout release -- $i1 | $LOG_CMD $LINENO
    fi
    done
    # �^�O���X�g���f
    $TOOL_DIR/create_vari_fileset.sh $i
    # �s�v�t�@�C�����폜
    $TOOL_DIR/remove_private.sh
    $TOOL_DIR/remove_taglist.sh
    # �R�~�b�g
    git commit -a -m $vari_tag_name 2>&1 | $LOG_CMD $LINENO
    # �^�O�쐬
    git tag -a $vari_tag_name -m $vari_tag_name 2>&1 | $LOG_CMD $LINENO
    # ���̃u�����`�֖߂�
    git checkout $curr_branch 2>&1 | $LOG_CMD $LINENO
    # ��ƃu�����`�폜
    git branch -D $vari_branch 2>&1 | $LOG_CMD $LINENO
done

