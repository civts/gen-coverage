[![Style: effective dart](https://img.shields.io/badge/style-effective%20dart-47bef3)](https://github.com/tenhobi/effective_dart)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# gen_coverage

`gen_coverage` is a simple command-line utility you can use to:

1.  Generate [lcov](https://github.com/linux-test-project/lcov) reports for your
    dart packages;

1.  Enforce a minimum coverage percentage using the `--min-coverage` flag.

## Alternatives

- If you are using Flutter, you do not need to install this package: use the
  command `flutter test --coverage`.

- If you only want the `lcov.info` file, you can run a small script to generate
  it for you (provided you have the dependencies
  [test](https://pub.dev/packages/test) and
  [coverage](https://pub.dev/packages/coverage) installed).  
  This package does basically the same thing, plus, optionally, a final check to
  ensure that the code meets a specified minimum coverage percentage.
  ```bash
  #Run tests and collect coverage info
  dart run test --coverage .tempCoverageDir
  #Generate lcov.info file in ./coverage
  dart run coverage:format_coverage -l -c --report-on lib -i .tempCoverageDir --packages .packages -o coverage/lcov.info
  #Clean up unneeded coverage info
  rm -r .tempCoverageDir
  ```

## Installation

To install `gen_coverage`, you can add the following lines to your
`pubspec.yaml` to fetch the package directly from github at a specific commit.

```yaml
dev_dependencies:
  gen_coverage:
    git:
      url: https://github.com/civts/gen-coverage.git
      ref: 8639946ffbed59b7c28e1628b43f55b671983161 #hash of the last commit you want to fetch
```

Alternatively, you can download this repository on your machine and add to the
`pubspec.yaml` the following lines instead.

```yaml
dev_dependencies:
  gen_coverage:
    path: 'path/to/gen_coverage_folder'
```

## Usage

Once you have added `gen_coverage` to your pubspec and ran `dart pub get`, you
can run the command `dart run gen_coverage` in the root of your project to
generate the report in `./coverage/lcov.info`.  
You can optionally specify the `--min-coverage` argument to make the command
return with an error code if your overall code coverage is below the specified
value.  
Using the `--help` flag will show all the options the command supports.

## Will this package be published on pub.dev?

At the moment, I am not thinking about publishing this package. There are
already other packages that serve a similar purpose, like
[test_cov](https://pub.dev/packages/test_cov).  
If you would like to see this package published, go ahead and let me know.  
For now, I will continue to use it in my projects and update it as needed.

## Credits

This pacakge was originally inspired by
[test-coverage](https://github.com/pulyaevskiy/test-coverage) and
[check-coverage](https://github.com/f3ath/check-coverage).
