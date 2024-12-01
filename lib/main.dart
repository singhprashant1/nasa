import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/database/favorites_database.dart';
import 'package:nasa/feature/earth/Presentation/earth_imagery_screen.dart';
import 'package:nasa/feature/earth/bloc/earth_imagery_bloc.dart';
import 'package:nasa/feature/earth/data/earth_imagery_repository.dart';
import 'package:nasa/feature/favorites/Presentation/favorites_screen.dart';
import 'package:nasa/feature/favorites/bloc/favorites_bloc.dart';
import 'package:nasa/feature/gallery/Presentation/mars_gallery_screen.dart';
import 'package:nasa/feature/gallery/bloc/mars_rover_bloc.dart';
import 'package:nasa/feature/gallery/data/mars_rover_repository.dart';
import 'package:nasa/feature/home_page/Presentation/home_screen.dart';
import 'package:nasa/feature/home_page/bloc/apod_bloc.dart';
import 'package:nasa/feature/home_page/data/apod_repository.dart';
import 'package:nasa/database/favorites_database.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apodRepository = ApodRepository(apiKey: 'FmM01gHtO0X5X16fPRYMhAzBf7DmEFpxFnjs4R9G');
    final marsRoverRepository = MarsRoverRepository(apiKey: 'FmM01gHtO0X5X16fPRYMhAzBf7DmEFpxFnjs4R9G');
    final earthRoverRepository = EarthImageryRepository(apiKey: 'FmM01gHtO0X5X16fPRYMhAzBf7DmEFpxFnjs4R9G');
    final favoritesDatabase = FavoritesDatabase.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ApodBloc(apodRepository: apodRepository)),
        BlocProvider(create: (_) => MarsRoverBloc(marsRoverRepository: marsRoverRepository)),
        BlocProvider(create: (_) => EarthImageryBloc(repository: earthRoverRepository)),
        BlocProvider(create: (_) => FavoritesBloc(database: favoritesDatabase)),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MarsGalleryScreen(),
    EarthImageryScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'APOD'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Mars Photos'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Earth Imagery'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
