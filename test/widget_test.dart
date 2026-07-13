import 'package:flutter_test/flutter_test.dart';
import 'package:in_lida/main.dart';

void main() {
  test('MyApp can be constructed without initializing external services', () {
    expect(const MyApp(), isA<MyApp>());
  });
}
