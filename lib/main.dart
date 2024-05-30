import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool oTurn = true; // 1st player is O
  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Tic-Tac-Toe'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildScoreColumn('Player X', xScore),
                  _buildScoreColumn('Player O', oScore),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _tapped(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.blueGrey[800],
                    ),
                    child: Center(
                      child: Text(
                        displayElement[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                    ),
                    onPressed: _clearScoreBoard,
                    child: Text(
                      "Clear Score Board",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String player, int score) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          player,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _tapped(int index) {
    setState(() {
      if (oTurn && displayElement[index] == '') {
        displayElement[index] = 'O';
        filledBoxes++;
      } else if (!oTurn && displayElement[index] == '') {
        displayElement[index] = 'X';
        filledBoxes++;
      }

      oTurn = !oTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // Check rows, columns, and diagonals for a winner
    if (_checkLine(0, 1, 2) || _checkLine(3, 4, 5) || _checkLine(6, 7, 8) ||
        _checkLine(0, 3, 6) || _checkLine(1, 4, 7) || _checkLine(2, 5, 8) ||
        _checkLine(0, 4, 8) || _checkLine(2, 4, 6)) {
      return;
    } else if (filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  bool _checkLine(int a, int b, int c) {
    if (displayElement[a] == displayElement[b] &&
        displayElement[a] == displayElement[c] &&
        displayElement[a] != '') {
      _showWinDialog(displayElement[a]);
      return true;
    }
    return false;
  }

  void _showWinDialog(String winner) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("\" " + winner + " \" is the Winner!!!"),
          actions: <Widget>[
            TextButton(
              child: Text("Play Again"),
              onPressed: () {
                _clearBoard();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
  }

  void _showDrawDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Draw"),
          actions: <Widget>[
            TextButton(
              child: Text("Play Again"),
              onPressed: () {
                _clearBoard();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
    });
    filledBoxes = 0;
  }

  void _clearScoreBoard() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard();
    });
  }
}
