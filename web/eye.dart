part of eyeBurst;

class Eye {
  static const int NORMAL = 0;
  static const int BOMB = 1; /// let eyes around it disappear
  static const int THUNDER = 2;/// let a cross disappear
  static const int COLORCLEAN = 3;///let one color disappear
  static const int BLUE = 11;
  static const int GREEN = 12;
  static const int PURPLE = 13;
  static const int RED = 14;
  static const int YELLOW = 15;
  
  DivElement _block;
  ImageElement _img;
  ImageElement _clickedImg;
  int _status = NORMAL; 
  int colorNum;
  bool count = false;
  
  int posX;
  int posY;
  int top;
  int left;

  Eye (this.colorNum, this.left, this.top) {
  }

  void set status(int special) {
    _status = special;
  }

  int get status {
    return _status;
  }
  
  void beClicked() {
    _img.classes.add('disappear');
    _clickedImg.classes.remove('disappear');
    _block.classes.add('clicked');
  }
  
  void cancelClicked() {
    _img.classes.remove('disappear');
    _clickedImg.classes.add('disappear');
    _block.classes.remove('clicked');
  }

  void swap(Eye another) {
    var temp;
    temp = this._block;
    this._block = another._block;
    another._block = temp;
    temp = this.colorNum;
    this.colorNum = another.colorNum;
    another.colorNum = temp;
    temp = this.status;
    this.status = another.status;
    another.status = temp;
    temp = this._img;
    this._img = another._img;
    another._img = temp;
    temp = this._clickedImg;
    this._clickedImg = another._clickedImg;
    another._clickedImg = temp;
  }  

  equel(Eye another){
    this._block = another._block;
    this.colorNum = another.colorNum;
    this.status = another.status;
    this._img = another._img;
    this._clickedImg = another._clickedImg;
  }

  void destory() {
    if (colorNum == null)
      return;
    print('${_block.runtimeType},$posX,$posY');
    _block.remove();
    _block = null;
    colorNum = null;
    count = false;
    status = NORMAL;
  }

  void addColor(int color) {
    _img = new Element.html('<img src="static/${blockColor[color - 11]}02.png">');
    _clickedImg = new Element.html('<img src="static/${blockColor[color - 11]}Clicked.png">');
    _clickedImg.classes.add('disappear');
    _block.nodes.add(_img);
    _block.nodes.add(_clickedImg);
  }

  bool besideClicked(Eye another) {
    if (this.posX == another.posX && another.posY == this.posY + 1)
      return true;
    if (this.posX == another.posX && another.posY == this.posY - 1)
      return true;
    if (this.posY == another.posY && another.posX == this.posX + 1)
      return true;
    if (this.posY == another.posY && another.posX == this.posX - 1)
      return true;
  return false; 
  }

  void create() {
    _block = new Element.html('<div class="block"></div>');
    parent.nodes.add(_block);
    _block.style.top = px(top);
    _block.style.left = px(left);
    addColor(colorNum);
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
  while(blockNum != column * row) {
    blockNum = checkBlocks();
  }
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
