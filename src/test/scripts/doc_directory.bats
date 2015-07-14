#!/usr/bin/env bats

setup() {
  PATH="${BATS_TEST_DIRNAME}/../../main/scripts/:$PATH"

  BATS_TMPDIR_STORAGE="${BATS_TMPDIR}/storage"
  BATS_TMPDIR_PWD="${BATS_TMPDIR}/pwd"
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer

  DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
}

teardown() {
  rm -fr $BATS_TMPDIR_STORAGE
  rm -fr $BATS_TMPDIR_PWD
}

@test "should do nothing when no argument is given" {
  run doc directory
  [ "$status" -eq 8 ]
  [ "$output" = "doc: Please give a valid command." ]
}
