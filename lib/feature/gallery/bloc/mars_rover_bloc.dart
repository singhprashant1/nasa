import 'package:bloc/bloc.dart';
import 'mars_rover_event.dart';
import 'mars_rover_state.dart';
import '../data/mars_rover_repository.dart';

class MarsRoverBloc extends Bloc<MarsRoverEvent, MarsRoverState> {
  final MarsRoverRepository marsRoverRepository;

  MarsRoverBloc({required this.marsRoverRepository}) : super(MarsRoverInitial()) {
    on<FetchMarsPhotosEvent>((event, emit) async {
      emit(MarsRoverLoading());
      try {
        final photos = await marsRoverRepository.fetchMarsPhotos(
          rover: event.rover,
          camera: event.camera,
          sol: event.sol,
        );
        emit(MarsRoverLoaded(photos: photos));
      } catch (e) {
        emit(MarsRoverError(message: e.toString()));
      }
    });
  }
}
