library gameHaha; 

import 'dart:html';
import 'dart:async';
import 'dart:math';

class Block {
  DivElement block;
  DivElement shiftBlock;
  int colorNum;
  int left;
  int top;
  int bomb = 0;
  int thunder = 0;
  int multiColor = 0;
  bool skillOn = false;
  bool count = false;
  List<int> pos = new List(2);  
  Block (this.colorNum, this.left, this.top) {
  }
  
  void disappear() {
    if (this.bomb == 0 && this.thunder == 0 && this.multiColor == 0) {
      this.block.classes.remove(blockColor[this.colorNum]);
      this.block.classes.add('transparent');
      this.colorNum = TRANSPARENT;
    } else if (this.skillOn == false) {
      this.block.classes.add(bombOn[this.bomb]);
      this.block.classes.add(thunderOn[this.thunder]);
      this.block.classes.add(multiColorOn[this.multiColor]);
    } else if (this.skillOn == true) {
      this.skillOn = false;
      if (this.bomb == 1) {
        this.bomb = 0;
        this.bombing();
      } else if (this.thunder == 1) {
        this.thunder = 0;
        this.lightning();
      } else if (this.multiColor == 1) {
        this.multiColor = 0;
        this.oneColorCrushing();
      }
      this.block.classes.remove(bombOn[1]);
      this.block.classes.remove(thunderOn[1]);
      this.block.classes.remove(multiColorOn[1]);
    }
  }
  
  void bombing() {
    int minX = this.pos[0] - 1;
    int maxX = this.pos[0] + 2;
    int minY = this.pos[1] - 1;
    int maxY = this.pos[1] + 2;
    if (minX < 0) {
      minX = 0;
    }
    if (minY < 0) {
      minY = 0;
    }
    if (maxX > column) {
      maxX = column;
    }
    if (maxY > row) {
      maxY = row;
    }
    for (int i = minX; i < maxX; i++) {
      for (int j = minY; j < maxY; j++) {
        blocks[i][j].disappear();
        if (blocks[i][j].count == false) {
          score += cleanTimes;
          blocks[i][j].count = true;
        }
      }
    }
  }
  
  void lightning() {
    for (int i = 0; i < column; i++) {
      blocks[i][this.pos[1]].disappear();
      if (blocks[i][this.pos[1]].count == false) {
        score += cleanTimes;
        blocks[i][this.pos[1]].count = true;
      }
    }
    for (int j = 0; j < row; j++) {
      blocks[this.pos[0]][j].disappear();
      if (blocks[this.pos[0]][j].count == false) {
        score += cleanTimes;
        blocks[this.pos[0]][j].count = true;
      }
    }
  }
  
  void oneColorCrushing() {
    int color = this.colorNum;
    for (int i = 0; i < column; i++) {
      for (int j = 0; j < row; j++) {
        if (blocks[i][j].colorNum == color) {
          blocks[i][j].disappear();
          if (blocks[i][j].count == false) {
            score += cleanTimes;
            blocks[i][j].count = true;
          }
        }
      }
    }
  }
  
  void shiftColor(Block nextBlock) {
    this.block.classes.remove(blockColor[this.colorNum]);
    this.block.classes.remove(bombOn[this.bomb]);
    this.block.classes.remove(thunderOn[this.thunder]);
    this.block.classes.remove(multiColorOn[this.multiColor]);
    this.colorNum = nextBlock.colorNum;
    this.bomb = nextBlock.bomb;
    this.thunder = nextBlock.thunder;
    this.multiColor = nextBlock.multiColor;
    this.skillOn = nextBlock.skillOn;
    this.block.classes.add(blockColor[this.colorNum]);
    this.block.classes.add(bombOn[this.bomb]);
    this.block.classes.add(thunderOn[this.thunder]);
    this.block.classes.add(multiColorOn[this.multiColor]);
  }
  
  //animate of clicked block
  void beClicked() {
    this.block.classes.add('clicked');
  }
  
  void cancelClicked() {
    this.block.classes.remove('clicked');
  }
  
  void exchange(Block another) {
    this.cancelClicked();
    another.cancelClicked();
    int tempColor = this.colorNum;
    int tempBomb = this.bomb;
    int tempThunder = this.thunder;
    int tempMulti = this.multiColor;
    bool tempSkillOn = this.skillOn;
    this.block.classes.remove(blockColor[this.colorNum]);
    this.block.classes.remove(bombOn[this.bomb]);
    this.block.classes.remove(thunderOn[this.thunder]);
    this.block.classes.remove(multiColorOn[this.multiColor]);
    this.colorNum = another.colorNum;
    this.bomb = another.bomb;
    this.thunder = another.thunder;
    this.multiColor = another.multiColor;
    this.skillOn = another.skillOn;
    this.block.classes.add(blockColor[this.colorNum]);
    this.block.classes.add(bombOn[this.bomb]);
    this.block.classes.add(thunderOn[this.thunder]);
    this.block.classes.add(multiColorOn[this.multiColor]);
    another.block.classes.remove(blockColor[another.colorNum]);
    another.block.classes.remove(bombOn[another.bomb]);
    another.block.classes.remove(thunderOn[another.thunder]);
    another.block.classes.remove(multiColorOn[another.multiColor]);
    another.colorNum = tempColor;
    another.bomb = tempBomb;
    another.thunder = tempThunder;
    another.multiColor = tempMulti;
    another.skillOn = tempSkillOn;
    another.block.classes.add(blockColor[another.colorNum]);
    another.block.classes.add(bombOn[another.bomb]);
    another.block.classes.add(thunderOn[another.thunder]);
    another.block.classes.add(multiColorOn[another.multiColor]);
  }
  void addColor(int color) {
    ImageElement img = new Element.html('<img src="static/${blockColor[color]}.png">');
    img.style.width = px(60);
    block.nodes.add(img);
  }

}

class CountBlock {
  int countColumn;
  int countRow;
}

class Flag {
  int x;
  int y;
  int times = 0;
}

const int  RED = 0;  
const int  YELLOW = 1;  
const int  BLUE = 2;  
const int  GREEN = 3;  
const int  PURPLE = 4;  
const int  TRANSPARENT = 5;
const int  BOMB = 6;
const int THUNDER = 7;
const int MULTICOLOR = 8;
const int column = 13;
const int row  = 7;
const int size = 60;
const int border = 8;
int score = 0;

DivElement parent;
Random random = new Random();
List<String> blockColor = ['red', 'yellow', 'blue', 'green', 'purple', 'transparent'];
List<String> bombOn = ['', 'bomb'];
List<String> thunderOn = ['', 'thunder'];
List<String> multiColorOn = ['', 'multiColor'];
List<List<Block>> blocks;
List<Flag> flags = new List(4); 
bool sthClicked = false;

//
bool besideClicked(Block secondClicked) {
  if ((secondClicked.pos[0] == firstClicked.pos[0] && (secondClicked.pos[1] == firstClicked.pos[1] + 1 || secondClicked.pos[1] == firstClicked.pos[1] - 1))
      || (secondClicked.pos[1] == firstClicked.pos[1] && (secondClicked.pos[0] == firstClicked.pos[0] + 1 || secondClicked.pos[0] == firstClicked.pos[0] - 1)))
    return true;
  return false; 
}

Block firstClicked, secondClicked;

//
void createBlocks() {
  blocks = new List(column);
  for (int i = 0; i < column; i++) {
    blocks[i] = new List(row);
    for (int j = 0; j < row; j++) {
      int left = i == 0? border: (i * (size + border) + border);
      int top = j == 0? border: (j * (size + border) + border);
      int color = random.nextInt(5);
      blocks[i][j] = new Block(color, left, top);
      blocks[i][j].pos = [i, j];
    }
  }
  int blockNum = 0;
  while(blockNum != column * row) {
    blockNum = checkBlocks();
  }
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j].block = new Element.html('<div class="block"></div>');
      blocks[i][j].block.style.left = '${blocks[i][j].left}px';
      blocks[i][j].block.style.top = '${blocks[i][j].top}px';
      blocks[i][j].addColor(blocks[i][j].colorNum);
      parent.nodes.add(blocks[i][j].block);
    }
  }
}

//
int checkBlocks() {
  List<List<CountBlock>> countBlocks = findBlocks();
  int blockNum = 0;
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      List<int> newColor = [ 1, 1, 1, 1, 1];
      if ((countBlocks[i][j].countColumn > 2 && countBlocks[i][j].countRow > 2) 
          || countBlocks[i][j].countColumn > 2 || countBlocks[i][j].countRow > 2) {
        if (i > 0)
          newColor[blocks[i-1][j].colorNum] = 0;
        if (j > 0)
          newColor[blocks[i][j-1].colorNum] = 0;
        if (i < column - 1)
          newColor[blocks[i+1][j].colorNum] = 0;
        if (j < row - 1)
          newColor[blocks[i][j+1].colorNum] = 0;
        for (int k = 0; k < 5; k++) {
          if(newColor[k] == 1)
            blocks[i][j].colorNum = k;
        }
      } else {
        blockNum++;
      }
    }
  }
  return blockNum;
}

void findBlocksX (int count, Block clickedBlock) {
  int max = 5;
  flags[count] = new Flag();
  int pos = clickedBlock.pos[0];
  final y = flags[count].y = clickedBlock.pos[1];
  // resize max
  if (pos - 2 < 0) {
    max += pos - 2;
    pos = 2;
  } else if (pos + 2 >= column) {
    max -= pos + 3 - column;
  }
  for (int i = 0; i < max; i++) {
    if (clickedBlock.colorNum == blocks[pos+i-2][y].colorNum) {
      flags[count].times++;
      flags[count].x = pos + i - 2;
    } else {
      if (flags[count].times >= 3) {
        break;
      } else {
        flags[count].times = 0;
      }
    }
  }
}

void findBlocksY (int count, Block clickedBlock) {
  int max = 5;
  flags[count] = new Flag();
  int pos = clickedBlock.pos[1];
  final x = flags[count].x = clickedBlock.pos[0];
  if (pos - 2 < 0) {
    max += pos - 2;
    pos = 2;
  } else if (pos + 2 >= row) {
    max -= pos + 3 - row;
  }
  for (int i = 0; i < max; i++) {
    if (clickedBlock.colorNum == blocks[x][pos+i-2].colorNum) {
      flags[count].times++;
      flags[count].y = pos + i - 2;
    } else {
      if (flags[count].times >= 3) {
        break;
      } else {
        flags[count].times = 0;
      }
    }
  }
}

bool fallingDown() {
  for (int i = 0; i < column; i++) {
    for (int j = row - 1; j >= 0; j--) {
      if (blocks[i][j].colorNum == TRANSPARENT) {
        for (int k = j; k > 0; k--) {
          blocks[i][k].shiftColor(blocks[i][k - 1]);
        }
        Block tempBlock = new Block(random.nextInt(5), 0, 0);
        blocks[i][0].shiftColor(tempBlock);
        break;
      }
    }
  }
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      if (blocks[i][j].colorNum == TRANSPARENT) {
        return false;
      }
    }
  }
  return true;
}

List<List<CountBlock>> findBlocks() {
  List<List<CountBlock>> countBlocks = new List(column);
  for (int i = 0; i < column; i++) {
    countBlocks[i] = new List(row);
    for (int j = 0; j < row; j++) {
      countBlocks[i][j] = new CountBlock();
      if (i == 0) {
        countBlocks[i][j].countColumn = 1;
      }
      if (j == 0) {
        countBlocks[i][j].countRow = 1;
      }
      if (i != 0) {
        if (blocks[i-1][j].colorNum == blocks[i][j].colorNum) {
          countBlocks[i][j].countColumn = countBlocks[i-1][j].countColumn + 1;
        } else {
          countBlocks[i][j].countColumn = 1;
        }
      }
      if (j != 0) {
        if (blocks[i][j-1].colorNum == blocks[i][j].colorNum) {
          countBlocks[i][j].countRow = countBlocks[i][j-1].countRow + 1;
        } else {
          countBlocks[i][j].countRow = 1;
        }
      }
    }
  }
  return countBlocks;
}

int cleanTimes = 1;
bool cleanBlocks() {
  int crushBlocks = 0;
  bool crush = false;
  cleanTimes++;
  List<List<CountBlock>> countBlocks = findBlocks();
  findBomb(countBlocks);
  findCross(countBlocks);
  for (int i = column-1; i >= 0 ; i--) {
    for (int j = row-1; j >= 0; j--) {
      if (countBlocks[i][j].countColumn >= 3) {
        for (int k = 0; k < countBlocks[i][j].countColumn; k++) {
          blocks[i-k][j].disappear();
          crush = true;
          if (blocks[i-k][j].count == false) {
            crushBlocks++;
            blocks[i-k][j].count = true;
          }
        }
      }
      if (countBlocks[i][j].countRow >= 3) {
        for (int k = 0; k < countBlocks[i][j].countRow; k++) {
          blocks[i][j-k].disappear();
          crush = true;
          if (blocks[i][j-k].count == false) {
            crushBlocks++;
            blocks[i][j-k].count = true;
          }
        }
      }
    }
  }
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j].count = false;
      if (blocks[i][j].bomb == 1 || blocks[i][j].thunder == 1 || blocks[i][j].multiColor == 1) {
        blocks[i][j].skillOn = true;
      }
    }
  }
  score += crushBlocks * cleanTimes;
print(score);
  if (crush == false) {
    cleanTimes = 1;
    return false;
  }
  startToClean = false;
  cleanFall = new Timer.periodic(new Duration(milliseconds: 200), (_){
    if (fallingDown()) {
      cleanFall.cancel();
      startToClean = true;
    }
  });
  return true;
}

Timer clean;
Timer cleanFall;
bool startToClean;
void disappearAndFall() {
  while(!(searchLine() || searchBox())) {
    restart();
  }
  findBlocksX(0, firstClicked);
  findBlocksY(1, firstClicked);
  findBlocksX(2, secondClicked);
  findBlocksY(3, secondClicked);
  ///find special blocks
  List<List<CountBlock>> countBlocks = findBlocks();
  findBomb(countBlocks);
  findCross(countBlocks);
  int crushBlocks = 0;
  bool crush = false;
  if (flags[0].times >= 3) {
    for (int i = 0; i < flags[0].times; i++) {
      blocks[flags[0].x-i][flags[0].y].disappear();
      crush = true;
      if (blocks[flags[0].x-i][flags[0].y].count == false) {
        crushBlocks++;
        blocks[flags[0].x-i][flags[0].y].count = true;
      }
    }
  }
  if (flags[1].times >= 3) {
    for (int i = 0; i < flags[1].times; i++) {
      blocks[flags[1].x][flags[1].y-i].disappear();
      crush = true;
      if (blocks[flags[1].x][flags[1].y-i].count == false) {
        crushBlocks++;
        blocks[flags[1].x][flags[1].y-i].count = true;
      }
    }
  }
  if (flags[2].times >= 3) {
    for (int i = 0; i < flags[2].times; i++) {
      blocks[flags[2].x-i][flags[2].y].disappear();
      crush = true;
      if (blocks[flags[2].x-i][flags[2].y].count == false) {
        crushBlocks++;
        blocks[flags[2].x-i][flags[2].y].count = true;
      }
    }
  }
  if (flags[3].times >= 3) {
    for (int i = 0; i < flags[3].times; i++) {
      blocks[flags[3].x][flags[3].y-i].disappear();
      crush = true;
      if (blocks[flags[3].x][flags[3].y-i].count == false) {
        crushBlocks++;
        blocks[flags[3].x][flags[3].y-i].count = true;
      }
    }
  }
  //calculate score
  score += crushBlocks;
print(score);
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j].count = false;
      if (blocks[i][j].bomb == 1 || blocks[i][j].thunder == 1 || blocks[i][j].multiColor == 1) {
        blocks[i][j].skillOn = true;
      }
    }
  }
  /*
  if(crush == false) {
    new Timer(new Duration(milliseconds: 200),(){
      firstClicked.exchange(secondClicked);
    });
    return;
  }
  */
  startToClean = false;
  cleanFall = new Timer.periodic(new Duration(milliseconds: 200), (_){
    if (fallingDown()) {
      cleanFall.cancel();
      startToClean = true;
    }
  });
  clean = new Timer.periodic(new Duration(milliseconds: 1), (_){
    if (startToClean) {
      startToClean = false;
      Timer delayTime = new Timer(new Duration(milliseconds: 200), (){
        if (!cleanBlocks()) {
          clean.cancel();
        }
      });
    }
  });
}

void hint() {
  if (!searchBox(checkOnly: false))
    searchLine(checkOnly: false);
  firstSwitch.beClicked();
  secondSwitch.beClicked();
  new Timer(new Duration(milliseconds: 600),() {
  firstSwitch.cancelClicked();
  secondSwitch.cancelClicked();
  });
}

void restart() {
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j].block.classes.remove(blockColor[blocks[i][j].colorNum]);
      blocks[i][j].block.classes.remove(bombOn[blocks[i][j].bomb]);
      blocks[i][j].block.classes.remove(thunderOn[blocks[i][j].thunder]);
      blocks[i][j].block.classes.remove(multiColorOn[blocks[i][j].multiColor]);
      blocks[i][j].colorNum = random.nextInt(5);
      blocks[i][j].bomb = 0;
      blocks[i][j].thunder = 0;
      blocks[i][j].multiColor = 0;
      blocks[i][j].skillOn = false;
    }
  }
  int blockNum = 0;
  while(blockNum != column * row) {
    blockNum = checkBlocks();
  }
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      blocks[i][j].block.classes.add(blockColor[blocks[i][j].colorNum]);
    }
  }
}

class HintBlock {
  int blockNums;
  int sumI;
  int sumJ;
  
  HintBlock (this.blockNums, this.sumI, this.sumJ) {
  }
  
  void counting (int x, int y) {
    this.blockNums++;
    this.sumI += x;
    this.sumJ += y;
  }
}

Block firstSwitch, secondSwitch;
List<HintBlock> hintBlocks = new List(5);

bool searchBox({bool checkOnly: true}) {
  for (int i = 0; i < column - 2; i++) {
    for (int j = 0; j < row - 1; j++) {
      //count num of each color
      for (int k = 0; k < 5; k++) {
        hintBlocks[k] = new HintBlock(0, 0, 0);
      }
      for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 2; y++) {
          hintBlocks[blocks[i+x][j+y].colorNum].counting(x, y);
        }
      }
      //if one of color > 3, check it
      for (int k = 0; k < 5; k++) {
        if (hintBlocks[k].blockNums == 3) {
          if (hintBlocks[k].sumI == 3) {
            //for hint
            if (!checkOnly) {
              for (int x = 0; x < 3; x++) {
                if (blocks[i+x][j+hintBlocks[k].sumJ-1].colorNum != k) {
                  firstSwitch = blocks[i+x][j];
                  secondSwitch = blocks[i+x][j+1];
                }
              }
            }
            return true;
          }
        } else if (hintBlocks[k].blockNums == 4) {
          for (int x = 0; x < 3; x++) {
            if (blocks[i+x][j].colorNum != k) {
              if (blocks[i+x][j+1] == k) {
                firstSwitch = blocks[i+x][j];
                secondSwitch = blocks[i+x][j+1];
                return true;
              }
            }
          }
        }
      }
    }
  }
  for (int i = 0; i < column - 1; i++) {
    for (int j = 0; j < row - 2; j++) {
      for (int k = 0; k < 5; k++) {
        hintBlocks[k] = new HintBlock(0, 0, 0);
      }
      for (int x = 0; x < 2; x++) {
        for (int y = 0; y < 3; y++) {
          hintBlocks[blocks[i+x][j+y].colorNum].counting(x, y);
        }
      }
      for (int k = 0; k < 5; k++) {
        if (hintBlocks[k].blockNums == 3) {
          if (hintBlocks[k].sumJ == 3) {
            if (!checkOnly) {
              for (int y = 0; y < 3; y++) {
                if (blocks[i+hintBlocks[k].sumI-1][j+y].colorNum != k) {
                  firstSwitch = blocks[i][j+y];
                  secondSwitch = blocks[i+1][j+y];
                }
              }
            }
            return true;
          }
        } else if (hintBlocks[k].blockNums == 4) {
          for (int y = 0; y < 3; y++) {
            if (blocks[i][j+y].colorNum != k) {
              if (blocks[i+1][j+y] == k) {
                firstSwitch = blocks[i][j+y];
                secondSwitch = blocks[i+1][j+y];
                return true;
              }
            }
          }
        }
      }
    }
  }
  return false;
}

bool searchLine({bool checkOnly: true}) {
  for (int i = 0; i < column - 3; i++) {
    for (int j = 0; j < row; j++) {
      for (int k = 0; k < 5; k++) {
        hintBlocks[k] = new HintBlock(0, 0, 0);
      }
      for (int x = 0; x < 4; x++) {
        hintBlocks[blocks[i+x][j].colorNum].counting(x, 0);
      }
      for (int k = 0; k < 5; k++) {
        if (hintBlocks[k].blockNums == 3) {
          if (!checkOnly) {
            for (int x = 0; x < 4; x++) {
              if (blocks[i+x][j].colorNum != k) {
                firstSwitch = blocks[i+x][j];
                if (x == 1) {
                  secondSwitch = blocks[i][j];
                } else if (x == 2) {
                  secondSwitch = blocks[i+3][j];
                }
              }
            } 
          }
          return true;
        }
      }
    }
  }
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row - 3; j++) {
      for (int k = 0; k < 5; k++) {
        hintBlocks[k] = new HintBlock(0, 0, 0);
      }
      for (int y = 0; y < 4; y++) {
        hintBlocks[blocks[i][j+y].colorNum].counting(0, y);
      }
      for (int k = 0; k < 5; k++) {
        if (hintBlocks[k].blockNums == 3) {
          if (!checkOnly) {
            for (int y = 0; y < 4; y++) {
              if (blocks[i][j+y].colorNum != k) {
                firstSwitch = blocks[i][j+y];
                if (y == 1) {
                  secondSwitch = blocks[i][j];
                } else if (y == 2) {
                  secondSwitch = blocks[i][j+3];
                }
              }
            } 
          }
          return true;
        }
      }
    }
  }
  return false;
}


void findBomb(List<List<CountBlock>> countBlocks) {
  for (int i = 2; i < column; i++) {
    for (int j = 0; j < row; j++) {
      if (countBlocks[i][j].countColumn >= 3) {
        int max = j + 3;
        if (max >= row) {
          max = row;
        }
        for (int x = i - countBlocks[i][j].countColumn + 1; x <= i; x++) {
          for (int y = j; y < max; y++) {
            if (countBlocks[x][y].countRow >= 3) {
              blocks[x][j].bomb = 1;
            }
          }
        }
      }
    }
  }
  for (int i = 0; i < column; i++) {
    for (int j = 2; j < row; j++) {
      if (countBlocks[i][j].countRow >= 3) {
        int max = i + 3;
        if (max >= column) {
          max = column;
        }
        for (int x = i; x < max; x++) {
          for (int y = j - countBlocks[i][j].countRow + 1; y <= j; y++) {
            if (countBlocks[x][y].countColumn >= 3) {
              blocks[i][y].bomb = 1;
            }
          }
        }
      }
    }
  }
}

void findCross(List<List<CountBlock>> countBlocks) {
  for (int i = 0; i < column; i++) {
    for (int j = 0; j <row; j++) {
      if (countBlocks[i][j].countColumn == 5) {
        if (blocks[i-2][j].bomb == 1) {
          blocks[i-2][j].bomb = 0;
          blocks[i-2][j].multiColor = 1;
        } else {
          blocks[i-2][j].thunder = 1;
        }
      }
      if (countBlocks[i][j].countRow == 5) {
        if (blocks[i][j-2].bomb == 1) {
          blocks[i][j-2].bomb = 0;
          blocks[i][j-2].multiColor = 1;
        } else {
          blocks[i][j-2].thunder = 1;
        }
      }
    }
  }
}

Timer startTimer, searchTimer;

void startHtml(){
  int i = 3;
  Timer s, ss;
  query('#start').classes.add('disappear');
  DivElement start = query('#num');
  restart();
  start.text = '$i';
  startTimer = new Timer.periodic(new Duration(milliseconds: 800),(_){
    i--;
    if (i == 0) {
      start.text = 'START!!';
    } else if (i == -1) {
      query('#bigShield').classes.add('disappear');
      query('#time').classes.add('timeStart');
      start.classes.add('disappear');
      startEvent();
      startTimer.cancel();
      return;
    } else {
    start.text = '$i';
    }
    restart();
  });
}

void endHtml(){
  for(int i = 0; i < column; i++){
    for(int j = 0; j < row; j++){
      blocks[i][j].block.classes.remove('shakeB');
    }
  }
  query('#bigShield').classes.remove('disappear');
  query('#end').classes.remove('disappear');
}

void restartHtml(){
  if(after55) {
    after55 = false;
    after45 = false;
    for(int i = 0; i < column; i++){
      for(int j = 0; j < row; j++){
        blocks[i][j].block.classes.remove('shakeB');
      }
    }
  } else if (after45) {
    after45 = false;
    for(int i = 0; i < column; i++){
      for(int j = 0; j < row; j++){
        blocks[i][j].block.classes.remove('shake');
      }
    }
  }
  query('#bigShield').classes.remove('disappear');
  query('#start').classes.remove('disappear');
  query('#num').classes.remove('disappear');
  query('#time').classes.remove('timeStart');
}

bool after45 = false;
bool after55 = false;

void startEvent(){
  //searchTimer = new Timer.periodic(new Duration(milliseconds: 1), (_){      
  //  if(!(searchLine() || searchBox())) {
  //    restart();
  //  }
  //  else {
  //    searchTimer.cancel();
  //  }
  //});
  ///shake after 45s
  Timer s = new Timer(new Duration(seconds: 45), (){
    after45 = true;
    for(int i = 0; i < column; i++){
      for(int j = 0; j < row; j++){
        blocks[i][j].block.classes.add('shake');
      }
    }
  });
  ///speed up the shaking V after 55s
  Timer ss = new Timer(new Duration(seconds: 55), (){
    after55 = true;
    for(int i = 0; i < column; i++){
      for(int j = 0; j < row; j++){
        blocks[i][j].block.classes.remove('shake');
        blocks[i][j].block.classes.add('shakeB');
      }
    }
  });
  ///end after 60s
  Timer end = new Timer(new Duration(seconds: 60), (){
    endHtml();
    return;
  });
  parent.onClick.listen((MouseEvent event) {
    List<int> clickPos = new List(4);
    clickPos[0] = (event.page.x - parent.offsetLeft).toInt();
    clickPos[1] = (event.page.y - parent.offsetTop).toInt(); 
    //clickPos[2] = (clickPos[0] / (size + border)).toInt();
    //clickPos[3] = (clickPos[1] / (size + border)).toInt();
    if ((clickPos[2] < column && clickPos[3] < row && clickPos[0] % (size + border) > border && clickPos[1] % (size + border) > border)
        ||(clickPos[2] < column && clickPos[0] % (size + border) > border && clickPos[3] == row && clickPos[3] % (size + border) == 0) 
        ||(clickPos[2] == column && clickPos[0] % (size + border) == 0 && clickPos[3] < row && clickPos[3] % (size + border) > border)) {
     // clickPos[0] = clickPos[2] - (clickPos[2] / column).toInt();
     // clickPos[1] = clickPos[3] - (clickPos[3] / row).toInt();
      if (!sthClicked) {
        sthClicked = true;
        firstClicked = blocks[clickPos[0]][clickPos[1]];
        firstClicked.beClicked();
      } else {
        if (blocks[clickPos[0]][clickPos[1]] == firstClicked) {    // click the same block
          sthClicked = false;
          firstClicked.cancelClicked();
          firstClicked = null;
        } else if (besideClicked(blocks[clickPos[0]][clickPos[1]])) {
          sthClicked = false;
          secondClicked = blocks[clickPos[0]][clickPos[1]];
          secondClicked.beClicked();
          new Timer(new Duration(milliseconds: 200), (){
            secondClicked.exchange(firstClicked);
            disappearAndFall();
          });
        } else {
          firstClicked.cancelClicked();
          firstClicked = blocks[clickPos[0]][clickPos[1]];
          firstClicked.beClicked();
        }
      }
    } else {
      return;
    }
  });
  restartButton = query('.restart');
  hintButton = query('.hint');
  
  restartButton.onClick.listen((MouseEvent evt) {
    while(!(searchLine() || searchBox())) {
      restart();
    }
    restartHtml();
  });
  hintButton.onClick.listen((MouseEvent evt) {
    hint();
  });  
}
String px(num number) {
  return "${number}px";
}


DivElement restartButton;
DivElement hintButton;