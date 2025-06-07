import 'package:flutter/material.dart';
import 'package:movie_predictor/rating_page.dart';
import 'components/single_checkbox.dart'; // import your checkbox widget
import 'components/next_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Children',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Fantasy',
    'Film-Noir',
    'Horror',
    'IMAX',
    'Musical',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'War',
    'Western',
  ];

  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 9.0),
                    child: Icon(Icons.movie, size: 32),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Predict\n          Your Movie',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              const Text(
                "Select Your Preferred Movie Genres",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: genres.map((genre) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 24,
                    child: SingleGenreCheckbox(
                      label: genre,
                      isSelected: _selectedGenre == genre,
                      onTap: () {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                _selectedGenre == null
                    ? 'No genre selected'
                    : 'Selected: $_selectedGenre',
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              NextButton(
                enabled: _selectedGenre != null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RatingPage(selectedGenre: _selectedGenre!),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
