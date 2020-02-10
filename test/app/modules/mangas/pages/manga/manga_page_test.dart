import 'dart:io';

import 'package:flutter_leitor/app/app_module.dart';
import 'package:flutter_leitor/app/modules/mangas/mangas_module.dart';
import 'package:flutter_leitor/app/modules/mangas/pages/manga/manga_page.dart';
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

main() {
  Hive.init(Directory.current.path + "/hive");
  initModules([AppModule(), MangasModule()]);
  testWidgets('MangaPage has title', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        MangaPage(
          // manga: TituloModel(
          //     nome: 'MANGA', link: 'http://', imagem: '', descricao: ''),
        ),
      ),
    );
    await tester.pump(Duration(minutes: 1));
    final titleFinder = find.text('MANGA');
    expect(titleFinder, findsOneWidget);
  });
}
