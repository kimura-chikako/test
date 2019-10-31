#!/usr/bin/bash
#
# �����[�X�c�[���ݒ�
#

# �ǂݍ��ݎ��ʎq
readonly TMC_RELEASE_CONFIG='TMC_RELEASE_CONFIG'

# �����[�X�c�[���X�N���v�g���z�u����Ă���f�B���N�g��
readonly TOOL_DIR=$(realpath $(dirname $0))

# ���O�ݒ�
readonly LOG_DIR=$TOOL_DIR/log
readonly LOG_FILE=$LOG_DIR/`date "+%Y%m%d"`.log

# ���|�W�g���̃g�b�v�f�B���N�g��
readonly TOP_DIR=`git rev-parse --show-toplevel`
# �����[�X�ݒ�f�B���N�g��
readonly CONF_DIR=$TOP_DIR/release_conf
# �o���G�[�V�����̃^�O���X�g�z�u�f�B���N�g��
readonly TAGLIST_DIR=$CONF_DIR/taglist

# �t���A�[�J�C�u�t�@�C���̏o�͐�f�B���N�g��
readonly OUTDIR_FULL_ARCHIVES=$TOP_DIR/../archives
# �����A�[�J�C�u�̐ݒ�t�@�C��
readonly CONF_DIFF_ARCHIVES=$CONF_DIR/archive_diff.csv
# �����A�[�J�C�u�t�@�C���̏o�͐�f�B���N�g��
readonly OUTDIR_DIFF_ARCHIVES=$TOP_DIR/../archive_diffs
