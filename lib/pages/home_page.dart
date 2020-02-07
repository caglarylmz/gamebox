import 'package:flutter/material.dart';
import 'package:game_box/pages/2048/game_2048.dart';
import 'package:game_box/pages/tic_tac_toe/tic_tac_toe.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Cube"),
      ),
      body: _body(context),
    );
  }
}

Widget _body(BuildContext context) => GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1,
      children: <Widget>[
        gridChild(context, "assets/tictactoe.jpg","Tic-Tac-Toe",MaterialPageRoute(builder: (context)=>TicTacToe())),
        gridChild(context, "assets/tictactoe.jpg","2048",MaterialPageRoute(builder: (context)=>Game2048())),
      ],
    );

Widget gridChild(BuildContext context, String imagePath,String title, MaterialPageRoute materialPageRoute) => Card(
      elevation: 1.5,
      child: InkWell(
        onTap: (){
           Navigator.of(context).push(materialPageRoute);
        },
        radius: 20,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          )),
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white54,
            child: ListTile(
              leading: Icon(Icons.games),
              title: Text(title),
              trailing: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
