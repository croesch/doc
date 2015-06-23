#!/usr/bin/env bats

load sut
load helper

@test "reply 'view' as first command when no character is written" {
  COMP_WORDS=( 'doc' '' )
  COMP_CWORD=1
  _important_documents
  containsElement view "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'view' as first command when 'v' is written" {
  COMP_WORDS=( 'doc' 'v' )
  COMP_CWORD=1
  _important_documents
  containsElement view "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'view' as first command when 'vi' is written" {
  COMP_WORDS=( 'doc' 'vi' )
  COMP_CWORD=1
  _important_documents
  containsElement view "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'view' as first command when 'vie' is written" {
  COMP_WORDS=( 'doc' 'vie' )
  COMP_CWORD=1
  _important_documents
  containsElement view "${COMPREPLY[@]}"
  [ $? ]
}

@test "reply 'view' as first command when 'view' is written" {
  COMP_WORDS=( 'doc' 'view' )
  COMP_CWORD=1
  _important_documents
  containsElement view "${COMPREPLY[@]}"
  [ $? ]
}
