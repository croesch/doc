#!/usr/bin/env bats

setup() {
  PATH="${BATS_TEST_DIRNAME}/../../main/scripts/:$PATH"

  BATS_TMPDIR_STORAGE="${BATS_TMPDIR}/storage"
  mkdir -p $BATS_TMPDIR_STORAGE/alice/work/employer

  export DOC_STORAGE_DIRECTORY=$BATS_TMPDIR_STORAGE
  
  BATS_TMPDIR_PWD="${BATS_TMPDIR}/pwd"
  mkdir -p $BATS_TMPDIR_PWD/folder
  echo "File 1" > $BATS_TMPDIR_PWD/file
  echo "File 2" > $BATS_TMPDIR_PWD/folder/file-2

  BATS_GITDIR="${BATS_TMPDIR}/git"
  mkdir -p $BATS_GITDIR

  cd $BATS_TMPDIR_PWD
}

teardown() {
  rm -fr $BATS_TMPDIR_PWD
  rm -fr $BATS_TMPDIR_STORAGE
  rm -fr $BATS_GITDIR
}

function uncommitted_files {
  expr `git status --porcelain 2>/dev/null | wc -l`;
}

@test "should do nothing when DOC_STORAGE_DIRECTORY is unset" {
  unset DOC_STORAGE_DIRECTORY
  run doc add file
  [ "$status" -eq 5 ]
  [ "$output" = "doc: 'DOC_STORAGE_DIRECTORY' unset. Use 'doc init FOLDER' first." ]
}

@test "should do nothing when only argument is not a file" {
  run doc add nofile
  [ "$status" -eq 10 ]
  [ "$output" = "doc: 'nofile' not found." ]
}

@test "should do nothing when last argument is not a file" {
  run doc add alice nofile
  [ "$status" -eq 10 ]
  [ "$output" = "doc: 'nofile' not found." ]
}

@test "should do nothing when no argument is given" {
  run doc add
  [ "$status" -eq 9 ]
  [ "$output" = "doc: Please give a file to add." ]
}

@test "should not use subdirectories in new file name." {
  [ -f "$BATS_TMPDIR_PWD/folder/file-2" ]

  run doc add folder/file-2
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'folder/file-2'." ]

  [ -f "$DOC_STORAGE_DIRECTORY/file-2.gpg" ]
  [ ! -f "$DOC_STORAGE_DIRECTORY/folder/file-2.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/folder/file-2" ]
}

@test "should add encrypted file and remove source if it not exists (and no path given)." {
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}

@test "should commit the files." {
  pushd $DOC_STORAGE_DIRECTORY
  git init
  git remote add origin "file://$BATS_GITDIR/"
  touch "$DOC_STORAGE_DIRECTORY/first-file"
  [ "$(uncommitted_files)" != "0" ]
  popd
  pushd $BATS_GITDIR
  git init --bare
  popd
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add file
  [ "$status" -eq 0 ]

  pushd $DOC_STORAGE_DIRECTORY
  [ "$(uncommitted_files)" == "0" ]
  popd
}

@test "should create file even if it exists in subfolder (and no path given)." {
  touch "$DOC_STORAGE_DIRECTORY/alice/file.gpg"
  [ -f "$DOC_STORAGE_DIRECTORY/alice/file.gpg" ]
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}

@test "should add encrypted file and remove source if it not exists." {
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add alice file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/alice/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}

@test "should create file even if it exists in subfolder." {
  touch "$DOC_STORAGE_DIRECTORY/alice/work/file.gpg"
  [ -f "$DOC_STORAGE_DIRECTORY/alice/work/file.gpg" ]
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add alice file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/alice/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}

@test "should work with path as list." {
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add alice work file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/alice/work/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}

@test "should work with unambiguous path as list." {
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add alice employer file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/alice/work/employer/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}

@test "should work with unambiguous directories." {
  [ -f "$BATS_TMPDIR_PWD/file" ]

  run doc add employer file
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully added 'file'." ]
  
  # TODO verify gpg file
  [ -f "$DOC_STORAGE_DIRECTORY/alice/work/employer/file.gpg" ]
  [ ! -f "$BATS_TMPDIR_PWD/file" ]
}
