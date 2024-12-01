abstract class FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final String title;
  final String imageUrl;
  final String type;

  AddFavoriteEvent({
    required this.title,
    required this.imageUrl,
    required this.type,
  });
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int id;

  RemoveFavoriteEvent({required this.id});
}

class LoadFavoritesEvent extends FavoritesEvent {}
