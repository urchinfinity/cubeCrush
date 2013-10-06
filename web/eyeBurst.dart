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
int pxToInt(String px) {
  return int.parse(px.substring(0, px.length - 2));
}

const int column = 13;
const int row  = 7;
const int size = 60;
const int border = 8;

List<String> blockColor = ['red', 'yellow', 'blue', 'green', 'purple'];
Animator animator = new Animator();
Random random = new Random();

DivElement parent;