import 'package:flutter/material.dart';
import 'score_bar.dart';
import 'game_area.dart';
import 'next_block.dart';
import 'data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(
  ChangeNotifierProvider<Data>(
    create: (context) => Data(),
    child: MyApp(),
  ),
);
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(

      home: Tetris(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class Tetris extends StatefulWidget {
  @override
  _TetrisState createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {

  GlobalKey<GameAreaState> _gameStartKey =GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TETRIS'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            ScoreBar(),
            Expanded(
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex:3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,5,10),
                        child: GameArea(key:_gameStartKey),
                      ),
                    ),
                    Flexible(
                      flex:1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5,10,10,10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NextBlock(),
                            SizedBox(height: 30,),
                            RaisedButton(
                              color: Colors.indigo[700],
                              child: Text(
                                Provider.of<Data>(context,listen: true).isPlaying? 'End'
                                    : 'Start',
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: (){
                                  Provider.of<Data>(context,listen:false).isPlaying ? _gameStartKey.currentState.endGame():_gameStartKey.currentState.startGame();

                              },
                            )
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


