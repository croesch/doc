#!/usr/bin/env bats

setup() {
  PATH="${BATS_TEST_DIRNAME}/../../main/scripts/:$PATH"

  BATS_TMPDIR_PWD="${BATS_TMPDIR}/pwd"
  mkdir -p $BATS_TMPDIR_PWD/folder/dir1/child
  touch $BATS_TMPDIR_PWD/folder/file-3

  sed --follow-symlinks -i -e "s|^export DOC_STORAGE_DIRECTORY=|#export DOC_STORAGE_DIRECTORY=|g" "${HOME}/.bashrc" 2>&1 > /dev/null

  cd $BATS_TMPDIR_PWD
}

teardown() {
  rm -fr $BATS_TMPDIR_PWD

  sed --follow-symlinks -i "/^export DOC_STORAGE_DIRECTORY=/d" "${HOME}/.bashrc" 2>&1 > /dev/null
  sed --follow-symlinks -i -e "s|^#export DOC_STORAGE_DIRECTORY=|export DOC_STORAGE_DIRECTORY=|g" "${HOME}/.bashrc" 2>&1 > /dev/null
}

@test "should do nothing when folder is not existent" {
  run doc init non-existent
  [ "$status" -eq 1 ]
  [ "$output" = "doc: 'non-existent' is not a directory." ]
}

@test "should do nothing when folder is not empty" {
  run doc init .
  [ "$status" -eq 2 ]
  [ "$output" = "doc: Directory not empty '${BATS_TMPDIR_PWD}/.'." ]
}

@test "should do nothing when no argument is given" {
  run doc init
  [ "$status" -eq 4 ]
  [ "$output" = "doc: Please give a directory." ]
}

@test "should commit all files if directory contains git directory." {
  git init 2>&1 > /dev/null
  touch aaa 2>&1 > /dev/null
  git add aaa 2>&1 > /dev/null
  git commit -m "Initial." 2>&1 > /dev/null

  run doc init .
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully used repo at '${BATS_TMPDIR_PWD}/.'." ]
  run git status --porcelain
  [ "$output" = "" ]
}

@test "should create git repository when directory is empty." {
  run doc init folder/dir1/child
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully initialised repo at '${BATS_TMPDIR_PWD}/folder/dir1/child'." ]

  cd folder/dir1/child
  run git status --porcelain
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "should work with path as list." {
  run doc init folder dir1 child
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully initialised repo at '${BATS_TMPDIR_PWD}/folder/dir1/child'." ]

  cd folder/dir1/child
  run git status --porcelain
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "should work with unambiguous path as list." {
  run doc init folder child
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully initialised repo at '${BATS_TMPDIR_PWD}/folder/dir1/child'." ]

  cd folder/dir1/child
  run git status --porcelain
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "should work with unambiguous directories." {
  run doc init child
  [ "$status" -eq 0 ]
  [ "$output" = "doc: Successfully initialised repo at '${BATS_TMPDIR_PWD}/folder/dir1/child'." ]

  cd folder/dir1/child
  run git status --porcelain
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "should insert environment variable if repository exists." {
  git init 2>&1 > /dev/null
  touch aaa 2>&1 > /dev/null
  git add aaa 2>&1 > /dev/null
  git commit -m "Initial." 2>&1 > /dev/null

  run doc init .
  [ "$status" -eq 0 ]
  run grep "^export DOC_STORAGE_DIRECTORY=" "${HOME}/.bashrc"
  [ "$output" = "export DOC_STORAGE_DIRECTORY=\"${BATS_TMPDIR_PWD}/.\"" ]
}

@test "should insert environment variable if repository is created." {
  run doc init folder/dir1/child
  [ "$status" -eq 0 ]

  run grep "^export DOC_STORAGE_DIRECTORY=" "${HOME}/.bashrc"
  [ "$output" = "export DOC_STORAGE_DIRECTORY=\"${BATS_TMPDIR_PWD}/folder/dir1/child\"" ]
}

@test "should update environment variable if exists." {
  echo "export DOC_STORAGE_DIRECTORY=\"blabla\"" >> "${HOME}/.bashrc"

  run doc init folder/dir1/child
  [ "$status" -eq 0 ]

  run grep "^export DOC_STORAGE_DIRECTORY=" "${HOME}/.bashrc"
  [ "$output" = "export DOC_STORAGE_DIRECTORY=\"${BATS_TMPDIR_PWD}/folder/dir1/child\"" ]
}
