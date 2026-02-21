// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:mikata/models/account.dart';

void main() {
  test("UserIDを生成する", () {
    final String id = createAccountID();
    print(id);
    expect(id.length, 8);
  });
}
