#!/usr/bin/env bats

load sut
load helper

# Create directory structure:
# family
#   +-house
#   +-bills
#   +-bank
#      +-bank-1
setup() {
  BATS_TMPDIR_STORAGE="${BATS_TMPDIR}/storage"
  BATS_TMPDIR_PWD="${BATS_TMPDIR}/pwd"
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer-b/old
  mkdir -p $BATS_TMPDIR_PWD/folder
  touch $BATS_TMPDIR_PWD/file-1
  touch $BATS_TMPDIR_PWD/file-2
  touch $BATS_TMPDIR_PWD/folder/file-3 

  DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
  COMP_WORDS=( 'doc' 'add' 'alice' 'employer-b' 'old' '')
  COMP_CWORD=5

}

teardown() {
  rm -r $DOC_STORAGE_DIRECTORY
  rm -r $BATS_TMPDIR_PWD
}

@test "should contain all files of current directory after 'add FOLDER...' and no characters are entered" {
  cd $BATS_TMPDIR_PWD
  _important_documents

  containsElement file-1 "${COMPREPLY[@]}"
  containsElement file-2 "${COMPREPLY[@]}"
  containsElement folder/file-3 "${COMPREPLY[@]}"
}
