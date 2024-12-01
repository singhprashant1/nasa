import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesInitial) {
            context.read<FavoritesBloc>().add(LoadFavoritesEvent());
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return Center(child: Text('No favorites added yet.'));
            }
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final favorite = state.favorites[index];
                return ListTile(
                  title: Text(favorite['title']),
                  subtitle: Text(favorite['type']),
                  leading: Image.network(favorite['imageUrl'], width: 50, height: 50),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(id: favorite['id']));
                    },
                  ),
                );
              },
            );
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
