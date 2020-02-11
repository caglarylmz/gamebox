import 'package:flutter/material.dart';
import 'package:game_box/pages/tic_tac_toe/components/score_component.dart';
import 'package:game_box/pages/tic_tac_toe/components/status_component.dart';

int currentMoves = 0;
List<String> _board = ['', '', '', '', '', '', '', '', '']; //empty board
String status = '';
String winner = '';
var _gamePageState;
var _boxContainerContext;
String _turn = 'First Move: X';
bool loading = false;

int playerScore = 0;
int botScore = 0;

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  @override
  Widget build(BuildContext context) {
    _gamePageState = this;
    return Scaffold(
      appBar: AppBar(
        title: Text("Playing vs Bot"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About',
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[500]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _BoxContainer(),
              StatusComponent(
                turn: _turn,
              ),
              ScoreComponent(
                playerScore: playerScore,
                botScore: botScore,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _resetGame();
            botScore=0;
            playerScore=0;
          });
        },
        tooltip: 'Restart',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _BoxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _boxContainerContext = context;
    return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Colors.blue),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue[100],
                  blurRadius: 20.0,
                  spreadRadius: 5.0,
                  offset: Offset(0, 0))
            ]),
        child: Center(
            child: GridView.count(
          primary: false,
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            return Box(index);
          }),
        )));
  }
}

class Box extends StatefulWidget {
  final int index;
  Box(this.index);
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  void pressed() {
    print(currentMoves);
    setState(() {
      currentMoves++;
      print(currentMoves);
      if (_checkGame()) {
        finishGameWithWinner(context);
      } else if (currentMoves > 8) {
        finishGameWithDraw(
            'It\'s a Draw', 'Want to try again?', 'Go Back', 'New Game');
      }
      //Sıranın kimde olduğunu Status Widget'de gösteriyoruz
      if (currentMoves % 2 == 0)
        _turn = "Turn: X";
      else
        _turn = "Turn: O";
      _gamePageState.setState(() {});
    });
  }

  @override
  Widget build(context) {
    return MaterialButton(
        padding: EdgeInsets.all(0),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(color: Colors.blue)),
            child: Center(
              child: Text(
                _board[widget.index].toUpperCase(),
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        onPressed: () {
          // kullanıcı X , bot  O olsun
          //loading:false is sıra kullanıcıdadır.
          if (_board[widget.index] == '') {
            if (!loading) {
              _board[widget.index] = 'x';
              //kullanıcı hamlesini yapınca loading true yapıyoruz ve sıra bota geçiyor
              loading = true;
              //eğer hamle sayısı 9'dan küçükse bestmove() fonksiyonunu çağırıyoruz botun hamlesi için
              if (currentMoves < 8) _bestMove(_board);
            }
            pressed();
          }
        });
  }
}

//------------------------------ Alerts Dialog --------------------------------------
/* checkGame==true ise  oyunu bitirir ve bir alert dialog ile kullanıya yeni oyun veya çıkış sorulur.
 * eğer result: true ise resetGame() ile yeni oyun başlatılır, false ise ana ekrana dönülür. 
 */
finishGameWithWinner(BuildContext context) async {
  bool result = await _showAlertBox(_boxContainerContext, '$winner won!',
      'Start a new Game?', 'Exit', 'New Game');
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  } else {
    _resetGame();
    playerScore=0;
    botScore=0;
    Navigator.popAndPushNamed(context, "/");
  }
}

//Eğer oyun berabere bitmiş ise
finishGameWithDraw(
    String title, String content, String btn1, String btn2) async {
  bool result =
      await _showAlertBox(_boxContainerContext, title, content, btn1, btn2);
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
      
    });
  }
}

//Alert dialog for finish game
Future<bool> _showAlertBox(BuildContext context, String title, String content,
    String btn1, String btn2) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _context) => AlertDialog(
            title: Text(title.toUpperCase()),
            content: Text(content),
            actions: <Widget>[
              RaisedButton(
                color: Colors.white,
                child: Text(btn1),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              RaisedButton(
                color: Colors.white,
                child: Text(btn2),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ));
}

/*
* Kazanan var mı kontrol ediyoruz: 
* @true : Oyun bitti. winner kazandı
* @false: Oyun devam ediyor
*/
bool _checkGame() {
  //satır kontrol
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      if (winner == "o") botScore++;
      if (winner == "x") playerScore++;
      return true;
    }
  }
  //sütun kontrol
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      if (winner == "o") botScore++;
      if (winner == "x") playerScore++;
      return true;
    }
  }
  // Köşegen kontrol
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    if (winner == "o") botScore++;
    if (winner == "x") playerScore++;
    return true;
  }
  return false;
}

//Oyun bittiğinde hamle ve kutuları sıfırlıyoruz
void _resetGame() {
  currentMoves = 0;
  status = '';
  _board = ['', '', '', '', '', '', '', '', ''];
  _turn = 'First Move: X';
  loading = false;
}

//------------------------------ MIN-MAX ------------------------------------------
/*
 * Temel olarak sıfır toplamlı bir oyunda (zero sum game), yani birisinin  kaybının başka 
 * birisinin kazancı olduğu (veya tam tersi) oyunlarda karar vermek için kullanılışlıdırlar.
 * Burada rakibin oyunu minimize bilgisayarın ki ise maximize edilmeye çalışılır. Hamle sayısı sınırlı (max 9) 
 * olduğundan 0'dan 9'a en iyi hamle öngörülebilir. 
 */

String player = 'x', bot = 'o';
//hamle şansı var mı? tüm hücreleri kontrol ediyoruz

bool isMovesLeft(List<String> _board) {
  int i;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') return true;
  }
  return false;
}

//hamle esnasında kazanan var mı kontrol ediyoruz. bot'sa 10  pc ise -10 yoksa 0 dönüyoruz
int _eval(List<String> _board) {
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      return (winner == bot) ? 10 : -10;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      return (winner == bot) ? 10 : -10;
    }
  }
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    return (winner == bot) ? 10 : -10;
  }
  return 0;
}

/* En iyi Hamleyi bulma 
 * Bu işlev minimax () kullanarak tüm kullanılabilir hareketleri değerlendirir ve daha sonra maksimize edicinin 
 * yapabileceği en iyi hareketi döndürür.
 */
int _bestMove(List<String> _board) {
  int bestMove = -1000, moveVal;
  int i, bi;

  for (i = 0; i < 9; i++) {
    if (_board[i] == '') {
      moveVal = -1000;
      //player'ın oyanayacağı hamle
      _board[i] = bot;
      //Bu hamlenin score'u hesaplanıyor
      moveVal = minmax(_board, 0, false);
      //hamle geri alınıyor
      _board[i] = '';
      //eğer hesaplanan değer -1000'den büyükse bu değer maximize edilen değer oluyor
      if (moveVal > bestMove) {
        bestMove = moveVal;
        bi = i;
      }
    }
  }
  //bi artık maximize edilen hücre. Buraya oynamak gerekiyor. Biz bot'ı maximize ettik(pc) bu hücreye x gelir
  //state değişecek setState'i çağırıyoruz sıra kullanıcıya geçeceğinden loading: false yapıyoruz
  _board[bi] = bot;
  _gamePageState.setState(() {});
  loading = false;
  _turn = 'Turn: X';
  currentMoves++;

  return bestMove;
}

//minmax fonksiyonu. Verilen board listesini özyinelemeli olarak kontrol ediyoruz.
//isMax: Maximize'mi Minimize'mi durumunu seçiyor. isMax=true ise Maximize ediyoruz.
int minmax(List<String> _board, int depth, bool isMax) {
  //score hesaplayalım
  int score = _eval(_board);
  //print(score);
  int bestValue = 0, i;

  //10 veya -10 ise kazanan vardır. Oyun sonu
  if (score == 10 || score == -10) return score;
  //hamle yoksa 0 dönmeliyiz. Beraberlik durumu
  if (!isMovesLeft(_board)) return 0;

//maximize ediyoruz
  if (isMax) {
    bestValue = -1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = bot;
        bestValue = max(bestValue, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    return bestValue;
    //player'ın hamlesini minimize ediyoruz
  } else {
    bestValue = 1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = player;
        bestValue = min(bestValue, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    //print(best);
    //en iyi değeri dönüyoruz
    return bestValue;
  }
}

int max(int a, int b) {
  return a > b ? a : b;
}

int min(int a, int b) {
  return a < b ? a : b;
}
