import 'package:flutter/material.dart';
import 'votes_page.dart';
import 'components/next_button.dart';

class RatingPage extends StatefulWidget {
  final String selectedGenre;

  const RatingPage({Key? key, required this.selectedGenre}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final TextEditingController _ratingController = TextEditingController();
  double? _validRating;

  @override
  void dispose() {
    _ratingController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    if (_validRating != null && _validRating! >= 0 && _validRating! <= 5.0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VotesPage(
            selectedGenre: widget.selectedGenre,
            expectedRating: _validRating!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled =
        _validRating != null && _validRating! >= 0 && _validRating! <= 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input your Average Rating for ${widget.selectedGenre} movies',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please specify your expected average rating',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ratingController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g. 3.5',
              ),
              onChanged: (value) {
                setState(() {
                  final input = double.tryParse(value);
                  if (input != null && input >= 0 && input <= 5.0) {
                    _validRating = double.parse(input.toStringAsFixed(1));
                  } else {
                    _validRating = null;
                  }
                });
              },
            ),
            const SizedBox(height: 30),
            NextButton(
              enabled: isButtonEnabled,
              onPressed: _validateAndProceed,
            ),
          ],
        ),
      ),
    );
  }
}
