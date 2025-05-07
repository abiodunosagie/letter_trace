// Represents the result of a stroke validation
class StrokeResult {
  final bool isValid;
  final double accuracy;
  final String message;

  StrokeResult({
    required this.isValid,
    required this.accuracy,
    required this.message,
  });

  factory StrokeResult.valid(double accuracy) {
    String message;
    if (accuracy > 0.95) {
      message = "Perfect!";
    } else if (accuracy > 0.9) {
      message = "Great job!";
    } else if (accuracy > 0.8) {
      message = "Good!";
    } else {
      message = "Nice try!";
    }

    return StrokeResult(
      isValid: true,
      accuracy: accuracy,
      message: message,
    );
  }

  factory StrokeResult.invalid(double accuracy) {
    return StrokeResult(
      isValid: false,
      accuracy: accuracy,
      message: "Try again!",
    );
  }
}
