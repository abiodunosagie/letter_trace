import 'package:flutter/material.dart';
import 'package:letter_trace/models/letter_model.dart';
import 'complete_multilingual_letters.dart';
import 'complete_cyrillic_letters.dart';

// Main multilingual letter model implementation
class CodeBasedLetterModel implements LetterModel {
  final String _character;
  final Locale _locale;
  late final LetterDefinition _definition;
  late final List<Path> _strokePaths;

  Offset _offset = Offset.zero;
  double _scale = 1.0;

  CodeBasedLetterModel(String character, Locale locale)
      : _character = character,
        _locale = locale {
    _loadLetterDefinition();
  }

  @override
  String get letter => _character;

  @override
  List<Path> get strokePaths => _strokePaths;

  @override
  List<String> get strokeInstructions {
    String languageCode = _locale.languageCode;

    // Return instructions in user's language, fallback to English
    if (_definition.instructions.containsKey(languageCode)) {
      return _definition.instructions[languageCode]!;
    } else if (_definition.instructions.containsKey('en')) {
      return _definition.instructions['en']!;
    } else {
      return _definition.instructions.values.first;
    }
  }

  @override
  int get strokeCount => _strokePaths.length;

  @override
  double get pathTolerance => _definition.tolerance;

  @override
  double get pathScale => 1.0;

  void _loadLetterDefinition() {
    LetterDefinition? definition;

    // Check if character is Cyrillic
    if (_isCyrillic(_character)) {
      definition = CyrillicLetterPaths.getLetter(_character);
    } else {
      definition = LatinLetterPaths.getLetter(_character);
    }

    if (definition != null) {
      _definition = definition;
      _strokePaths =
          _definition.strokes.map((stroke) => stroke.toPath()).toList();
    } else {
      _createFallbackLetter();
    }
  }

  bool _isCyrillic(String char) {
    int code = char.codeUnitAt(0);
    return (code >= 0x0400 && code <= 0x04FF) ||
        (code >= 0x0500 && code <= 0x052F);
  }

  void _createFallbackLetter() {
    Map<String, List<String>> fallbackInstructions = {
      'en': ['Trace the letter $_character'],
      'de': ['Zeichne den Buchstaben $_character'],
      'uk': ['Намалюйте букву $_character'],
      'sr': ['Нацртајте слово $_character'],
      'ru': ['Нарисуйте букву $_character'],
    };

    _definition = LetterDefinition(
      strokes: [
        LetterStroke(points: [
          Offset(50, 50),
          Offset(150, 50),
          Offset(150, 150),
          Offset(50, 150),
          Offset(50, 50)
        ]),
      ],
      instructions: fallbackInstructions,
    );
    _strokePaths =
        _definition.strokes.map((stroke) => stroke.toPath()).toList();
  }

  @override
  void positionPaths(Size size, Canvas canvas) {
    _scale = (size.height / 300.0).clamp(0.5, 3.0);
    double letterWidth = 160.0 * _scale;
    double letterHeight = 220.0 * _scale;
    double dx = (size.width - letterWidth) / 2;
    double dy = (size.height - letterHeight) / 2;
    _offset = Offset(dx, dy);
    canvas.translate(dx, dy);
    canvas.scale(_scale);
  }

  @override
  Offset globalToLocal(Offset point) {
    double x = (point.dx - _offset.dx) / _scale;
    double y = (point.dy - _offset.dy) / _scale;
    return Offset(x, y);
  }
}

// Factory for creating letters with full language support
class LetterModelFactory {
  static const Map<String, Locale> _supportedLocales = {
    'en': Locale('en', 'US'),
    'de': Locale('de', 'DE'),
    'uk': Locale('uk', 'UA'),
    'sr': Locale('sr', 'RS'),
    'ru': Locale('ru', 'RU'),
  };

  // Create a letter model for any character in any supported language
  static LetterModel createLetter(String character, String languageCode) {
    Locale locale = _supportedLocales[languageCode] ?? const Locale('en', 'US');
    return CodeBasedLetterModel(character, locale);
  }

  // Get all supported language codes
  static List<String> getSupportedLanguages() {
    return _supportedLocales.keys.toList();
  }

  // Get all available characters for a specific language
  static List<String> getAvailableCharacters(String languageCode) {
    switch (languageCode) {
      case 'en':
        return _getEnglishCharacters();
      case 'de':
        return _getGermanCharacters();
      case 'uk':
        return _getUkrainianCharacters();
      case 'sr':
        return _getSerbianCharacters();
      case 'ru':
        return _getRussianCharacters();
      default:
        return _getEnglishCharacters();
    }
  }

  // Check if a character is available in a language
  static bool isCharacterAvailable(String character, String languageCode) {
    List<String> availableChars = getAvailableCharacters(languageCode);
    return availableChars.contains(character);
  }

  // Get a random letter for practice
  static LetterModel getRandomLetter(String languageCode) {
    List<String> chars = getAvailableCharacters(languageCode);
    String randomChar =
        chars[DateTime.now().millisecondsSinceEpoch % chars.length];
    return createLetter(randomChar, languageCode);
  }

  // Character set definitions
  static List<String> _getEnglishCharacters() {
    List<String> chars = [];
    // Uppercase A-Z
    for (int i = 65; i <= 90; i++) {
      chars.add(String.fromCharCode(i));
    }
    // Lowercase a-z
    for (int i = 97; i <= 122; i++) {
      chars.add(String.fromCharCode(i));
    }
    return chars;
  }

  static List<String> _getGermanCharacters() {
    List<String> chars = _getEnglishCharacters();
    chars.addAll(['Ä', 'Ö', 'Ü', 'ä', 'ö', 'ü', 'ß']);
    return chars;
  }

  static List<String> _getUkrainianCharacters() {
    return [
      'А',
      'Б',
      'В',
      'Г',
      'Ґ',
      'Д',
      'Е',
      'Є',
      'Ж',
      'З',
      'И',
      'І',
      'Ї',
      'Й',
      'К',
      'Л',
      'М',
      'Н',
      'О',
      'П',
      'Р',
      'С',
      'Т',
      'У',
      'Ф',
      'Х',
      'Ц',
      'Ч',
      'Ш',
      'Щ',
      'Ь',
      'Ю',
      'Я',
      'а',
      'б',
      'в',
      'г',
      'ґ',
      'д',
      'е',
      'є',
      'ж',
      'з',
      'и',
      'і',
      'ї',
      'й',
      'к',
      'л',
      'м',
      'н',
      'о',
      'п',
      'р',
      'с',
      'т',
      'у',
      'ф',
      'х',
      'ц',
      'ч',
      'ш',
      'щ',
      'ь',
      'ю',
      'я'
    ];
  }

  static List<String> _getSerbianCharacters() {
    return [
      'А',
      'Б',
      'В',
      'Г',
      'Д',
      'Ђ',
      'Е',
      'Ж',
      'З',
      'И',
      'Ј',
      'К',
      'Л',
      'Љ',
      'М',
      'Н',
      'Њ',
      'О',
      'П',
      'Р',
      'С',
      'Т',
      'Ћ',
      'У',
      'Ф',
      'Х',
      'Ц',
      'Ч',
      'Џ',
      'Ш',
      'а',
      'б',
      'в',
      'г',
      'д',
      'ђ',
      'е',
      'ж',
      'з',
      'и',
      'ј',
      'к',
      'л',
      'љ',
      'м',
      'н',
      'њ',
      'о',
      'п',
      'р',
      'с',
      'т',
      'ћ',
      'у',
      'ф',
      'х',
      'ц',
      'ч',
      'џ',
      'ш'
    ];
  }

  static List<String> _getRussianCharacters() {
    return [
      'А',
      'Б',
      'В',
      'Г',
      'Д',
      'Е',
      'Ё',
      'Ж',
      'З',
      'И',
      'Й',
      'К',
      'Л',
      'М',
      'Н',
      'О',
      'П',
      'Р',
      'С',
      'Т',
      'У',
      'Ф',
      'Х',
      'Ц',
      'Ч',
      'Ш',
      'Щ',
      'Ъ',
      'Ы',
      'Ь',
      'Э',
      'Ю',
      'Я',
      'а',
      'б',
      'в',
      'г',
      'д',
      'е',
      'ё',
      'ж',
      'з',
      'и',
      'й',
      'к',
      'л',
      'м',
      'н',
      'о',
      'п',
      'р',
      'с',
      'т',
      'у',
      'ф',
      'х',
      'ц',
      'ч',
      'ш',
      'щ',
      'ъ',
      'ы',
      'ь',
      'э',
      'ю',
      'я'
    ];
  }

  // Helper method to get language name in native script
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'uk':
        return 'Українська';
      case 'sr':
        return 'Srpski';
      case 'ru':
        return 'Русский';
      default:
        return 'Unknown';
    }
  }

  // Get character statistics for a language
  static Map<String, int> getLanguageStats(String languageCode) {
    List<String> chars = getAvailableCharacters(languageCode);
    int uppercase =
        chars.where((c) => c == c.toUpperCase() && c != c.toLowerCase()).length;
    int lowercase =
        chars.where((c) => c == c.toLowerCase() && c != c.toUpperCase()).length;
    int special = chars.length - uppercase - lowercase;

    return {
      'total': chars.length,
      'uppercase': uppercase,
      'lowercase': lowercase,
      'special': special,
    };
  }
}

// Enhanced ViewModel with multi-language support
class MultilingualLetterTracingViewModel extends ChangeNotifier {
  LetterModel? _letterModel;
  String _currentLanguage = 'en';
  String _currentCharacter = 'A';
  int _currentStrokeIndex = 0;
  final List<double> _strokeAccuracies = [];

  // Getters
  LetterModel? get letterModel => _letterModel;
  String get currentLanguage => _currentLanguage;
  String get currentCharacter => _currentCharacter;
  int get currentStrokeIndex => _currentStrokeIndex;
  List<String> get availableCharacters =>
      LetterModelFactory.getAvailableCharacters(_currentLanguage);
  List<String> get supportedLanguages =>
      LetterModelFactory.getSupportedLanguages();

  String get currentInstruction {
    if (_letterModel?.strokeInstructions.isEmpty ?? true) {
      return _getGenericInstruction();
    }
    if (_currentStrokeIndex < _letterModel!.strokeInstructions.length) {
      return _letterModel!.strokeInstructions[_currentStrokeIndex];
    }
    return _getCompletionMessage();
  }

  bool get isLetterComplete =>
      _currentStrokeIndex >= (_letterModel?.strokeCount ?? 0);

  double get overallAccuracy {
    if (_strokeAccuracies.isEmpty) return 0.0;
    return _strokeAccuracies.reduce((a, b) => a + b) / _strokeAccuracies.length;
  }

  // Initialize with a character
  Future<void> initialize({String? character, String? languageCode}) async {
    if (languageCode != null && languageCode != _currentLanguage) {
      await changeLanguage(languageCode);
    }

    if (character != null) {
      await setCharacter(character);
    } else {
      await setCharacter(availableCharacters.first);
    }
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (!LetterModelFactory.getSupportedLanguages().contains(languageCode)) {
      throw ArgumentError('Unsupported language: $languageCode');
    }

    _currentLanguage = languageCode;

    // Reset to first character of new language
    List<String> newChars =
        LetterModelFactory.getAvailableCharacters(languageCode);
    if (newChars.isNotEmpty) {
      await setCharacter(newChars.first);
    }

    notifyListeners();
  }

  // Set character to trace
  Future<void> setCharacter(String character) async {
    if (!LetterModelFactory.isCharacterAvailable(character, _currentLanguage)) {
      throw ArgumentError(
          'Character $character not available in $_currentLanguage');
    }

    _currentCharacter = character;
    _letterModel = LetterModelFactory.createLetter(character, _currentLanguage);
    _resetProgress();
    notifyListeners();
  }

  // Move to next character in current language
  Future<void> nextCharacter() async {
    List<String> chars = availableCharacters;
    int currentIndex = chars.indexOf(_currentCharacter);
    int nextIndex = (currentIndex + 1) % chars.length;
    await setCharacter(chars[nextIndex]);
  }

  // Move to previous character in current language
  Future<void> previousCharacter() async {
    List<String> chars = availableCharacters;
    int currentIndex = chars.indexOf(_currentCharacter);
    int prevIndex = currentIndex > 0 ? currentIndex - 1 : chars.length - 1;
    await setCharacter(chars[prevIndex]);
  }

  // Get random character for practice
  Future<void> getRandomCharacter() async {
    LetterModel randomLetter =
        LetterModelFactory.getRandomLetter(_currentLanguage);
    await setCharacter(randomLetter.letter);
  }

  // Complete current stroke with accuracy score
  void completeStroke(double accuracy) {
    if (!isLetterComplete) {
      _strokeAccuracies.add(accuracy);
      _currentStrokeIndex++;
      notifyListeners();
    }
  }

  // Reset progress for current letter
  void _resetProgress() {
    _currentStrokeIndex = 0;
    _strokeAccuracies.clear();
  }

  // Get generic instruction based on language
  String _getGenericInstruction() {
    switch (_currentLanguage) {
      case 'de':
        return 'Zeichne den Buchstaben $_currentCharacter';
      case 'uk':
        return 'Намалюйте букву $_currentCharacter';
      case 'sr':
        return 'Нацртајте слово $_currentCharacter';
      case 'ru':
        return 'Нарисуйте букву $_currentCharacter';
      default:
        return 'Trace the letter $_currentCharacter';
    }
  }

  // Get completion message based on language
  String _getCompletionMessage() {
    switch (_currentLanguage) {
      case 'de':
        return 'Buchstabe $_currentCharacter fertig! Gut gemacht!';
      case 'uk':
        return 'Букву $_currentCharacter завершено! Молодець!';
      case 'sr':
        return 'Слово $_currentCharacter завршено! Браво!';
      case 'ru':
        return 'Буква $_currentCharacter готова! Отлично!';
      default:
        return 'Letter $_currentCharacter complete! Well done!';
    }
  }

  // Get language statistics
  Map<String, int> getLanguageStats() {
    return LetterModelFactory.getLanguageStats(_currentLanguage);
  }
}

// Main widget for multilingual letter tracing
class MultilingualLetterTracingScreen extends StatefulWidget {
  final String initialLanguage;
  final String? initialCharacter;

  const MultilingualLetterTracingScreen({
    super.key,
    this.initialLanguage = 'en',
    this.initialCharacter,
  });

  @override
  _MultilingualLetterTracingScreenState createState() =>
      _MultilingualLetterTracingScreenState();
}

class _MultilingualLetterTracingScreenState
    extends State<MultilingualLetterTracingScreen> {
  late MultilingualLetterTracingViewModel viewModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewModel = MultilingualLetterTracingViewModel();
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await viewModel.initialize(
      languageCode: widget.initialLanguage,
      character: widget.initialCharacter,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Letter Tracing - ${LetterModelFactory.getLanguageName(viewModel.currentLanguage)}'),
        actions: [
          // Language selector
          DropdownButton<String>(
            value: viewModel.currentLanguage,
            items: viewModel.supportedLanguages
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(LetterModelFactory.getLanguageName(lang)),
                    ))
                .toList(),
            onChanged: (newLang) async {
              if (newLang != null) {
                setState(() {
                  isLoading = true;
                });
                await viewModel.changeLanguage(newLang);
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          // Navigation buttons
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await viewModel.previousCharacter();
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              await viewModel.nextCharacter();
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () async {
              await viewModel.getRandomCharacter();
              setState(() {});
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Current letter display
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Letter: ${viewModel.currentCharacter}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Stroke: ${viewModel.currentStrokeIndex + 1}/${viewModel.letterModel?.strokeCount ?? 0}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      if (viewModel.overallAccuracy > 0)
                        Text(
                          'Accuracy: ${(viewModel.overallAccuracy * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.green),
                        ),
                    ],
                  ),
                ),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    viewModel.currentInstruction,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Letter tracing area
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: viewModel.letterModel != null
                        ? LetterTracingCanvas(
                            letterModel: viewModel.letterModel!,
                            onStrokeComplete: (accuracy) {
                              viewModel.completeStroke(accuracy);
                              setState(() {});

                              if (viewModel.isLetterComplete) {
                                _showCompletionDialog();
                              }
                            },
                          )
                        : const Center(child: Text('Loading letter...')),
                  ),
                ),

                // Language statistics
                Container(
                  padding: const EdgeInsets.all(16),
                  child: _buildLanguageStats(),
                ),
              ],
            ),
    );
  }

  Widget _buildLanguageStats() {
    Map<String, int> stats = viewModel.getLanguageStats();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Total: ${stats['total']}'),
        Text('Uppercase: ${stats['uppercase']}'),
        Text('Lowercase: ${stats['lowercase']}'),
        if (stats['special']! > 0) Text('Special: ${stats['special']}'),
      ],
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Letter Complete!'),
        content: Text(viewModel.currentInstruction),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.nextCharacter();
              setState(() {});
            },
            child: const Text('Next Letter'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.getRandomCharacter();
              setState(() {});
            },
            child: const Text('Random Letter'),
          ),
        ],
      ),
    );
  }
}

// Placeholder for your existing letter tracing canvas
class LetterTracingCanvas extends StatelessWidget {
  final LetterModel letterModel;
  final Function(double) onStrokeComplete;

  const LetterTracingCanvas({
    super.key,
    required this.letterModel,
    required this.onStrokeComplete,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your actual letter tracing canvas implementation
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letterModel.letter,
              style:
                  const TextStyle(fontSize: 120, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate stroke completion with random accuracy
                double accuracy =
                    0.7 + (DateTime.now().millisecondsSinceEpoch % 30) / 100;
                onStrokeComplete(accuracy);
              },
              child: const Text('Simulate Stroke Complete'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Replace this with your actual LetterTracingCanvas',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example widget
class LetterTracingApp extends StatelessWidget {
  const LetterTracingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multilingual Letter Tracing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MultilingualLetterTracingScreen(
        initialLanguage: 'en', // Start with English
        initialCharacter: 'A', // Start with letter A
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
