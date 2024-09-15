_tests_helper() {
    export BATS_LIB_PATH=${BATS_LIB_PATH:-"/usr/lib"}
    echo $BATS_LIB_PATH
    bats_load_library bats-support
    bats_load_library bats-assert
    bats_load_library bats-file
    bats_load_library bats-detik/detik.bash
}

_create_dir_file() {
    run mkdir testing
    assert_success

    run touch testing/example
    assert_success
}

_delete_dir_file() {
    run rm testing/example
    assert_success

    run rmdir testing
    assert_success
}
