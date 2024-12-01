import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/feature/favorites/bloc/favorites_bloc.dart';
import 'package:nasa/feature/favorites/bloc/favorites_event.dart';
import 'package:photo_view/photo_view.dart';

import '../bloc/apod_bloc.dart';
import '../bloc/apod_event.dart';
import '../bloc/apod_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    context.read<ApodBloc>().add(FetchApodEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astronomy Picture of the Day'),
      ),
      body: BlocBuilder<ApodBloc, ApodState>(
        builder: (context, state) {
          if (state is ApodLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ApodLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill( // Ensure the image fills the container
                          child: Image.network(
                            state.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Failed to load image'));
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight, // Position at the bottom-right corner
                          child: Padding(
                            padding: const EdgeInsets.all(8.0), // Add some padding
                            child: GestureDetector(
                              onTap: () {
                                context.read<FavoritesBloc>().add(
                                  AddFavoriteEvent(
                                    title: state.title,
                                    imageUrl: state.imageUrl,
                                    type: 'APOD',
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Favorite Added'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.favorite_border, // Toggle to Icons.favorite for selected state
                                color: Colors.black, // Adjust color for better visibility
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    state.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.explanation,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullscreenImageScreen(imageUrl: state.imageUrl),
                        ),
                      );
                    },
                    child: Text('View Fullscreen'),
                  ),
                ],
              ),
            );
          } else if (state is ApodError) {
            return Center(child: Text(state.message));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class FullscreenImageScreen extends StatelessWidget {
  final String imageUrl;

  FullscreenImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fullscreen Image')),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: BoxDecoration(color: Colors.black),
      ),
    );
  }
}
