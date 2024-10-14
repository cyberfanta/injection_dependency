import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_repository.dart';

abstract class DataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final String data;

  DataLoaded(this.data);
}

class DataError extends DataState {
  final String message;

  DataError(this.message);
}

class DataCubit extends Cubit<DataState> {
  DataCubit(this.dataRepository) : super(DataInitial());

  final DataRepository dataRepository;

  void fetchData() async {
    try {
      emit(DataLoading());

      final data = await dataRepository.fetchData();
      emit(DataLoaded(data!));
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }
}
