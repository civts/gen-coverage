import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

///Path (relative to the directory where the program is being executed)
///where gen_coverage will save the temporary data it needs
const coverageDataPath = 'coverage/.gen_coverage';

///Executes all tests using the [test package](https://pub.dev/packages/test)
///and stores the coverage information it generates in the [coverageDataPath]
///directory
Future<void> runTestsAndGenerateCoverageInfo(
  String? port, {
  bool printTestOutput = false,
}) async {
  //dart test --coverage=coverage/data
  var process = await Process.start('dart', [
    // '--pause-isolates-on-exit',
    '--enable_asserts',
    if (port != null) '--enable-vm-service=$port',
    'test',
    '--coverage',
    coverageDataPath,
  ]);
  if (printTestOutput) {
    await process.stdout.transform(utf8.decoder).forEach(print);
  }
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    print('Test script terminated with an error');
    exit(1);
  }
}

///Converts the coverage data generated by the test package in
Future<void> formatTestResultsToLcov(String packageRoot) async {
  //dart run coverage:format_coverage -l -c -i coverage -o coverage/lcov.info --report-on=bin --packages=.packages
  final packageFileName = await _determinePackageFileName(packageRoot);
  var process = await Process.start('dart', [
    'run',
    'coverage:format_coverage',
    '-l',
    '-c',
    '-i',
    '$coverageDataPath',
    '-o',
    'coverage/lcov.info',
    '--report-on',
    'lib',
    '--packages',
    packageFileName
  ]);
  await process.stdout.transform(utf8.decoder).forEach(print);
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    print('Coverage script terminated with an error');
    exit(1);
  }
}

///Determines the packages file we should use in coverage:format_coverage
///--packages.
///Returns the path relative to [packageRoot] to either the .packages file
///or the .dart_tool/package_config.json
Future<String> _determinePackageFileName(String packageRoot) async {
  const packagesFilePath1 = '.packages';
  const packagesFilePath2 = '.dart_tool/package_config.json';
  final packagesFileV1 = File(path.join(packageRoot, packagesFilePath1));
  final packagesFileV2 = File(path.join(packageRoot, packagesFilePath2));
  if (await packagesFileV2.exists()) {
    return packagesFilePath2;
  } else {
    if (!await packagesFileV1.exists()) {
      print(
        '''
        Could not find any pacakges file (looked for $packagesFileV2 and $packagesFileV1).
        Run dart pub get and try again
        ''',
      );
      exit(1);
    }
    return packagesFilePath1;
  }
}

///Deletes the temporary files created by this program
///
///If the folder in [coverageDataPath] does not exist,
///no error is thrown
Future<void> cleanTemporaryFiles(String packageRoot) async {
  final dir = Directory(path.join(packageRoot, coverageDataPath));
  await dir.delete(recursive: true).catchError((_) {});
}

///Parses the lcov report file and returns the line coverage percentage
///as a number between 0 and 100
double calculateLineCoverage(File lcovReport) {
  final lflhRegex = RegExp(r'^L[FH]:(\d*)$');
  final reportFileContent = lcovReport.readAsLinesSync();
  reportFileContent.retainWhere(lflhRegex.hasMatch);
  var totalLines = 0;
  var hitLines = 0;
  for (final line in reportFileContent) {
    var valueString = lflhRegex.matchAsPrefix(line)?.group(1) ?? '0';
    var value = int.tryParse(valueString) ?? 0;
    if (line.startsWith('LF')) {
      totalLines += value;
    } else {
      hitLines += value;
    }
  }
  if (totalLines == 0) return 1;
  return hitLines / totalLines * 100;
}
