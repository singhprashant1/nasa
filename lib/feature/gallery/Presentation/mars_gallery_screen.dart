import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/feature/favorites/bloc/favorites_bloc.dart';
import 'package:nasa/feature/favorites/bloc/favorites_event.dart';

import '../bloc/mars_rover_bloc.dart';
import '../bloc/mars_rover_event.dart';
import '../bloc/mars_rover_state.dart';

class MarsGalleryScreen extends StatefulWidget {
  @override
  _MarsGalleryScreenState createState() => _MarsGalleryScreenState();
}

class _MarsGalleryScreenState extends State<MarsGalleryScreen> {
  String selectedRover = 'curiosity';
  String selectedCamera = 'fhaz';
  int selectedSol = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mars Rover Photos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedRover,
                  items: ['curiosity', 'opportunity', 'spirit']
                      .map((rover) => DropdownMenuItem(
                    value: rover,
                    child: Text(rover.toUpperCase()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRover = value!;
                    });
                  },
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedCamera,
                  items: ['fhaz', 'rhaz', 'mast']
                      .map((camera) => DropdownMenuItem(
                    value: camera,
                    child: Text(camera.toUpperCase()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCamera = value!;
                    });
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Sol'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      selectedSol = int.tryParse(value) ?? 1000;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<MarsRoverBloc>().add(
                      FetchMarsPhotosEvent(
                        rover: selectedRover,
                        camera: selectedCamera,
                        sol: selectedSol,
                      ),
                    );
                  },
                  child: Text('Filter'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MarsRoverBloc, MarsRoverState>(
              builder: (context, state) {
                if (state is MarsRoverInitial) {
                  return Center(child: Text('Select filters to fetch photos'));
                } else if (state is MarsRoverLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MarsRoverLoaded) {
                  if (state.photos.isEmpty) {
                    return Center(child: Text('No photos found.'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: state.photos.length,
                    itemBuilder: (context, index) {
                      final photo = state.photos[index];
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              photo['img_src'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Text('Failed to load image'));
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<FavoritesBloc>().add(
                                    AddFavoriteEvent(
                                      title: 'Mars',
                                      imageUrl: photo['img_src'],
                                      type: 'Mars',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Favorite Added'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Icon(Icons.favorite_border,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is MarsRoverError) {
                  return Center(child: Text(state.message));
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
