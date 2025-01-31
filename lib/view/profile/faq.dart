import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFAQItem(
            question: 'How can I book an event?',
            answer: 'You can book an event by selecting an event and completing the payment process.',
          ),
          _buildFAQItem(
            question: 'Can I cancel my booking?',
            answer: 'Currently, we do not support booking cancellations. Please contact support for further assistance.',
          ),
          _buildFAQItem(
            question: 'How can I contact support?',
            answer: 'You can contact support by going to the Contact Support page in Help and Support.',
          ),
          _buildFAQItem(
            question: 'Are there any hidden fees?',
            answer: 'No, the price displayed on the event page is the final amount you will pay.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.grey[900],
      backgroundColor: Colors.grey[850],
      title: Text(
        question,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
