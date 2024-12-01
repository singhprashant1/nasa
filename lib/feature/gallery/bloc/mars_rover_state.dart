abstract class MarsRoverState {}

class MarsRoverInitial extends MarsRoverState {}

class MarsRoverLoading extends MarsRoverState {}

class MarsRoverLoaded extends MarsRoverState {
  final List<Map<String, dynamic>> photos;

  MarsRoverLoaded({required this.photos});
}

class MarsRoverError extends MarsRoverState {
  final String message;

  MarsRoverError({required this.message});
}
