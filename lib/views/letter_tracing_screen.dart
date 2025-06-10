import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/letter_tracing_viewmodel.dart';
import '../widgets/instruction_widget.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/result_widget.dart';
import 'letter_painter.dart';

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({super.key});

  @override
  State<LetterTracingScreen> createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen> {
  // Reference to the drawing area
  final GlobalKey _drawingAreaKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trace the Letter ${Provider.of<LetterTracingViewModel>(context).letter.letter}',
          style: const TextStyle(
            fontFamily: 'Comic Sans MS',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Instructions widget
              const InstructionWidget(),

              // Drawing area
              Expanded(
                child: _buildDrawingArea(context),
              ),

              // Progress indicators or results
              Consumer<LetterTracingViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isCompleted) {
                    return const ResultWidget();
                  } else {
                    return const StrokeProgressWidget();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawingArea(BuildContext context) {
    return Consumer<LetterTracingViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Set the canvas size in the viewmodel
              viewModel.setCanvasSize(
                  Size(constraints.maxWidth, constraints.maxHeight));

              return GestureDetector(
                onPanStart: viewModel.isCompleted
                    ? null
                    : (details) {
                        RenderBox? renderBox = _drawingAreaKey.currentContext
                            ?.findRenderObject() as RenderBox?;
                        if (renderBox != null) {
                          Offset localPosition =
                              renderBox.globalToLocal(details.globalPosition);
                          viewModel.startStroke(localPosition);
                        }
                      },
                onPanUpdate: viewModel.isCompleted
                    ? null
                    : (details) {
                        RenderBox? renderBox = _drawingAreaKey.currentContext
                            ?.findRenderObject() as RenderBox?;
                        if (renderBox != null) {
                          Offset localPosition =
                              renderBox.globalToLocal(details.globalPosition);
                          viewModel.updateStroke(localPosition);
                        }
                      },
                onPanEnd:
                    viewModel.isCompleted ? null : (_) => viewModel.endStroke(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomPaint(
                    key: _drawingAreaKey,
                    painter: LetterPainter(
                      letterModel: viewModel.letter,
                      strokes: viewModel.strokes,
                      strokeResults: viewModel.strokeResults,
                      currentStrokeIndex: viewModel.currentStrokeIndex,
                      canvasSize:
                          Size(constraints.maxWidth, constraints.maxHeight),
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
