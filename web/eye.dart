part of eyeBurst;

class Eye {
  static const int NOEMAL = 0;
  static const int BOMB = 1; /// let eyes around it disappear
  static const int thunder = 2;/// let a cross disappear
  static const int COLORCLEAN = 3;///let one color disappear
  static const int BLUE = 11;
  static const int GREEN = 12;
  static const int PURPLE = 13;
  static const int RED = 14;
  static const int YELLOW = 15;
  
  DivElement _block;
  int status = NOEMAL; 
  int colorNum;
  int posX;
  int posY;
  int top;
  int left;

  Eye (this.colorNum, this.left, this.top) {
  }

  void destory() {
    _block.remove();
    _block == null;
  }

  void addColor(int color) {
    ImageElement img = new Element.html('<img src="static/${blockColor[color - 11]}02.png">');
    img.style.width = px(60);
    _block.nodes.add(img);

  }
}

List<List<Eye>> blocks;

void createBlocks() {
  blocks = new List(column);
  for (int i = 0; i < column; i++) {
    blocks[i] = new List(row);
    for (int j = 0; j < row; j++) {
      int left = i * (size + border) + outborder;
      int top = j * (size + border) + outborder;
      int color = random.nextInt(5) + 11;
      blocks[i][j] = new Eye(color, left, top);
      blocks[i][j].posX = i;
      blocks[i][j].posY = j;
    }
  }
  int blockNum = 0;
 // while(blockNum != column * row) {
   // blockNum = checkBlocks();
  //}
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j]._block = new Element.html('<div class="block"></div>');
      blocks[i][j]._block.style.left = '${blocks[i][j].left}px';
      blocks[i][j]._block.style.top = '${blocks[i][j].top}px';
      blocks[i][j].addColor(blocks[i][j].colorNum);
      parent.nodes.add(blocks[i][j]._block);
    }
  }
}
