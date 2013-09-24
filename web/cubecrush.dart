import 'dart:html';
import 'dart:async';
import 'block.dart';

void main() { 
  parent = query('#frame');
  query('.copyright').style.top = "${window.innerHeight - 120}px";
  query('#outBorder').style.left = "${(window.innerWidth - 952) / 2}px";
  query('.output').style.height = "${window.innerHeight - 240}px";
  createBlocks();
  query('#start').onClick.listen((MouseEvent event) {
    startHtml();
  });
}
