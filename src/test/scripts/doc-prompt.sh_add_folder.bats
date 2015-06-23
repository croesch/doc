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
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/current-employer
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer-a
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer-b
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/car
  mkdir -p $BATS_TMPDIR_STORAGE/car
  mkdir -p $BATS_TMPDIR_STORAGE/alice/bank/bank-1
  mkdir -p $BATS_TMPDIR_STORAGE/bob/work/employer-b
  mkdir -p $BATS_TMPDIR_STORAGE/bob/work/employer-c
  mkdir -p $BATS_TMPDIR_STORAGE/bob/ship
  mkdir -p $BATS_TMPDIR_STORAGE/bob/bank/bank-1
  mkdir -p $BATS_TMPDIR_STORAGE/bob/bank/bank-2
  mkdir -p $BATS_TMPDIR_STORAGE/family/house
  mkdir -p $BATS_TMPDIR_STORAGE/family/bills
  mkdir -p $BATS_TMPDIR_STORAGE/family/bank/bank-1

  DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
  COMP_WORDS=( 'doc' 'add' '' )
  COMP_CWORD=2
}

teardown() {
  rm -r $DOC_STORAGE_DIRECTORY
}

@test "should contain all folders of DOC_STORAGE_DIRECTORY when no characters are entered after add" {
  _important_documents

  containsElement alice "${COMPREPLY[@]}"
  containsElement bob "${COMPREPLY[@]}"
  containsElement family "${COMPREPLY[@]}"
  # should contain car as it's a directory in the folder - even if it is ambiguous
  containsElement car "${COMPREPLY[@]}"
}

@test "should contain all unambiguous folders of DOC_STORAGE_DIRECTORY when no characters are entered after add" {
  _important_documents
  
  containsElement current-employer "${COMPREPLY[@]}"
  containsElement employer-a "${COMPREPLY[@]}"
  containsElement employer-c "${COMPREPLY[@]}"
  containsElement ship "${COMPREPLY[@]}"
  containsElement bank-2 "${COMPREPLY[@]}"
  containsElement house "${COMPREPLY[@]}"
  containsElement bills "${COMPREPLY[@]}"
}

@test "should not contain all ambiguous folders of DOC_STORAGE_DIRECTORY when no characters are entered after add" {
  _important_documents

  notContainsElement work "${COMPREPLY[@]}"
  notContainsElement employer-b "${COMPREPLY[@]}"
  notContainsElement bank-1 "${COMPREPLY[@]}"
}
