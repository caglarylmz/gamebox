import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Cube"),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          width: 500,
          child: _body(context)),
      ),
    );
  }
}

Widget _body(BuildContext context) => GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1,
      children: <Widget>[
        gridChild(context, "assets/tictactoe.jpg","Tic-Tac-Toe","/tictactoe"),
        gridChild(context, "assets/2048_logo.png","2048","/2048"),
      ],
    );

Widget gridChild(BuildContext context, String imagePath,String title, String routeName) => Card(
      elevation: 1.5,
      child: InkWell(
        onTap: (){
           Navigator.pushNamed(context, routeName);
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
