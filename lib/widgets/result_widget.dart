import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/letter_tracing_viewmodel.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LetterTracingViewModel>(
      builder: (context, viewModel, child) {
        // Check if any stroke went outside the boundary
        bool hasOutsideBoundary = false;
        for (var result in viewModel.strokeResults) {
          if (result?.isOutsideBoundary ?? false) {
            hasOutsideBoundary = true;
            break;
          }
        }

        // Set the result message based on success and boundary check
        String resultMessage = "Failed";
        if (viewModel.isSuccess) {
          resultMessage = "Success";
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: viewModel.isSuccess ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result message
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.isSuccess ? '🎉' : '😊',
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    resultMessage, // Use the simplified result message
                    style: TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: viewModel.isSuccess
                          ? Colors.green[800]
                          : Colors.red[800],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Add more specific feedback about the tracing
              if (!viewModel.isSuccess)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hasOutsideBoundary
                        ? "Please stay inside the lines and follow the letter path!"
                        : "Make sure you trace the entire letter! Both the curved top and the diagonal leg need to be complete.",
                    style: const TextStyle(
                      fontFamily: 'Comic Sans MS',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 16),

              // Try again or continue button
              ElevatedButton(
                onPressed: () => viewModel.resetTracing(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      viewModel.isSuccess ? Colors.green : Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  viewModel.isSuccess ? 'Next Letter' : 'Try Again',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
