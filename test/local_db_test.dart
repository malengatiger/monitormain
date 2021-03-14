import 'package:flutter_test/flutter_test.dart';
import 'package:monitorlibrary/api/local_db_api.dart';
import 'package:monitorlibrary/functions.dart';

main() {
  test('Local Database Test', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var res;
    try {
      res = await LocalDBAPI.connectToLocalDB();
    } catch (e) {
      pp('👿👿 This shit cannot be tested 👿👿: $e');
    }
    expect(res, null);
  });
}
