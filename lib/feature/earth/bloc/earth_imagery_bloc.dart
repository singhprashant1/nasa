import 'package:bloc/bloc.dart';
import 'earth_imagery_event.dart';
import 'earth_imagery_state.dart';
import '../data/earth_imagery_repository.dart';

class EarthImageryBloc extends Bloc<EarthImageryEvent, EarthImageryState> {
  final EarthImageryRepository repository;

  EarthImageryBloc({required this.repository}) : super(EarthImageryInitial()) {
    on<FetchEarthImageryEvent>((event, emit) async {
      emit(EarthImageryLoading());
      try {
        final imageUrl = await repository.fetchEarthImagery(
          latitude: event.latitude,
          longitude: event.longitude,
          date: event.date,
        );
        emit(EarthImageryLoaded(imageUrl: imageUrl));
      } catch (e) {
        emit(EarthImageryError(message: e.toString()));
      }
    });
  }
}
