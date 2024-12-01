abstract class EarthImageryEvent {}

class FetchEarthImageryEvent extends EarthImageryEvent {
  final double latitude;
  final double longitude;
  final String date;

  FetchEarthImageryEvent({
    required this.latitude,
    required this.longitude,
    required this.date,
  });
}
