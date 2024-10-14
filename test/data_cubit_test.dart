import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injection_dependency/data_cubit.dart';
import 'package:injection_dependency/data_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'data_cubit_test.mocks.dart';

@GenerateMocks([DataRepository])
void main() {
  late DataCubit dataCubit;
  late MockDataRepository mockDataRepository;

  setUp(() {
    mockDataRepository = MockDataRepository();
    dataCubit = DataCubit(mockDataRepository);
  });

  blocTest<DataCubit, DataState>(
    'emits [DataLoading, DataLoaded] when fetchData succeeds',
    build: () {
      when(mockDataRepository.fetchData()).thenAnswer((_) async => 'data');
      return dataCubit;
    },
    act: (cubit) => cubit.fetchData(),
    expect: () => [
      DataLoading(),
      DataLoaded('data'),
    ],
  );

  blocTest<DataCubit, DataState>(
    'emits [DataLoading, DataError] when fetchData fails',
    build: () {
      when(mockDataRepository.fetchData()).thenThrow(Exception('error'));
      return dataCubit;
    },
    act: (cubit) => cubit.fetchData(),
    expect: () => [
      DataLoading(),
      DataError('Exception: error'),
    ],
  );
}
