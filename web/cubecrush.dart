import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'block.dart';

Random random = new Random();

void main() { 
  parent = query('#frame');
  query('.copyright').style.top = "${window.innerHeight - 120}px";
  query('#outBorder').style.left = "${(window.innerWidth - 952) / 2}px";
  createBlocks();
  query('#start').onClick.listen((MouseEvent event) {
    startHtml();
  });
}



