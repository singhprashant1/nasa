import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/feature/favorites/bloc/favorites_bloc.dart';
import 'package:nasa/feature/favorites/bloc/favorites_event.dart';

import '../bloc/earth_imagery_bloc.dart';
import '../bloc/earth_imagery_event.dart';
import '../bloc/earth_imagery_state.dart';

class EarthImageryScreen extends StatefulWidget {
  @override
  _EarthImageryScreenState createState() => _EarthImageryScreenState();
}

class _EarthImageryScreenState extends State<EarthImageryScreen> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Earth Imagery')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selected Date: ${_selectedDate.toLocal().toIso8601String().split('T')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final latitude = double.tryParse(_latitudeController.text);
                final longitude = double.tryParse(_longitudeController.text);

                if (latitude != null && longitude != null) {
                  context.read<EarthImageryBloc>().add(
                    FetchEarthImageryEvent(
                      latitude: latitude,
                      longitude: longitude,
                      date: _selectedDate.toLocal().toIso8601String().split('T')[0],
                    ),
                  );
                }
              },
              child: Text('Fetch Imagery'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<EarthImageryBloc, EarthImageryState>(
                builder: (context, state) {
                  if (state is EarthImageryInitial) {
                    return Center(child: Text('Enter details to fetch imagery.'));
                  } else if (state is EarthImageryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is EarthImageryLoaded) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            state.imageUrl,
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
                                    title: 'Earth',
                                    imageUrl: state.imageUrl,
                                    type: 'Earth',
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
                                color: Colors.redAccent,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is EarthImageryError) {
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
}
