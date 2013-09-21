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
}

List<List<Eye>> blocks;

void createBlocks() {
  blocks = new List(column);
  for (int i = 0; i < column; i++) {
    blocks[i] = new List(row);
    for (int j = 0; j < row; j++) {
      int left = i == 0? border: (i * (size + border) + border);
      int top = j == 0? border: (j * (size + border) + border);
      int color = random.nextInt(5);
      blocks[i][j] = new Eye(color, left, top);
      blocks[i][j].posX = i;
      blocks[i][j].posY = j;
    }
  }
  int blockNum = 0;
  while(blockNum != column * row) {
   // blockNum = checkBlocks();
  }
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j]._block = new Element.html('<div class="block ${blockColor[blocks[i][j].colorNum - 10]}"></div>');
      blocks[i][j]._block.style.left = '${blocks[i][j].left}px';
      blocks[i][j]._block.style.top = '${blocks[i][j].top}px';
      parent.nodes.add(blocks[i][j]._block);
    }
  }
}
