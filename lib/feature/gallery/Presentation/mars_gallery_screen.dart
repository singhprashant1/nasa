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
        backgroundColor: Colors.deepOrange, // Modern and vibrant color
        title: Text(
          'Mars Rover Photos',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for a cleaner layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown(
                  selectedValue: selectedRover,
                  items: ['Curiosity', 'Opportunity', 'Spirit'],
                  onChanged: (value) => setState(() => selectedRover = value!),
                ),
                _buildDropdown(
                  selectedValue: selectedCamera,
                  items: ['FHAZ', 'RHAZ', 'MAST'],
                  onChanged: (value) => setState(() => selectedCamera = value!),
                ),
                _buildSolInput(),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Consistent color theme
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Filter', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<MarsRoverBloc, MarsRoverState>(
                builder: (context, state) {
                  if (state is MarsRoverInitial) {
                    return Center(
                        child: Text('Select filters to fetch photos'));
                  } else if (state is MarsRoverLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MarsRoverLoaded) {
                    if (state.photos.isEmpty) {
                      return Center(child: Text('No photos found.'));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: state.photos.length,
                      itemBuilder: (context, index) {
                        final photo = state.photos[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  photo['img_src'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Text('Failed to load image'));
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Favorite Added'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
      ),
    );
  }


  Widget _buildDropdown({
    required String selectedValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        items: items
            .map((item) => DropdownMenuItem(
          value: item.toLowerCase(),
          child: Text(
            item.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ))
            .toList(),
        onChanged: onChanged,
        style: TextStyle(color: Colors.deepOrange, fontSize: 16),
        icon: Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildSolInput() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Sol',
            labelStyle: TextStyle(color: Colors.deepOrange),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(12),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            selectedSol = int.tryParse(value) ?? 1000;
          },
        ),
      ),
    );
  }
}
