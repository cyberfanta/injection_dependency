import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:injection_dependency/data_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_repository_test.mocks.dart';

@GenerateMocks([SharedPreferences, http.Client])
void main() {
  late DataRepository dataRepository;
  late MockSharedPreferences mockSharedPreferences;
  late MockClient mockHttpClient;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockHttpClient = MockClient();
    dataRepository = DataRepository(mockSharedPreferences);
  });

  group('DataRepository Tests', () {
    test('fetchData returns local data if available', () async {
      // Arrange
      when(mockSharedPreferences.getString('data')).thenReturn('local_data');

      // Act
      final data = await dataRepository.fetchData();

      // Assert
      expect(data, equals('local_data'));
    });

    test(
        'fetchData fetches and stores remote data if local data is not available',
        () async {
      // Arrange
      when(mockSharedPreferences.getString('data')).thenReturn(null);
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('remote_data', 200));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => Future.value(true));

      // Act
      final data = await dataRepository.fetchData();

      // Assert
      expect(data, equals('remote_data'));
      verify(mockSharedPreferences.setString('data', 'remote_data')).called(1);
    });

    test('fetchData throws an exception if the HTTP request fails', () async {
      // Arrange
      when(mockSharedPreferences.getString('data')).thenReturn(null);
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Error', 404));
      // when(mockSharedPreferences.setString(any, any))
      //     .thenAnswer((_) async => Future.value(true));

      // Act & Assert
      expect(() => dataRepository.fetchData(), throwsException);
    });
  });
}
