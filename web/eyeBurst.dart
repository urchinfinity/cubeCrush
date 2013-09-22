library eyeBurst;

import "animator.dart";
import 'dart:html';
import 'dart:async';
import 'dart:math';

part "stage.dart";
part "eye.dart";
part "gameManager.dart";
part "eyeBurst_util.dart";

DivElement restartButton;
DivElement hintButton;

String px(num number) {
  return "${number}px";
}
int pxToString(String px) {
  return int.parse(px.substring(0, px.length - 2));
}

void swap(Eye a, Eye b) {
  var temp;
  temp = a._block;
  a._block = b._block;
  b._block = temp;
  temp = a.colorNum;
  a.colorNum = b.colorNum;
  b.colorNum = temp;
  temp = a.status;
  a.status = b.status;
  b.status = temp;
}

const int column = 13;
const int row  = 7;
const int size = 60;
const int border = 8;
const int outborder = 8;

List<String> blockColor = ['red', 'yellow', 'blue', 'green', 'purple'];
Animator animator = new Animator();
Random random = new Random();

DivElement parent;