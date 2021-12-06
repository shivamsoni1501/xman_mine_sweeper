import 'package:flutter/material.dart';

class MineList{
  late List<int> mines = [];
  MineList(this.mines);
}

class Patches{
  late int w;
  late int length;
  Patches(int width){
    w = width;
    length = w*w;
  }
}