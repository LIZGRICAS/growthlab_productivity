import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iOS Info.plist contains NSCameraUsageDescription', () async {
    final path = 'ios/Runner/Info.plist';
    final file = File(path);

    expect(await file.exists(), isTrue, reason: 'Expected $path to exist');

    final content = await file.readAsString();
    expect(content.contains('NSCameraUsageDescription'), isTrue, reason: 'Expected NSCameraUsageDescription key');
  });
}
