import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeedPhraseDisplay extends StatelessWidget {
  final String seedPhrase;

  SeedPhraseDisplay({Key? key, required this.seedPhrase}) : super(key: key);

  void _copySeedPhrase(BuildContext context) {
    Clipboard.setData(ClipboardData(text: seedPhrase));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seed phrase copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = seedPhrase.split(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Your Seed Phrase:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(words.length, (index) {
              return Chip(
                labelPadding: const EdgeInsets.all(2.0),
                label: Text('${index + 1}. ${words[index]}'),
                backgroundColor: Colors.grey[200],
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _copySeedPhrase(context),
          child: const Text('Copy Seed Phrase'),
        ),
        const SizedBox(height: 10),
        const Text(
          'Keep this phrase safe and never share it.',
          style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}