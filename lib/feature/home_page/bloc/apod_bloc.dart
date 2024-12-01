import 'package:bloc/bloc.dart';
import 'apod_event.dart';
import 'apod_state.dart';
import '../data/apod_repository.dart';

class ApodBloc extends Bloc<ApodEvent, ApodState> {
  final ApodRepository apodRepository;

  ApodBloc({required this.apodRepository}) : super(ApodInitial()) {
    on<FetchApodEvent>((event, emit) async {
      emit(ApodLoading());
      try {
        final apod = await apodRepository.fetchApod();
        emit(ApodLoaded(
          imageUrl: apod['url'],
          title: apod['title'],
          explanation: apod['explanation'],
        ));
      } catch (e) {
        emit(ApodError(message: e.toString()));
      }
    });
  }
}
