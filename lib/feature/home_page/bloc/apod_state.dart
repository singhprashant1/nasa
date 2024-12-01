abstract class ApodState {}

class ApodInitial extends ApodState {}

class ApodLoading extends ApodState {}

class ApodLoaded extends ApodState {
  final String imageUrl;
  final String title;
  final String explanation;

  ApodLoaded({
    required this.imageUrl,
    required this.title,
    required this.explanation,
  });
}

class ApodError extends ApodState {
  final String message;

  ApodError({required this.message});
}
