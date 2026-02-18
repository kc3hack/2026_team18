import 'package:flutter_test/flutter_test.dart';
import 'package:mikata/models/account.dart';

void main() {
    test("UserIDを生成する", () {
        final String id = createUserID();
        print(id);
        expect(id.length, 8);
    });
}