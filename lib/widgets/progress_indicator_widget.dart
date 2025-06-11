import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/letter_tracing_viewmodel.dart';

class StrokeProgressWidget extends StatelessWidget {
  const StrokeProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LetterTracingViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              viewModel.letter.strokeCount,
              (index) => _buildProgressIndicator(context, viewModel, index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, LetterTracingViewModel viewModel, int strokeIndex) {
    // Determine the state of this stroke
    Color color;
    IconData icon;
    String label = '${strokeIndex + 1}';

    if (strokeIndex < viewModel.currentStrokeIndex) {
      // Completed stroke
      final bool isValid =
          viewModel.strokeResults[strokeIndex]?.isValid ?? false;
      color = isValid ? Colors.green : Colors.red;
      icon = isValid ? Icons.check_circle : Icons.error;
    } else if (strokeIndex == viewModel.currentStrokeIndex) {
      // Current stroke
      color = Colors.blue;
      icon = Icons.edit;
    } else {
      // Future stroke
      color = Colors.grey;
      icon = Icons.circle_outlined;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stroke $label',
            style: TextStyle(
              fontFamily: 'Comic Sans MS',
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
