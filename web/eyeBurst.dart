library eyeBurst;

import "animator.dart";
import 'dart:html';
import 'dart:async';
import 'dart:math';

part "stage.dart";
part "eye.dart";
part "gameManager.dart";

String px(num number) {
  return "${number}px";
}

void swap(Eye a, Eye b) {
  var temp = a;
  a = b;
  b = temp;
  temp = a._block;
  a._block = b._block;
  b._block = temp;
}

const int column = 13;
const int row  = 7;
const int size = 66;
const int border = 2;
const int outborder = 8;

List<String> blockColor = ['red', 'yellow', 'blue', 'green', 'purple'];
Animator animator = new Animator();
Random random = new Random();

DivElement parent;