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
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer-b/old
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/car
  mkdir -p $BATS_TMPDIR_STORAGE/alice/bank/bank-1/old

  DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
  COMP_WORDS=( 'doc' 'add' 'alice' '' )
  COMP_CWORD=3
}

teardown() {
  rm -r $DOC_STORAGE_DIRECTORY
}

@test "should contain all folders of FOLDER when no characters are entered after 'add FOLDER'" {
  _important_documents

  containsElement work "${COMPREPLY[@]}"
  containsElement bank "${COMPREPLY[@]}"
}

@test "should contain all unambiguous folders of FOLDER when no characters are entered after 'add FOLDER'" {
  _important_documents
  
  containsElement current-employer "${COMPREPLY[@]}"
  containsElement employer-a "${COMPREPLY[@]}"
  containsElement employer-b "${COMPREPLY[@]}"
  containsElement car "${COMPREPLY[@]}"
  containsElement bank-1 "${COMPREPLY[@]}"
}

@test "should not contain all ambiguous folders of FOLDER when no characters are entered after 'add FOLDER'" {
  _important_documents

  notContainsElement old "${COMPREPLY[@]}"
}

@test "should not contain itself when no characters are entered after 'add FOLDER'" {
  _important_documents

  notContainsElement alice "${COMPREPLY[@]}"
}

@test "should contain all elements with e* when 'e' is entered after 'add FOLDER'" {
  COMP_WORDS[3]='e'
  _important_documents

  containsElement employer-a "${COMPREPLY[@]}"
  containsElement employer-b "${COMPREPLY[@]}"
}

@test "should not contain all elements with e* when 'b' is entered after 'add FOLDER'" {
  COMP_WORDS[3]='b'
  _important_documents

  notContainsElement employer-a "${COMPREPLY[@]}"
  notContainsElement employer-b "${COMPREPLY[@]}"
}

@test "should not contain itself when no characters are entered after 'add FOLDER1 FOLDER2' and FOLDER1 is not direct parent of FOLDER2" {
  COMP_WORDS=( 'doc' 'add' 'alice' 'employer-b' '' )
  COMP_CWORD=4
  _important_documents

  notContainsElement employer-b "${COMPREPLY[@]}"
}

@test "should contain all elements of folder when no characters are entered after 'add FOLDER1 FOLDER2' and FOLDER1 is not direct parent of FOLDER2" {
  COMP_WORDS=( 'doc' 'add' 'alice' 'employer-b' '' )
  COMP_CWORD=4
  _important_documents

  containsElement old "${COMPREPLY[@]}"
}

@test "should contain all elements of folder when no characters are entered after 'add FOLDER1 FOLDER2' and FOLDER1 is direct parent of FOLDER2" {
  COMP_WORDS=( 'doc' 'add' 'alice' 'bank' '' )
  COMP_CWORD=4
  _important_documents

  containsElement bank-1 "${COMPREPLY[@]}"
  containsElement old "${COMPREPLY[@]}"
}

@test "should not contain all elements of sibling folder when no characters are entered after 'add FOLDER1 FOLDER2'" {
  COMP_WORDS=( 'doc' 'add' 'alice' 'bank' '' )
  COMP_CWORD=4
  _important_documents

  notContainsElement work "${COMPREPLY[@]}"
  notContainsElement current-employer "${COMPREPLY[@]}"
  notContainsElement employer-a "${COMPREPLY[@]}"
  notContainsElement employer-b "${COMPREPLY[@]}"
  notContainsElement car "${COMPREPLY[@]}"
}
