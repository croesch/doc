#!/usr/bin/env bats

load sut
load helper

@test "reply 'add' as second command after directory when no character is written" {
  COMP_WORDS=( 'doc' 'directory' '' )
  COMP_CWORD=2
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'add' as second command after directory when 'a' is written" {
  COMP_WORDS=( 'doc' 'directory' 'a' )
  COMP_CWORD=2
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'add' as second command after directory when 'ad' is written" {
  COMP_WORDS=( 'doc' 'directory' 'ad' )
  COMP_CWORD=2
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'add' as second command after directory when 'add' is written" {
  COMP_WORDS=( 'doc' 'directory' 'add' )
  COMP_CWORD=2
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}
