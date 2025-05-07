import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/letter_tracing_viewmodel.dart';

class InstructionWidget extends StatelessWidget {
  const InstructionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LetterTracingViewModel>(
      builder: (context, viewModel, child) {
        // Determine the emoji based on the state
        String emoji;
        if (viewModel.isCompleted) {
          emoji = viewModel.isSuccess ? '🎉' : '🤔';
        } else {
          emoji = viewModel.currentStrokeIndex == 0 ? '✏️' : '✨';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: _getBackgroundColor(context, viewModel),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  viewModel.currentInstruction,
                  style: const TextStyle(
                    fontFamily: 'Comic Sans MS',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(
      BuildContext context, LetterTracingViewModel viewModel) {
    if (viewModel.isCompleted) {
      return viewModel.isSuccess ? Colors.green[100]! : Colors.orange[100]!;
    } else {
      return Colors.blue[100]!;
    }
  }
}
