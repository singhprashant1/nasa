import 'package:bloc/bloc.dart';
import 'package:nasa/database/favorites_database.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesDatabase database;

  FavoritesBloc({required this.database}) : super(FavoritesInitial()) {
    on<AddFavoriteEvent>((event, emit) async {
      try {
        await database.addFavorite(event.title, event.imageUrl, event.type);
        add(LoadFavoritesEvent()); // Refresh the list
      } catch (e) {
        emit(FavoritesError(message: e.toString()));
      }
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      try {
        await database.deleteFavorite(event.id);
        add(LoadFavoritesEvent()); // Refresh the list
      } catch (e) {
        emit(FavoritesError(message: e.toString()));
      }
    });

    on<LoadFavoritesEvent>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final favorites = await database.getFavorites();
        emit(FavoritesLoaded(favorites: favorites));
      } catch (e) {
        emit(FavoritesError(message: e.toString()));
      }
    });
  }
}
