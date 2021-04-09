import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('main', () {
    group('CLI argument parser', () {
      group('if unrecognized values are passed as arguments', () {
        test('should exit with error', () async {
          final processResult = await Process.run(
            'dart',
            ['run', 'gen_coverage', '--verbose'],
          );
          final exitCode = processResult.exitCode;
          expect(exitCode, 1);
        });
        test('should inform the user about what went wrong', () async {
          final process = await Process.start(
            'dart',
            ['run', 'gen_coverage', '--verbose'],
          );
          await expectLater(
            process.stdout.transform(utf8.decoder),
            emits(
              'Invalid arguments: Could not find an option named "verbose".\n',
            ),
          );
          final exitCode = await process.exitCode;
          expect(exitCode, 1);
        });
      });
    });
  });
}
