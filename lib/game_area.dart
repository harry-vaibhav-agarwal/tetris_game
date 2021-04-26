import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:tetris_game/model/block.dart';
import 'dart:math';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:tetris_game/model/subblock.dart';
import 'data.dart';
import 'package:audioplayers/audioplayers.dart';

const int BLOCK_X = 10;
const int BLOCK_Y = 20;
const double SUB_BLOCK_EDGE_WIDTH = 2.0;
const int REFRESH_RATE = 300;
const GAME_AREA_BORDER_WIDTH = 2.0;


enum COLLISION{
  NONE,
  LANDED,
  HIT_WALL,
  HIT_BLOCK,
  LANDED_BLOCK
}

class GameArea extends StatefulWidget {

  GameArea({Key key}) : super(key:key);
  @override
  GameAreaState createState() => GameAreaState();
}



class GameAreaState extends State<GameArea> {

  GlobalKey<GameAreaState> _keyGameArea = GlobalKey();
  Block block;
  bool GameOver= false;
  double subBlockWidth ;
  Timer timer;
  Duration duration = new Duration(milliseconds: REFRESH_RATE);
  List<SubBlock> oldSubBlocks = List<SubBlock>();
  BlockMovement action;
  AudioCache audioCache  = AudioCache();
  AudioPlayer audioPlayer;


  Block getNewBlock(){
    int orientationIndex = Random().nextInt(4);
    int blockType = Random().nextInt(7);
    Block block = null;

    switch(blockType){
      case 0 :
        block  = IBlock(orientationIndex);
        break;
      case 1 :
        block  = JBlock(orientationIndex);
        break;
      case 2 :
        block  = LBlock(orientationIndex);
        break;
      case 3 :
        block  = OBlock(orientationIndex);
        break;
      case 4 :
        block  = TBlock(orientationIndex);
        break;
      case 5 :
        block  = SBlock(orientationIndex);
        break;
      case 6 :
        block  = ZBlock(orientationIndex);
        break;
    }
    return block;
  }

  void startGame() async{
    
    Provider.of<Data>(context,listen:false).setIsPlaying(true);
    Provider.of<Data>(context,listen:false).setScore(0);
    GameOver = false;
    
    audioCache.load('game_sounds/theme.mp3');
    audioPlayer = await audioCache.loop('game_sounds/theme.mp3');

    oldSubBlocks=[];
    RenderBox renderBox  =  _keyGameArea.currentContext.findRenderObject();
    subBlockWidth = (renderBox.size.width - 2 * GAME_AREA_BORDER_WIDTH) / BLOCK_X;
    Provider.of<Data>(context,listen: false).setNextBlock(getNewBlock());
    block = getNewBlock();
    timer = Timer.periodic(duration, onPlay);

  }

  void endGame(){
    audioCache.clearCache();
    if(audioPlayer!=null)
      audioPlayer.stop();
    
    Provider.of<Data>(context,listen:false).setIsPlaying(false);
    timer.cancel();
  }


  bool checkOnEdge(){
    return (action==BlockMovement.LEFT && block.x<=0) || (action==BlockMovement.RIGHT && block.x+block.width >= BLOCK_X) ;
  }

  void onPlay(Timer timer){

    // on Start check the action performed and if permissible perform
   if(block!=null){
     var status = COLLISION.NONE;
     if(action!=null){
       if(!checkOnEdge()) {
         setState(() {
           block.move(action);
         });
       }
     }

     // new block taking old block position then undo the action performed


     for (var oldSubBlock in oldSubBlocks) {
       for (var currentSubBlock in block.subBlocks) {
         var x = block.x + currentSubBlock.x;
         var y = block.y + currentSubBlock.y;

         if (x == oldSubBlock.x && y == oldSubBlock.y) {
           switch (action) {
             case BlockMovement.LEFT:
               block.move(BlockMovement.RIGHT);
               break;
             case BlockMovement.RIGHT:
               block.move(BlockMovement.LEFT);
               break;
             case BlockMovement.ROTATE_CLOCKWISE:
               block.move(BlockMovement.ROTATE_COUNTER_CLOCKWISE);
               break;
             default:
               break;
           }
         }
       }
     }

     // dont't move block down if its landed at bottom
     if(!checkAtBottom()) {

       //dont move block down if block has landed on previous subblock
       if(!checkAboveBlock()) {
         setState(() {
           block.move(BlockMovement.DOWN);
         });
       }
       else {
         status = COLLISION.LANDED_BLOCK;
       }
     }
     else {
       status = COLLISION.LANDED;
     }

     //Game over checking condition
     if(status == COLLISION.LANDED_BLOCK && block.y<=0){
       setState(() {
         GameOver = true;
         audioCache.load('game_sounds/gameover.wav');
         audioCache.play('game_sounds/gameover.wav');
       });

       // endGame();
     }

     //if not GameOver add this block as a subblock and generate new block
     else if(status == COLLISION.LANDED || status == COLLISION.LANDED_BLOCK){
       block.subBlocks.forEach((subBlock){
         subBlock.y += block.y;
         subBlock.x += block.x;
         subBlock.color = block.color;
         oldSubBlocks.add(subBlock);
       });



       block = Provider.of<Data>(context,listen:false).nextBlock;
       Provider.of<Data>(context,listen:false).setNextBlock(getNewBlock());
     }

     //nullify the action performed at last
     action = null;
     updateScore();
   }
  }


  void updateScore(){

    var combo = 1;
    //mapping block y coordinate with count if its same as row count then delete this row
    Map<int,int> rowToCount = Map();

    List<int> rowsTobeRemoved = List();

    oldSubBlocks?.forEach((subblock) {
      rowToCount.update(subblock.y, (value) => ++value ,ifAbsent:()=>1 );
    });



    rowToCount.forEach((key, value) {
      if(value==BLOCK_X){
        Provider.of<Data>(context,listen:false).addScore(combo++);
        rowsTobeRemoved.add(key);
        //print('Score is $score');
      }
    });

    if(rowsTobeRemoved!=null && rowsTobeRemoved.length>0)
      removeRows(rowsTobeRemoved);

  }


  void removeRows(List<int> rowsTobeRemoved){
    audioCache.load('game_sounds/line.wav');
    audioCache.play('game_sounds/line.wav');

    rowsTobeRemoved.sort();
    rowsTobeRemoved.forEach((rowNum) {
      oldSubBlocks.removeWhere((subBlock)=> subBlock.y == rowNum);
      oldSubBlocks.forEach((subblock) {
        if(subblock.y<rowNum)
          subblock.y++;
      });
    });
  }

  bool checkAboveBlock(){
    for(var oldSubBlock in oldSubBlocks){
      for(var subblock in block.subBlocks){
        var x = subblock.x+block.x;
        var y = subblock.y+block.y;

        if(x==oldSubBlock.x && y+1==oldSubBlock.y)
          return true;
      }
    }
    return false;
  }

  bool checkAtBottom(){
    if(block.y + block.height == BLOCK_Y)
      print('I landed');

    return block.y + block.height == BLOCK_Y;
  }

  Widget getPositionedSquareContainer(int x,int y,Color color){
    return Positioned(
      left: x * subBlockWidth,
      top: y*subBlockWidth,
      child: Container(
      width: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
      height: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(const Radius.circular(3.0)),
      ),
    ),
    );
  }

  Widget drawBlocks(){
    if(block==null)
          return null;

    List<Positioned> subBlocks = List();
    block.subBlocks.forEach((subBlock){
      subBlocks.add(getPositionedSquareContainer(
         block.x + subBlock.x,block.y+subBlock.y,block.color
      ));
    });

    oldSubBlocks?.forEach((subBlock) {
      subBlocks.add(getPositionedSquareContainer(subBlock.x, subBlock.y, subBlock.color));
    });

    if(GameOver){
      subBlocks.add(getPositionedGameOverWidget());
      endGame();
    }
    return Stack(
      children: subBlocks,
    );
  }

  Widget getPositionedGameOverWidget(){
    return Positioned(
      left : subBlockWidth * 1,
      top: subBlockWidth *6,
      child: Container(
        child :Center(
          child: Text('GAME OVER',style:TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          )),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width:2.0,color: Colors.indigo[900]),
          gradient: LinearGradient(
            colors: [Colors.red[800],Colors.indigo[500]],
          )
        ),

        width: subBlockWidth *8,
        height: subBlockWidth*3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details){
        if(details.delta.dx>0)
          action = BlockMovement.RIGHT;
        else
          action = BlockMovement.LEFT;
      },
      onTap: (){
        action = BlockMovement.ROTATE_CLOCKWISE;
      },
      child: AspectRatio(
          aspectRatio: BLOCK_X/BLOCK_Y,
          child: Container(
            key: _keyGameArea,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.indigo[800],
              border: Border.all(
                width: 2.0,
                color: Colors.indigoAccent,
              )
            ),
            child:drawBlocks(),
          ),
      ),
    );
  }
}
