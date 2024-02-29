import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum enTurn { X, O }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  enTurn turn = enTurn.X;
  List<String> _list = List.generate(9, (index) => '');
  List<int> _winners = [];

  int _filledBoxes = 0;
  static const int _maxSeconds = 25;
  int _seconds = _maxSeconds;

  bool gameOver = false;
  bool isFirstGame = true;
  Timer? timer;
  int xScore = 0;
  int oScore = 0;

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    timer!.cancel();
    gameOver = true;
    _seconds = _maxSeconds;
  }

  String getTurn() {
    if (turn == enTurn.X) {
      turn = enTurn.O;
      return 'X';
    }

    turn = enTurn.X;
    return 'O';
  }

  @override
  Widget build(BuildContext context) {
    double scoresSize = 35;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'X Score',
                      style: GoogleFonts.acme(fontSize: scoresSize),
                    ),
                    Text(
                      xScore.toString(),
                      style: GoogleFonts.acme(fontSize: scoresSize),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'O Score',
                      style: GoogleFonts.acme(fontSize: scoresSize),
                    ),
                    Text(
                      oScore.toString(),
                      style: GoogleFonts.acme(fontSize: scoresSize),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
                child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                            mainAxisExtent: 120),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _tapped(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 0.1),
                            color: _winners.contains(index)
                                ? Colors.green
                                : Colors.amber,
                          ),
                          child: Center(
                            child: Text(
                              _list[index],
                              style: GoogleFonts.acme(fontSize: 100),
                            ),
                          ),
                        ),
                      );
                    })),
          ),
          Expanded(
            flex: 1,
            child: Center(child: _timerOrButton()),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    if (!gameOver && !isFirstGame) {
      if (_list[index] == '') {
        _list[index] = getTurn();
        _winningEvent(index);
        _filledBoxes++;
        if (_filledBoxes == _list.length && !gameOver) {
          _drawEvent();
        }

        setState(() {});
      }
    }
  }

  bool _isValuesEqual(String a, String b, String c) {
    return ((a != '' && a == b) && b == c);
  }

  bool _isThereAWinner() {
    if (_isValuesEqual(_list[0], _list[1], _list[2])) {
      _winners = [0, 1, 2];
      return true;
    }
    if (_isValuesEqual(_list[3], _list[4], _list[5])) {
      _winners = [3, 4, 5];
      return true;
    }
    if (_isValuesEqual(_list[6], _list[7], _list[8])) {
      _winners = [6, 7, 8];
      return true;
    }
    if (_isValuesEqual(_list[0], _list[3], _list[6])) {
      _winners = [0, 3, 6];
      return true;
    }
    if (_isValuesEqual(_list[1], _list[4], _list[7])) {
      _winners = [1, 4, 7];
      return true;
    }
    if (_isValuesEqual(_list[2], _list[5], _list[8])) {
      _winners = [2, 5, 8];
      return true;
    }
    if (_isValuesEqual(_list[0], _list[4], _list[8])) {
      _winners = [0, 4, 8];
      return true;
    }
    if (_isValuesEqual(_list[2], _list[4], _list[6])) {
      _winners = [2, 4, 6];
      return true;
    }

    return false;
  }

  void _winningEvent(int index) {
    if (_isThereAWinner()) {
      if (turn == enTurn.O)
        xScore++;
      else
        oScore++;

      _stopTimer();
    }
  }

  void _drawEvent() {
    _stopTimer();
  }

  void _playAgainButton() {
    gameOver = false;
    _startTimer();
    turn = enTurn.X;
    _filledBoxes = 0;
    for (int i = 0; i < _list.length; i++) {
      _list[i] = '';
    }

    isFirstGame = false;

    _winners = [];

    setState(() {});
  }

  Widget _timerOrButton() {
    if (timer != null) {
      return timer!.isActive ? _timer() : _button();
    }
    return _button();
  }

  Widget _timer() {
    return Stack(
      children: [
        Text(
          _seconds.toString(),
          style: GoogleFonts.acme(fontSize: 45),
        ),
      ],
    );
  }

  Widget _button() {
    return ElevatedButton(
        onPressed: () {
          _playAgainButton();
        },
        child: Text(
          isFirstGame ? 'Start' : 'Play again',
          style: GoogleFonts.acme(fontSize: 60),
        ));
  }
}
