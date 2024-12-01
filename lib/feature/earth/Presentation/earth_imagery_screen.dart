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
      appBar: AppBar(
        title: Text(
          'Earth Imagery',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure elements are stretched
          children: [
            // Latitude Input
            _buildTextField(
              controller: _latitudeController,
              label: 'Latitude',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 12),

            // Longitude Input
            _buildTextField(
              controller: _longitudeController,
              label: 'Longitude',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16),

            // Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selected Date: ${_selectedDate.toLocal().toIso8601String().split('T')[0]}',
                    style: TextStyle(fontSize: 16),
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
                  child: Text(
                    'Select Date',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Fetch Imagery Button
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Fetch Imagery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
            SizedBox(height: 16),

            // Earth Imagery Display
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
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.redAccent,
                                size: 32,
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

  // Reusable TextField Widget for input fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
