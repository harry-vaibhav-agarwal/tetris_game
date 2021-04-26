import 'package:flutter/material.dart';
import 'package:tetris_game/model/subblock.dart';
import 'dart:math';

enum BlockMovement{
  UP,
  LEFT,
  DOWN,
  RIGHT,
  ROTATE_CLOCKWISE,
  ROTATE_COUNTER_CLOCKWISE
}


class Block{

  List<List<SubBlock>> orientations = List<List<SubBlock>>();
  int x;
  int y;
  int orientationIndex;


  Block(this.orientations,Color color,this.orientationIndex){
    this.color = color;
    x = 3;
    y = -(height);
  }

  get subBlocks{
    return orientations[orientationIndex];
  }

  get color{
    return orientations[0][0].color;
  }

  set color(Color color){
    orientations.forEach((orientation) {
      orientation.forEach((subBlock) {
        subBlock.color = color;
      });
    });
  }

  get width{
    int maxX=0;
    subBlocks.forEach((subBlock){
      if(subBlock.x>maxX){
        maxX= subBlock.x;
      }
    });
    return maxX+1;
  }

  get height{
    int maxY=0;
    subBlocks.forEach((subBlock){
      if(subBlock.y>maxY){
        maxY= subBlock.y;
      }
    });
    return maxY+1;
  }


  void move(BlockMovement type){
    switch(type){
      case BlockMovement.UP : y--;
      break;
      case BlockMovement.DOWN : y++;
      break;
      case BlockMovement.LEFT : x--;
      break;
      case BlockMovement.RIGHT : x++;
      break;
      case BlockMovement.ROTATE_CLOCKWISE : orientationIndex = (orientationIndex+1)%4;
      break;
      case BlockMovement.ROTATE_COUNTER_CLOCKWISE : orientationIndex = (orientationIndex+3)%4;
      break;
    }
  }


}


class IBlock extends Block {
  IBlock(int orientationIndex)
      : super([
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
  ], Colors.red[400], orientationIndex);
}

class JBlock extends Block {
  JBlock(int orientationIndex)
      : super([
    [SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2), SubBlock(0, 2)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(0, 2)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(2, 1)],
  ], Colors.yellow[300], orientationIndex);
}

class LBlock extends Block {
  LBlock(int orientationIndex)
      : super([
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 2)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2)],
    [SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
  ], Colors.green[300], orientationIndex);
}

class OBlock extends Block {
  OBlock(int orientationIndex)
      : super([
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
  ], Colors.blue[300], orientationIndex);
}

class TBlock extends Block {
  TBlock(int orientationIndex)
      : super([
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(1, 1)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
  ], Colors.blue, orientationIndex);
}

class SBlock extends Block {
  SBlock(int orientationIndex)
      : super([
    [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
    [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
  ], Colors.orange[300], orientationIndex);
}

class ZBlock extends Block {
  ZBlock(int orientationIndex)
      : super([
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
  ], Colors.cyan[300], orientationIndex);
}