[![Style: effective dart](https://img.shields.io/badge/style-effective%20dart-47bef3)](https://github.com/tenhobi/effective_dart)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

| ⚠ WARNING                                                 |
| :-------------------------------------------------------- |
| This pacakge is a **work-in-progress**. Do not use it yet |

# gen_coverage

`gen_coverage` is a simple command line application you can use to:

1.  Generate [lcov](https://github.com/linux-test-project/lcov) reports for your
    dart packages.

1.  Enforce a minimum coverage percentage using the `--min-coverage` argument

If you are using Flutter, you do not need to install this, since you can use the
command `flutter test --coverage`.

## Installation

To install `gen_coverage`, just add it to your dev_dependencies in the
pubspec.yaml

```yaml
dev_dependencies:
  gen_coverage: ^0.0.1
```

## Usage

Once you have added `gen_coverage` to your pubspec and ran `dart pub get`, you
can run the command `dart run gen_coverage` in the root of your project to
generate the report in `./coverage/lcov.info`.  
You can optionally specify the `--min-coverage` argument to make the command
fail if your overall code coverage is below the specified value.  
Using the `--help` flag will show all the options the command supports.

## TODO:

List of things I want to do before publishing.

- [ ] add tests
- [ ] contributing.md
- [ ] issue template
- [ ] pr template  
- [ ] remove this section from the readme

## Credits

This pacakge was originally inspired by
[test-coverage](https://github.com/pulyaevskiy/test-coverage) and
[check-coverage](https://github.com/f3ath/check-coverage) by f3ath.
