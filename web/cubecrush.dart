import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'block.dart';

Random random = new Random();

void main() { 
  parent = query('#frame');
  createBlocks();
  query('#start').onClick.listen((MouseEvent event) {
    startHtml();
  });
}



