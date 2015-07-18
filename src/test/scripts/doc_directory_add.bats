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

@test "should do nothing when DOC_STORAGE_DIRECTORY is unset" {
  unset DOC_STORAGE_DIRECTORY
  run doc directory add dir
  [ "$status" -eq 5 ]
  [ "$output" = "doc: 'DOC_STORAGE_DIRECTORY' unset. Use 'doc init FOLDER' first." ]
}

@test "should do nothing when folder is existent in root (and no path given)" {
  run doc directory add alice
  [ "$status" -eq 7 ]
  [ "$output" = "doc: 'alice' already exists." ]
}

@test "should do nothing when folder is existent in parent" {
  run doc directory add alice work
  [ "$status" -eq 7 ]
  [ "$output" = "doc: 'work' already exists." ]
}

@test "should do nothing when no argument is given" {
  run doc directory add
  [ "$status" -eq 6 ]
  [ "$output" = "doc: Please give a directory name." ]
}

@test "should create directory if it not exists (and no path given)." {
  run doc directory add bob
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'bob'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/bob" ]
}

@test "should create directory even if it exists in subfolder (and no path given)." {
  [ -d "$DOC_STORAGE_DIRECTORY/alice/work" ]
  run doc directory add work
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'work'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/work" ]
}

@test "should create directory if it not exists." {
  run doc directory add alice bob
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'alice/bob'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/alice/bob" ]
}

@test "should create directory even if it exists in subfolder." {
  [ -d "$DOC_STORAGE_DIRECTORY/alice/work/employer" ]
  run doc directory add alice employer
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'alice/employer'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/alice/employer" ]
}

@test "should work with path as list." {
  [ ! -d "$DOC_STORAGE_DIRECTORY/alice/work/bob" ]
  run doc directory add alice work bob
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'alice/work/bob'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/alice/work/bob" ]
}

@test "should work with unambiguous path as list." {
  [ ! -d "$DOC_STORAGE_DIRECTORY/alice/work/employer/bob" ]
  run doc directory add alice employer bob
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'alice/work/employer/bob'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/alice/work/employer/bob" ]
}

@test "should work with unambiguous directories." {
  [ ! -d "$DOC_STORAGE_DIRECTORY/alice/work/bob" ]
  run doc directory add work bob
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully created directory 'alice/work/bob'." ]
  [ -d "$DOC_STORAGE_DIRECTORY/alice/work/bob" ]
}
