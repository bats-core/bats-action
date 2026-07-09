# Setup Bats and Bats libraries

This GitHub Action installs [Bats](https://github.com/bats-core/bats-core) and the four major Bats libraries:

* [bats-support](https://github.com/bats-core/bats-support)
* [bats-assert](https://github.com/bats-core/bats-assert)
* [bats-detik](https://github.com/bats-core/bats-detik)
* [bats-file](https://github.com/bats-core/bats-file)

## How to use it

```yaml
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v5
      - name: Setup Bats and Bats libraries
        uses: bats-core/bats-action@4.0.0
      - name: Run tests
        run: bats test
```

The installed libraries can be loaded directly from your Bats tests:

```bash
bats_load_library bats-support
bats_load_library bats-assert
bats_load_library bats-file
bats_load_library bats-detik/detik.bash
```

## Outputs

| Key | Description |
| --- | --- |
| `lib-path` | Bats library search path |
