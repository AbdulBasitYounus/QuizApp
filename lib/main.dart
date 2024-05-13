import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/quiz': (context) => QuizPage(),
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/quiz');
          },
          child: Text('Start Quiz'),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<String> _questions = [
    // Math Questions
    "What is 2 + 2?",
    "What is 10 - 5?",
    "What is 3 * 4?",
    // GK Questions
    "Who is the current president of the United States?",
    "What is the capital of France?",
    "What is the largest ocean in the world?",
    // IQ Questions
    "If a quarter and two dimes equal 65 cents, how much is a nickel worth?",
    "A farmer has 17 sheep. All but 9 die. How many are left?",
    "What number comes next in the sequence: 1, 4, 9, 16, ...?",
    // English Grammar Questions
    "She always ___ her homework on time.",
    "I ___ my keys yesterday.",
    "He ___ to the store every day.",
    // Pakistan Studies Questions
    "Who is the founder of Pakistan?",
    "When did Pakistan become an independent country?",
    "What is the national language of Pakistan?",
  ];

  final List<List<String>> _options = [
    // Math Options
    ["4", "5", "6"],
    ["2", "3", "5"],
    ["10", "12", "15"],
    // GK Options
    ["Joe Biden", "Donald Trump", "Barack Obama"],
    ["London", "Berlin", "Paris"],
    ["Atlantic", "Indian", "Pacific"],
    // IQ Options
    ["5 cents", "10 cents", "25 cents"],
    ["8", "9", "17"],
    ["25", "36", "49"],
    // English Grammar Options
    ["do", "does", "did"],
    ["lost", "lose", "loose"],
    ["go", "goes", "gone"],
    // Pakistan Studies Options
    ["Quaid-e-Azam Muhammad Ali Jinnah", "Allama Iqbal", "Sir Syed Ahmed Khan"],
    ["14 August 1947", "23 March 1940", "3 June 1947"],
    ["Urdu", "Punjabi", "Sindhi"],
  ];

  final List<String> _answers = [
    // Math Answers
    "4",
    "5",
    "12",
    // GK Answers
    "Joe Biden",
    "Paris",
    "Pacific",
    // IQ Answers
    "5 cents",
    "9",
    "25",
    // English Grammar Answers
    "does",
    "lost",
    "goes",
    // Pakistan Studies Answers
    "Quaid-e-Azam Muhammad Ali Jinnah",
    "14 August 1947",
    "Urdu",
  ];

  int _currentIndex = 0;
  int _score = 0;
  Map<int, String> _result = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(minutes: 5);
    _timer = Timer(duration, () {
      _timer?.cancel();
      _showResultDialog();
    });
  }

  void _checkAnswer(String answer) {
    if (answer == _answers[_currentIndex]) {
      setState(() {
        _score++;
        _result[_currentIndex] = 'Correct';
        _currentIndex++;
        if (_currentIndex == _questions.length) {
          _timer?.cancel();
          _showResultDialog();
        }
      });
    } else {
      setState(() {
        _result[_currentIndex] = 'Wrong';
        _currentIndex++;
        if (_currentIndex == _questions.length) {
          _timer?.cancel();
          _showResultDialog();
        }
      });
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your score: $_score'),
              SizedBox(height: 10),
              Text('Answers:'),
              DataTable(
                columns: [
                  DataColumn(label: Text('Question')),
                  DataColumn(label: Text('Result')),
                ],
                rows: _result.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(_questions[entry.key])),
                      DataCell(Text(entry.value)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _score = 0;
                _currentIndex = 0;
                _result.clear();
                _startTimer();
              });
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Game'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: _currentIndex < _questions.length
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Score: $_score',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              _questions[_currentIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            ..._options[_currentIndex]
                                .map((option) => ElevatedButton(
                                      onPressed: () => _checkAnswer(option),
                                      child: Text(option),
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                  ],
                ),
              )
            : Text(
                'Quiz Completed! Your score: $_score',
                style: TextStyle(fontSize: 20),
              ),
      ),
    );
  }
}

