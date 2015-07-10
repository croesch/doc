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
  mkdir -p $BATS_TMPDIR_PWD/folder/dir1/child
  mkdir -p $BATS_TMPDIR_PWD/folder/dir2/child
  mkdir -p $BATS_TMPDIR_PWD/folder/dir3/kind
  mkdir -p $BATS_TMPDIR_PWD/folder/dir4
  touch $BATS_TMPDIR_PWD/file-1
  touch $BATS_TMPDIR_PWD/file-2
  touch $BATS_TMPDIR_PWD/folder/file-3 

  DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
  COMP_WORDS=( 'doc' 'init' 'folder' '')
  COMP_CWORD=4

  cd $BATS_TMPDIR_PWD
}

teardown() {
  rm -r $DOC_STORAGE_DIRECTORY
  rm -r $BATS_TMPDIR_PWD
}

@test "should contain all folders of current directory after 'init FOLDER' and no characters are entered" {
  _important_documents

  containsElement dir1 "${COMPREPLY[@]}"
  containsElement dir2 "${COMPREPLY[@]}"
  containsElement dir3 "${COMPREPLY[@]}"
  containsElement dir4 "${COMPREPLY[@]}"
}

@test "should not contain itself" {
  _important_documents

  notContainsElement folder "${COMPREPLY[@]}"
}

@test "should contain all unambiguous subfolders of current directory after 'init FOLDER' and no characters are entered" {
  _important_documents

  containsElement kind "${COMPREPLY[@]}"
}

@test "should not contain ambiguous subfolders of current directory after 'init FOLDER' and no characters are entered" {
  _important_documents

  notContainsElement child "${COMPREPLY[@]}"
}

@test "should not contain any files of current directory after 'init FOLDER' and no characters are entered" {
  _important_documents

  notContainsElement file-3 "${COMPREPLY[@]}"
}
