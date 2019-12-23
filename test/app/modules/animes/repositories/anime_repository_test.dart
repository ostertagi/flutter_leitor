import 'package:flutter_leitor/app/shared/dio/custom_dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_leitor/app/modules/animes/repositories/anime_repository.dart';

class MockClient extends Mock implements CustomDio {}

void main() {
  AnimeRepository repository;
  MockClient client;

  setUp(() {
    client = MockClient();
    repository = AnimeRepository(client);
  });

  group('AnimeRepository Test', () {
    test("First Test", () {
      expect(repository, isInstanceOf<AnimeRepository>());
    });

    test('returns a Post if the http call completes successfully', () async {
      // when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
      //     .thenAnswer(
      //         (_) async => Response(data: {'title': 'Test'}, statusCode: 200));
      // Map<String, dynamic> data = await repository._getLink('https://jsonplaceholder.typicode.com/posts/1');
      // expect(data['title'], 'Test');
    });
  });
}