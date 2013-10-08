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
              blocks[x][j].setSpecial(Eye.BOMB);
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
              blocks[i][y].setSpecial(Eye.BOMB);
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
          blocks[i-2][j].setSpecial(Eye.COLORCLEAN);
          stageManager.score += 2005;
        } else {
          blocks[i-2][j].status = Eye.THUNDER;
          blocks[i-2][j].setSpecial(Eye.THUNDER);
          stageManager.score += 1005;
        }
      }
      if (countBlocks[i][j].countRow == 5) {
        if (blocks[i][j-2].status == Eye.BOMB) {
          blocks[i][j-2].status = Eye.COLORCLEAN;
          blocks[i][j-2].status = Eye.COLORCLEAN;
          stageManager.score += 2005;
        } else {
          blocks[i][j-2].status = Eye.THUNDER;
          blocks[i][j-2].status = Eye.THUNDER;
          stageManager.score += 1005;
        }
      }
    }
  }
}

void skill(Eye a) {
print('(${a.posX},${a.posY})${a.status}');
  if (a.status == Eye.BOMB) {
    animator.add(new Boon(a));
  } else if (a.status == Eye.THUNDER) {
    animator.add(new Hoooon(a));
  }
}


bool removeChanger(Eye a) {
  int i;
  int color = a.colorNum;
  int start;
  int countX = 0, countY = 0;
  List<Eye> removersX = new List();
  List<Eye> removersY = new List();
  for (i = a.posX; i >= 0; i--) {
    if (blocks[i][a.posY].colorNum == null || blocks[i][a.posY].falling == true || blocks[i][a.posY].colorNum != color) {
      break;
    }
    start = i;
  }
  for (i = start; i < column; i++) {
    if(blocks[i][a.posY].colorNum == null || blocks[i][a.posY].falling || blocks[i][a.posY].colorNum != color) {
      break;
    }
    countX++;
    removersX.add(blocks[i][a.posY]);
  }
  for (i = a.posY; i >= 0; i--) {
    if (blocks[a.posX][i].colorNum == null || blocks[a.posX][i].falling || blocks[a.posX][i].colorNum != color) {
      break;
    }
    start = i;
  }
  
  for (i = start; i < row; i++) {
    if(blocks[a.posX][i].colorNum == null || blocks[a.posX][i].falling || blocks[a.posX][i].colorNum != color) {
      break;
    }
    countY++;
    removersX.add(blocks[a.posX][i]);
  }
  if((countX >= 5 && countY >= 3) || (countY >= 5 && countX >= 3)){
    a.status = Eye.COLORCLEAN;
    a.setSpecial(Eye.COLORCLEAN);

    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));

    animator.add(new OpenSkillOn());
    return true;

  } else if (countX >= 5 || countY >= 5) {
    a.status = Eye.THUNDER;
    a.setSpecial(Eye.THUNDER);

    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));
    
    animator.add(new OpenSkillOn());
    return true;

  } else if (countX >= 3 && countY >= 3){
    a.status = Eye.BOMB;
    a.setSpecial(Eye.BOMB);

    for(final eye in removersX)
      animator.add(new Remover(eye));
    for(final eye in removersY)
      animator.add(new Remover(eye));

    animator.add(new OpenSkillOn());
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

class Boon implements Actor {
  int minX;
  int maxX;
  int minY;
  int maxY;
  int addNum;
  int times = 0;
  Eye a;
  
  Boon(Eye _a) {
    minX = _a.posX - 1 <= 0 ? 0: _a.posX - 1;
    maxX = _a.posX + 2 >= column ? column: _a.posX + 2;
    minY = _a.posY - 1 <= 0 ? 0: _a.posY - 1;
    maxY = _a.posY + 2 >= row ? row: _a.posY + 2;
    addNum = size + border;
    a = _a;
  }
  
  void next(num time){
    if(times == 9) {
      for (int i = minX; i < maxX; i++) {
        for (int j = minY; j < maxY; j++) {
          if (blocks[i][j].count == false) {
            stageManager.score += 8888;
            blocks[i][j].count = true;
          }
          blocks[i][j].destory();
        }
      }
      animator.remove(this);
    } else if (times == 0){
      a._block.classes.add('frontest');
    } else if (times == 7){
      a._block.style.top = px(a.top - (size +border));
      a._block.style.left = px(a.left - (size +border));
      a._block.style.width = px(3 * size + 2 * border);
      a._block.style.height = px(3 * size + 2 * border);
    } else if(times < 7) {
      addNum = addNum ~/ 2;
      a._block.style.top = px(a.top - addNum);
      a._block.style.left = px(a.left - addNum);
      a._block.style.width = px(size + 2 * addNum);
      a._block.style.height = px(size + 2 * addNum);
    }
    times++;
  }
}

class Hoooon implements Actor {
  int times = 0;
  Eye a;

  Hoooon(Eye _a) {
    a = _a;
  }
 void next(num time) {
  animator.remove(this);
  return;
 }
//  for (int i = 0; i < column; i++) {
//    animator.add(new Remover(blocks[i][a.posY]));
//    if (blocks[i][a.posY].count == false) {
//      stageManager.score += 8888;
//      blocks[i][a.posY].count = true;
//    }
//  }
//  for (int j = 0; j < row; j++) {
//     animator.add(new Remover(blocks[a.posX][j]));
//    if (blocks[a.posX][j].count == false) {
//      stageManager.score += 8888;
//      blocks[a.posX][j].count = true;
//    }
//  }
}

class CleanColor implements Actor {
  int color;
  int times = 0;
  Eye a;
  
  CleanColor(int _color, Eye _a) {
    color = _color;
    a = _a;
  }

  void next(num time) {
    if(times == 9) {
      a.destory();
      for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
          if (blocks[i][j].colorNum == color) {
            blocks[i][j].destory();
            if (blocks[i][j].count == false) {
              stageManager.score += 10000;
              blocks[i][j].count = true;
            }
          }
        }
      }
      animator.remove(this);
    }
    if (times == 0) {
      for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
          if (blocks[i][j].colorNum == color) {
            blocks[i][j]._img.classes.add('rotateToDispear');
          }
        }
      }
      a._img.classes.add('rotateToDispear');
    }
    times ++;
  }
}