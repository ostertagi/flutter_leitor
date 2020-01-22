import 'package:flutter_leitor/app/app_module.dart';
import 'package:flutter_leitor/app/modules/home/home_module.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular_test.dart';

import 'package:flutter_leitor/app/modules/home/home_page.dart';

main() {
  initModules([AppModule(), HomeModule()]);
  testWidgets('HomePage has title', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(HomePage(title: 'Home')));
    final titleFinder = find.text('Home');
    expect(titleFinder, findsOneWidget);
  });
}
