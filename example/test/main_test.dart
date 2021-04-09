import 'package:test/test.dart';

import 'package:example/main.dart';

void main() {
  test('sum', () {
    expect(sum(1, 2), 3);
  });
  test('subtraction', () {
    expect(subtract(1, 2), -1);
  });
}
