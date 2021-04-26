import 'package:flutter/material.dart';
import 'data.dart';
import 'package:provider/provider.dart';

class NextBlock extends StatefulWidget {
  @override
  _NextBlockState createState() => _NextBlockState();
}

class _NextBlockState extends State<NextBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text('NEXT',style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 5,),
          AspectRatio(aspectRatio: 1,
            child: Container(
              color: Colors.indigo[600],
              child: Center(
                child: Provider.of<Data>(context,listen: true).getNextBlockWidget(),
              ),
           ),
          )

        ],
      ),

    );
  }
}
