import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iOS GoogleService-Info.plist exists and contains expected keys', () async {
    final path = 'ios/Runner/GoogleService-Info.plist';
    final file = File(path);

    expect(await file.exists(), isTrue, reason: 'Expected $path to exist in the repo');

    final content = await file.readAsString();

    expect(content.contains('STORAGE_BUCKET'), isTrue, reason: 'Expected STORAGE_BUCKET key in plist');
    expect(content.contains('GOOGLE_APP_ID'), isTrue, reason: 'Expected GOOGLE_APP_ID key in plist');
  });
}
