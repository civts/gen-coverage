library gen_coverage;

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:gen_coverage/src/gen_coverage.dart';
import 'package:path/path.dart' as path;

const _kPrintTestOutputFlagName = 'print-test-output';
const _kMinCoverageArgumentName = 'min-coverage';
const _kPortArgumentName = 'port';
const _kHelpFLagName = 'help';

Future main(List<String> arguments) async {
  ArgResults options;
  final parser = _createArgumentParser();
  try {
    options = parser.parse(arguments);
  } on ArgParserException catch (e) {
    print('Invalid arguments: ${e.message}');
    exit(1);
  }

  if (options.wasParsed(_kHelpFLagName)) {
    print(parser.usage);
    return;
  }

  final minCoverage = int.tryParse(
    options[_kMinCoverageArgumentName] as String,
  );
  if (minCoverage == null || minCoverage < 0 || minCoverage > 100) {
    print(
      'invalid $_kMinCoverageArgumentName supplied\n'
      'it must be an integer between 0 and 100',
    );
    exit(1);
  }

  final port = options[_kPortArgumentName] as String?;

  print('🏃 Running tests');
  await runTestsAndGenerateCoverageInfo(
    Directory.current.path,
    port,
    printTestOutput: options[_kPrintTestOutputFlagName] as bool,
  );
  print('📑 Generating report');
  await formatTestResultsToLcov(Directory.current.path);
  await cleanTemporaryFiles(Directory.current.path);
  final coveragePct = calculateLineCoverage(
      File(path.join(Directory.current.path, 'coverage/lcov.info')));
  if (coveragePct < minCoverage) {
    print(
      '❌ Overall coverage ${coveragePct.toStringAsFixed(2)} is less '
      'than required minimum coverage $minCoverage',
    );
    exit(1);
  } else {
    print('✅ All good!');
  }
}

ArgParser _createArgumentParser() {
  final parser = ArgParser();

  parser.addFlag(
    _kHelpFLagName,
    abbr: 'h',
    help: 'Show help menu',
    negatable: false,
  );

  parser.addOption(
    _kPortArgumentName,
    abbr: 'p',
    help:
        'If specified, Dart Observatory will run on this port during the tests',
  );

  parser.addFlag(
    _kPrintTestOutputFlagName,
    help: 'Wether or not to print the output of the test command',
    defaultsTo: false,
  );

  parser.addOption(
    _kMinCoverageArgumentName,
    help: 'Min coverage to pass. Should be between 0 and 100 (inclusive)',
    defaultsTo: '0',
  );

  return parser;
}
