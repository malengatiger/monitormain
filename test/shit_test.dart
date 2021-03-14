import 'package:flutter_test/flutter_test.dart';
import 'package:monitorlibrary/functions.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Miscellaneous Shit Tests', () {
    test('Shit Test #1', () async {
      var debugMode = isInDebugMode;
      pp('debugMode found is 👌 $debugMode');
      expect(debugMode, true);
    });
    test('Shit Test #2', () async {
      var date = getFormattedDateHourMinSec(DateTime.now().toString());
      pp('Current Date is 👌 $date 👌');
      expect(date, '');
    });
  });
}
