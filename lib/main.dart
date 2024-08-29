import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const BasketballApp());
}

class BasketballApp extends StatelessWidget {
  const BasketballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
      ],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _team1Score = 0;
  int _team2Score = 0;
  int? _lastScore;
  bool _isUndoEnabled = false;

  void _incrementScore(int team, int points) {
    setState(() {
      if (team == 1) {
        _team1Score += points;
        _lastScore = points;
      } else {
        _team2Score += points;
        _lastScore = -points;
      }
      _isUndoEnabled = true;
    });
  }

  void _undoLast() {
    if (_isUndoEnabled) {
      setState(() {
        if (_lastScore! > 0) {
          _team1Score -= _lastScore!;
        } else {
          _team2Score += _lastScore!;
        }
        _isUndoEnabled = false;
      });
    }
  }

  void _resetScores() {
    setState(() {
      _team1Score = 0;
      _team2Score = 0;
      _isUndoEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _buildTeamName(localizations.team1),
                    const SizedBox(height: 10),
                    _buildScoreDisplay(_team1Score),
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  'X',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    _buildTeamName(localizations.team2),
                    const SizedBox(height: 10),
                    _buildScoreDisplay(_team2Score),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0, // space between buttons
              runSpacing: 8.0, // space between rows
              alignment: WrapAlignment.center,
              children: [
                _buildScoreButton(
                  label: localizations.freeThrow,
                  onPressed: () => _incrementScore(1, 1),
                ),
                _buildScoreButton(
                  label: localizations.twoPoints,
                  onPressed: () => _incrementScore(1, 2),
                ),
                _buildScoreButton(
                  label: localizations.threePoints,
                  onPressed: () => _incrementScore(1, 3),
                ),
                _buildScoreButton(
                  label: localizations.freeThrow,
                  onPressed: () => _incrementScore(2, 1),
                ),
                _buildScoreButton(
                  label: localizations.twoPoints,
                  onPressed: () => _incrementScore(2, 2),
                ),
                _buildScoreButton(
                  label: localizations.threePoints,
                  onPressed: () => _incrementScore(2, 3),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isUndoEnabled ? _undoLast : null,
                  child: Text(localizations.undo),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetScores,
                  child: Text(localizations.reset),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamName(String teamName) {
    return Text(
      teamName,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildScoreDisplay(int score) {
    return Text(
      '$score',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildScoreButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
