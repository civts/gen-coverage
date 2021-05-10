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
      group('if min-coverage argument is', () {
        const expectedErrorMessage = 'invalid min-coverage supplied\n'
            'it must be an integer between 0 and 100\n';
        group('not an integer', () {
          test('should report the error to the user', () async {
            const invalid = ['', 'null', '20.0', 'string'];
            for (final i in invalid) {
              final process = await Process.start(
                'dart',
                ['run', 'gen_coverage', '--min-coverage', i],
              );
              await expectLater(
                process.stdout.transform(utf8.decoder),
                emits(expectedErrorMessage),
              );
              final exitCode = await process.exitCode;
              expect(exitCode, 1);
            }
          });
        });
        group('not in the acceptable range should error', () {
          test('less than 0', () async {
            final process = await Process.start(
              'dart',
              ['run', 'gen_coverage', '--min-coverage', '-1'],
            );
            await expectLater(
              process.stdout.transform(utf8.decoder),
              emits(expectedErrorMessage),
            );
            final exitCode = await process.exitCode;
            expect(exitCode, 1);
          });
          test('greater than 100', () async {
            final process = await Process.start(
              'dart',
              ['run', 'gen_coverage', '--min-coverage', '101'],
            );
            await expectLater(
              process.stdout.transform(utf8.decoder),
              emits(expectedErrorMessage),
            );
            final exitCode = await process.exitCode;
            expect(exitCode, 1);
          });
        });
      });
      group('if help flag is passed', () {
        group('and other flags are passed', () {
          group('and they are all valid', () {
            test('should print help menu', () async {
              final process = await Process.start(
                'dart',
                ['run', 'gen_coverage', '--help'],
              );
              await expectLater(
                process.stdout.transform(utf8.decoder),
                emits(
                  contains('-h, --help                      Show help menu'),
                ),
              );
              final exitCode = await process.exitCode;
              expect(exitCode, 0);
            });
          });
          group('but some are not valid', () {
            test('should print help menu', () async {
              final process = await Process.start(
                'dart',
                ['run', 'gen_coverage', '--help', '--wrongFlags'],
              );
              await expectLater(
                process.stdout.transform(utf8.decoder),
                emits(
                  'Invalid arguments: '
                  'Could not find an option named "wrongFlags".\n',
                ),
              );
              final exitCode = await process.exitCode;
              expect(exitCode, 1);
            });
          });
        });
        group('and no other flags are passed', () {
          test('should print help menu', () async {
            final process = await Process.start(
              'dart',
              [
                'run',
                'gen_coverage',
                '--port',
                '1234',
                '--help',
                '--min-coverage',
                '50'
              ],
            );
            await expectLater(
              process.stdout.transform(utf8.decoder),
              emits(
                contains('-h, --help                      Show help menu'),
              ),
            );
            final exitCode = await process.exitCode;
            expect(exitCode, 0);
          });
        });
      });
    });
  });
}
