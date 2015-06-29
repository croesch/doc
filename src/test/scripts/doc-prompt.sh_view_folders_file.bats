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
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer-b/old
  touch $BATS_TMPDIR_STORAGE/alice/work/employer-b/file-1
  touch $BATS_TMPDIR_STORAGE/alice/work/employer-b/file-2
  touch $BATS_TMPDIR_STORAGE/alice/work/employer-b/file-3
  touch $BATS_TMPDIR_STORAGE/alice/work/employer-b/old/file-3

  DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
}

teardown() {
  rm -r $DOC_STORAGE_DIRECTORY
}

@test "should contain all files of current directory after 'view FOLDER...' and no characters are entered" {
  COMP_WORDS=( 'doc' 'view' 'alice' 'employer-b' '')
  COMP_CWORD=4
  _important_documents

  containsElement file-1 "${COMPREPLY[@]}"
  containsElement file-2 "${COMPREPLY[@]}"
  containsElement file-3 "${COMPREPLY[@]}"
}

@test "should contain unambiguous files of subdirectories after 'view FOLDER...' and no characters are entered" {
  COMP_WORDS=( 'doc' 'view' 'alice' '')
  COMP_CWORD=3
  _important_documents

  containsElement file-1 "${COMPREPLY[@]}"
  containsElement file-2 "${COMPREPLY[@]}"
}

@test "should not contain ambiguous files of subdirectories after 'view FOLDER...' and no characters are entered" {
  COMP_WORDS=( 'doc' 'view' 'alice' '')
  COMP_CWORD=3
  _important_documents

  notContainsElement file-3 "${COMPREPLY[@]}"
}
