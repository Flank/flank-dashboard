#!/usr/bin/env groovy

boolean call(List changedList, String buildableProject){
  boolean found = false
  changedList.find{
    def pattern = "^metrics\\/$buildableProject\\/.*"
    if (it.matches(pattern)){
      found = true
    }
  }
  return found
}