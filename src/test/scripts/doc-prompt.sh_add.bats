#!/usr/bin/env bats

load sut
load helper

@test "reply 'add' as first command when no character is written" {
  COMP_WORDS=( 'doc' '' )
  COMP_CWORD=1
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'add' as first command when 'a' is written" {
  COMP_WORDS=( 'doc' 'a' )
  COMP_CWORD=1
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'add' as first command when 'ad' is written" {
  COMP_WORDS=( 'doc' 'ad' )
  COMP_CWORD=1
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'add' as first command when 'add' is written" {
  COMP_WORDS=( 'doc' 'add' )
  COMP_CWORD=1
  _important_documents
  containsElement add "${COMPREPLY[@]}"
  [ $? ]
}
