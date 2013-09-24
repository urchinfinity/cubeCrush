part of eyeBurst;

class CountBlock {
  int countColumn;
  int countRow;
}

int checkBlocks() {
  List<List<CountBlock>> countBlocks = findBlocks();
  int blockNum = 0;
  for (int i = 0; i < column; i++) {
    for (int j = 0; j < row; j++) {
      List<int> newColor = [ 1, 1, 1, 1, 1];
      if ((countBlocks[i][j].countColumn > 2 && countBlocks[i][j].countRow > 2) 
          || countBlocks[i][j].countColumn > 2 || countBlocks[i][j].countRow > 2) {
        if (i > 0)
          newColor[blocks[i-1][j].colorNum - 11] = 0;
        if (j > 0)
          newColor[blocks[i][j-1].colorNum - 11] = 0;
        if (i < column - 1)
          newColor[blocks[i+1][j].colorNum - 11] = 0;
        if (j < row - 1)
          newColor[blocks[i][j+1].colorNum - 11] = 0;
        for (int k = 0; k < 5; k++) {
          if(newColor[k] == 1)
            blocks[i][j].colorNum = k + 11;
        }
      } else {
        blockNum++;
      }
    }
  }
  return blockNum;
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
        if (blocks[i-1][j].colorNum == blocks[i][j].colorNum  && blocks[i][j].colorNum != null) {
          countBlocks[i][j].countColumn = countBlocks[i-1][j].countColumn + 1;
        } else {
          countBlocks[i][j].countColumn = 1;
        }
      }
      if (j != 0) {
        if (blocks[i][j-1].colorNum == blocks[i][j].colorNum && blocks[i][j].colorNum != null) {
          countBlocks[i][j].countRow = countBlocks[i][j-1].countRow + 1;
        } else {
          countBlocks[i][j].countRow = 1;
        }
      }
    }
  }
  return countBlocks;
}

class Flag {
  int x;
  int y;
  int times = 0;
}
List<Flag> flags = new List(4); 

void findBlocksX (int count, Eye clickedBlock) {
  int max = 5;
  flags[count] = new Flag();
  int pos = clickedBlock.posX;
  final y = flags[count].y = clickedBlock.posY;
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

void findBlocksY (int count, Eye clickedBlock) {
  int max = 5;
  flags[count] = new Flag();
  int pos = clickedBlock.posY;
  final x = flags[count].x = clickedBlock.posX;
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

void findBomb(List<List<CountBlock>> countBlocks) {
  int max;
  for (int i = 2; i < column; i++) {
    for (int j = 0; j < row; j++) {
      if (countBlocks[i][j].countColumn >= 3) {
        max = j + 3;
        if (max >= row) {
          max = row;
        }
        for (int x = i - countBlocks[i][j].countColumn + 1; x <= i; x++) {
          for (int y = j; y < max; y++) {
            if (countBlocks[x][y].countRow >= 3) {
              blocks[x][j].status = Eye.BOMB;
              stageManager.score += 1005;
            }
          }
        }
      }
    }
  }
  for (int i = 0; i < column; i++) {
    for (int j = 2; j < row; j++) {
      if (countBlocks[i][j].countRow >= 3) {
        max = i + 3;
        if (max >= column) {
          max = column;
        }
        for (int x = i; x < max; x++) {
          for (int y = j - countBlocks[i][j].countRow + 1; y <= j; y++) {
            if (countBlocks[x][y].countColumn >= 3) {
              blocks[i][y].status = Eye.BOMB;
              stageManager.score += 1005;
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
        if (blocks[i-2][j].status == Eye.BOMB) {
          blocks[i-2][j].status = Eye.COLORCLEAN;
          stageManager.score += 2005;
        } else {
          blocks[i-2][j].status = Eye.THUNDER;
          stageManager.score += 1005;
        }
      }
      if (countBlocks[i][j].countRow == 5) {
        if (blocks[i][j-2].status == Eye.BOMB) {
          blocks[i][j-2].status = Eye.COLORCLEAN;
          stageManager.score += 2005;
        } else {
          blocks[i][j-2].status = Eye.THUNDER;
          stageManager.score += 1005;
        }
      }
    }
  }
}