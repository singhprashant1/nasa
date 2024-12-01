abstract class EarthImageryState {}

class EarthImageryInitial extends EarthImageryState {}

class EarthImageryLoading extends EarthImageryState {}

class EarthImageryLoaded extends EarthImageryState {
  final String imageUrl;

  EarthImageryLoaded({required this.imageUrl});
}

class EarthImageryError extends EarthImageryState {
  final String message;

  EarthImageryError({required this.message});
}
