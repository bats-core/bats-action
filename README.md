# Setup Bats and Bats libraries

This GitHub Action installs [Bats](https://github.com/bats-core/bats-core) and the four major bats libraries:

* [bats-support](https://github.com/bats-core/bats-support)
* [bats-assert](https://github.com/bats-core/bats-assert)
* [bats-detik](https://github.com/bats-core/bats-detik)
* [bats-file](https://github.com/bats-core/bats-file)

The action can be also instructed to select which libraries to install.
While Linux is fully supported, windows and macos runners should work as well.

## How to use it

``` yaml
on: [push]

jobs:
   my_test:
     runs-on: ubuntu-latest
     name: Install Bats and bats libs
     steps:
       - name: Checkout
         uses: actions/checkout@v2
       - name: Setup Bats and bats libs
         id: setup-bats
         uses: bats-core/bats-action@2.0.0
       - name: My test
         shell: bash
         env:
          BATS_LIB_PATH: ${{ steps.setup-bats.outputs.lib-path }}
          TERM: xterm
         run: bats test/my-test
```

By default the action will pass the `BATS_LIB_PATH` value as output `lib-path`.
You can use it like the below example and load the libraries in your tests with:

``bash
_tests_helper() {
    export BATS_LIB_PATH=${BATS_LIB_PATH:-"/usr/lib"}
    bats_load_library bats-support
    bats_load_library bats-assert
    bats_load_library bats-file
    bats_load_library bats-detik/detik.bash
}
```

## Libraries Path

For each of the Bats libraries, you can choose to install them in the default location (`/usr/lib/bats-<lib-name>`) or specify a custom path.

For example, if you want to install `bats-support` in the `./test/bats-support` directory, you can configure it as follows:


``` yaml
      [...]
       - name: Setup Bats and Bats libs
         id: setup-bats
         uses: bats-core/bats-action@2.0.0
         with:
           support-path: ${{ github.workspace }}/test/bats-support
      [...]
```

## About Caching

The caching mechanism for the `bats binary` is always available. However, the caching for the `bats libraries` is dependent on the location of each library path. If a library is located within the $HOME directory, caching is supported. Conversely, if a library is located outside the $HOME directory (which is the default location per each library), caching is not supported. This is due to a known limitation with sudo and the cache action, as detailed in this GitHub issue: https://github.com/actions/toolkit/issues/946.
**If you want to cache the libraries you must install them inside HOME directory**
For instance:

```yaml
      [...]
       - name: Setup Bats and bats libs
         id: setup-bats
         uses: bats-core/bats-action@2.0.0
         with:
           support-path: "${{ github.workspace }}/tests/bats-support"
           assert-path: "${{ github.workspace }}/tests/bats-assert"
           detik-path: "${{ github.workspace }}/tests/bats-detik"
           file-path: "${{ github.workspace }}/tests/bats-file"
      [...]
```

## Inputs

| Key              | Default | Required | Description                                    |
|------------------|---------|----------|------------------------------------------------|
| bats-install     | `true`    | false    | Bats installation, cache supported              |
| bats-version     | `latest`  | false    | Bats version   |
| support-install  | `true`    | false    | Bats-support installation      |
| support-version  | `0.3.0`   | false    | Bats-support version       |
| support-path     | `/usr/lib/bats-support` | false | Bats-support path |
| support-clean    | `true`    | false    | Bats-support: clean temp files                  |
| assert-install   | `true`    | false    | Bats-assert installation      |
| assert-version   | `2.1.0`   | false    | Bats-assert version         |
| assert-path      | `/usr/lib/bats-assert` | false | Bats-assert path |
| assert-clean     | `true`    | false    | Bats-assert: clean temp files                   |
| detik-install    | `true`   | false    | Bats-detik installation        |
| detik-version    | `1.3.0`   | false    | Bats-detik version        |
| detik-path       | `/usr/lib/bats-detik` | false | Bats-detik path |
| detik-clean      | `true`    | false    | Bats-detik: clean temp files                    |
| file-install     | `true`    | false    | Bats-file installation     |
| file-version     | `0.4.0`   | false    | Bats-file version            |
| file-path        | `/usr/lib/bats-file` | false | Bats-file path   |
| file-clean       | `true`    | false    | Bats-file: clean temp files                     |

## Outputs

| Key              | Description                                    |
|------------------|------------------------------------------------|
| bats-installed   | True/False if bats has been installed          |
| support-installed| True/False if bats-support has been installed  |
| assert-installed | True/False if bats-assert has been installed   |
| detik-installed  | True/False if bats-detik has been installed    |
| file-installed   | True/False if bats-file has been installed     |
