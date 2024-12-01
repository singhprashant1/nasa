abstract class MarsRoverEvent {}

class FetchMarsPhotosEvent extends MarsRoverEvent {
  final String rover;
  final String camera;
  final int sol;

  FetchMarsPhotosEvent({
    required this.rover,
    required this.camera,
    required this.sol,
  });
}
