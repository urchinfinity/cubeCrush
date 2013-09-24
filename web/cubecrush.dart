import 'dart:html';
import 'dart:async';
import 'block.dart';

void main() { 
  parent = query('#frame');
  createBlocks();
  query('#start').onClick.listen((MouseEvent event) {
    startHtml();
  });
}