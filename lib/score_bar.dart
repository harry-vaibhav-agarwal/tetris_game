import 'package:flutter/material.dart';
import 'data.dart';
import 'package:provider/provider.dart';

class ScoreBar extends StatefulWidget {
  @override
  _ScoreBarState createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[800],Colors.indigo[500],Colors.indigo[500]]
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text(
                'Score: ${Provider.of<Data>(context,listen: true).score}',
                style:TextStyle(
              fontWeight : FontWeight.bold,
              fontSize: 20,
              color: Colors.white
            )),
        ]
        ),
      ),
    );
  }
}
