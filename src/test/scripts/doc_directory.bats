#!/usr/bin/env bats

setup() {
  PATH="${BATS_TEST_DIRNAME}/../../main/scripts/:$PATH"

  BATS_TMPDIR_STORAGE="${BATS_TMPDIR}/storage"
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer

  export DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
}

teardown() {
  rm -fr $BATS_TMPDIR_STORAGE
}

@test "should do nothing when no argument is given" {
  run doc directory
  [ "$status" -eq 8 ]
  [ "$output" = "doc: Please give a valid command." ]
}
