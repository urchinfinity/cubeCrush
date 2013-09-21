//import 'dart:html';
//import 'dart:async';
//import 'dart:math';
//import 'block.dart';

import "animator.dart";
import "eyeBurst.dart";

class Foo implements Actor {
  void next(num time) {
    print(">>$time");
  }
}
Animator animator = new Animator();

void main() {
  stageManager.setStage();
}
