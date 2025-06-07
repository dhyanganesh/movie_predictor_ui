import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movies_list_page.dart';

class VotesPage extends StatefulWidget {
  final String selectedGenre;
  final double expectedRating;

  const VotesPage({
    Key? key,
    required this.selectedGenre,
    required this.expectedRating,
  }) : super(key: key);

  @override
  State<VotesPage> createState() => _VotesPageState();
}

class _VotesPageState extends State<VotesPage> {
  final TextEditingController _votesController = TextEditingController();
  int? _validVotes;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _votesController.dispose();
    super.dispose();
  }

  void _validateVotes(String input) {
    final intValue = int.tryParse(input);
    setState(() {
      _validVotes = (intValue != null && intValue >= 0) ? intValue : null;
      _errorMessage = null;
    });
  }

  Future<void> _predictMovies() async {
    if (_validVotes == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/recommend'), // Update URL if needed
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'genre': widget.selectedGenre,
          'min_rating': widget.expectedRating,
          'min_votes': _validVotes,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> movies = data['recommendations'];
        print('$movies');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviesListPage(movies: movies),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch movie recommendations.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _validVotes != null && !_isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text('Input Votes for ${widget.selectedGenre} movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please specify your expected average votes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _votesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'e.g. 500',
                errorText:
                    (_votesController.text.isEmpty || _validVotes != null)
                    ? null
                    : 'Please enter a valid non-negative integer',
              ),
              onChanged: _validateVotes,
            ),
            const SizedBox(height: 30),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey.shade400;
                      }
                      return Colors.amberAccent;
                    }),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: isButtonEnabled ? _predictMovies : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Predict'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
