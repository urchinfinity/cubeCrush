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

void skill(Eye a) {
  if (a.status == Eye.BOMB) {
    int minX = a.posX - 1;
    int maxX = a.posX + 2;
    int minY = a.posY - 1;
    int maxY = a.posY + 2;
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
        animator.add(new Remover(blocks[i][j]));
        if (blocks[i][j].count == false) {
          stageManager.score += 8888;
          blocks[i][j].count = true;
        }
      }
    }
  } else if (a.status == Eye.THUNDER) {
print("in thunder");
    for (int i = 0; i < column; i++) {
      animator.add(new Remover(blocks[i][a.posY]));
      if (blocks[i][a.posY].count == false) {
        stageManager.score += 8888;
        blocks[i][a.posY].count = true;
      }
    }
    for (int j = 0; j < row; j++) {
       animator.add(new Remover(blocks[a.posX][j]));
      if (blocks[a.posX][j].count == false) {
        stageManager.score += 8888;
        blocks[a.posX][j].count = true;
      }
    }
  } else if (a.status == Eye.COLORCLEAN) {
    int color = a.colorNum;
    for (int i = 0; i < column; i++) {
      for (int j = 0; j < row; j++) {
        if (blocks[i][j].colorNum == color) {
          animator.add(new Remover(blocks[i][j]));
          if (blocks[i][j].count == false) {
            stageManager.score += 10000;
            blocks[i][j].count = true;
          }
        }
      }
    }
  }
}

bool removeChanger(Eye a) {
  int i;
  int color = a.colorNum;
  int start;
  int countX = 0, countY = 0;
  List<Eye> removersX = new List();
  List<Eye> removersY = new List();
print('( ${a.posX}, ${a.posY}): $color');
  for (i = a.posX; i >= 0; i--) {
    if (blocks[i][a.posY].colorNum == null || blocks[i][a.posY].falling == true || blocks[i][a.posY].colorNum != color) {
      break;
    }
    start = i;
    print('( $i, ${a.posY}): ${blocks[i][a.posY].colorNum}');
  }
  print("xtop: $start");
  for (i = start; i < column; i++) {
    if(blocks[i][a.posY].colorNum == null || blocks[i][a.posY].falling || blocks[i][a.posY].colorNum != color) {
      break;
    }
    countX++;
    removersX.add(blocks[i][a.posY]);
  }
print('countX: $countX');
  for (i = a.posY; i >= 0; i--) {
    if (blocks[a.posX][i].colorNum == null || blocks[a.posX][i].falling || blocks[a.posX][i].colorNum != color) {
      break;
    }
    start = i;
    print('( ${a.posX}, ${i}): ${blocks[a.posX][i].colorNum}');
  }
  print("ytop: $start");
  
  for (i = start; i < row; i++) {
    if(blocks[a.posX][i].colorNum == null || blocks[a.posX][i].falling || blocks[a.posX][i].colorNum != color) {
      break;
    }
    countY++;
    removersX.add(blocks[a.posX][i]);
  }
print('countY: $countY');
  if((countX >= 5 && countY >= 3) || (countY >= 5 && countX >= 3)){
    a.status = Eye.COLORCLEAN;

    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));

    return true;

  } else if (countX >= 5 || countY >= 5) {
    a.status = Eye.THUNDER;

    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));

    return true;

  } else if (countX >= 3 && countY >= 3){
    a.status = Eye.BOMB;

    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));

    return true;
  }
  if(countX >= 3 || countY >= 3) {    
    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));

    return true;
  }
  return false;
}