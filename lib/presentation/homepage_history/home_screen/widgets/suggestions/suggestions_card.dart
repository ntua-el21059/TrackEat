import 'package:flutter/material.dart';
import 'suggestion_item.dart';

class SuggestionsCard extends StatelessWidget {
  const SuggestionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 384),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFBAB2),
                borderRadius: BorderRadius.circular(21),
              ),
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Column(
                children: [
                  SuggestionItem(
                    iconUrl: "https://cdn.builder.io/api/v1/image/assets/c58a58e994c1473bae5fa855bb627c6e/d780757eb4fa5f30c1e12f87e88e6552afb69af0bd25687d01756e2bd09b20dc?apiKey=c58a58e994c1473bae5fa855bb627c6e&",
                    title: "Cut down sweets",
                    subtitle: "Your weekly sugar intake is running a bit high!",
                  ),
                  const SizedBox(height: 5),
                  SuggestionItem(
                    iconUrl: "https://cdn.builder.io/api/v1/image/assets/c58a58e994c1473bae5fa855bb627c6e/3c2223c41e4c57cb625de308b307a1b37bc625e9be1a5c81fb8f37ea848cab40?apiKey=c58a58e994c1473bae5fa855bb627c6e&",
                    title: "Boost your greens, John",
                    subtitle: "adding even a handful can give you extra energy",
                  ),
                  const SizedBox(height: 5),
                  SuggestionItem(
                    iconUrl: "https://cdn.builder.io/api/v1/image/assets/c58a58e994c1473bae5fa855bb627c6e/e7bf60e8ae9e4083c9d64076b3eae2da3ed2bb7a815faf331f29307c3b620eed?apiKey=c58a58e994c1473bae5fa855bb627c6e&",
                    title: "Sip smarter",
                    subtitle: "Swap sugary drinks for water or tea",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Suggestions',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              letterSpacing: -0.26,
            ),
          ),
        ],
      ),
    );
  }
}