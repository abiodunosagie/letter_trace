import 'package:flutter/material.dart';
import 'package:letter_trace/models/letter_a_model.dart';
import 'package:letter_trace/viewmodels/letter_tracing_viewmodel.dart';
import 'package:letter_trace/views/letter_tracing_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LetterTracingViewModel(
            letter: LetterAModel(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Letter Tracing Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple,
          primarySwatch: Colors.purple,
          fontFamily: 'Comic Sans MS',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            primary: Colors.purple,
            secondary: Colors.orange,
            background: Colors.yellow[50]!,
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          useMaterial3: true,
        ),
        home: const LetterTracingScreen(),
      ),
    );
  }
}
