setup() {
    load 'tests_helper'
    _tests_helper
}

#bats test_tags=github:true
@test "0: Pre: Create file and dir" {
  _create_dir_file
  _delete_dir_file
}

#bats test_tags=github:true
@test "1: Testing file existence" {
  _create_dir_file

  run ls testing/example
  assert_success
  run [ -f "testing/example" ]
  assert_success

  _delete_dir_file
}

#bats test_tags=github:true
@test "2: Testing file permissions" {
  _create_dir_file
  if [[ "$(uname)" == "Darwin" ]]; then
    run stat -f%p testing/example
  else
    run stat -c "%a" testing/example
  fi
  assert_success
  if [[ "$(uname)" == "Darwin" ]]; then
    assert_output 100644
  else
    assert_output 644
  fi
  assert_file_permission 644 testing/example
  assert_success

  _delete_dir_file
}

#bats test_tags=github:true
@test "3: Testing file content" {
  _create_dir_file

  run cat testing/example
  assert_success
  refute_output "Expected content"
  assert_file_empty testing/example
  assert_success

  _delete_dir_file
}

#bats test_tags=github:true
@test "4: Testing directory creation" {
  _create_dir_file

  run mkdir testing/newdir
  assert_success

  [ -d "testing/newdir" ]
  assert_success

  run rmdir testing/newdir
  assert_success

  _delete_dir_file
}

#bats test_tags=github:true
@test "5: Testing file creation and deletion inside directory" {
  _create_dir_file

  run mkdir testing/newdir
  assert_success

  run touch testing/newdir/newfile
  assert_success

  run [ -f "testing/newdir/newfile" ]
  assert_success

  run rm testing/newdir/newfile
  assert_success

  [ ! -f "testing/newdir/newfile" ]
  assert_success

  run rmdir testing/newdir
  assert_success

  run [ ! -d "testing/newdir" ]
  assert_success

  _delete_dir_file
}
