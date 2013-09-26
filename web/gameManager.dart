part of eyeBurst;

GameManager gameManager = new GameManager();
ControlFaller controlFaller = new ControlFaller();

class GameManager implements Actor {
  bool end = false;
  bool executing = false;
  bool falling = false;
  int shakeTimes = 0;
  
  //check
  int cleanTimes = 1;

  bool controlremover() {
    int crushBlocks = 0;
    bool crush = false;
print('first: $crush');
    cleanTimes++;
    List<List<CountBlock>> countBlocks = findBlocks();
    //put bomb
    findBomb(countBlocks);
    //put thunder and colocClean
    findCross(countBlocks);
    for (int i = column - 1; i >= 0 ; i--) {
      for (int j = row - 1; j >= 0; j--) {
        if (countBlocks[i][j].countColumn >= 3) {
          for (int k = 0; k < countBlocks[i][j].countColumn; k++) {
print("add remover ${i-k},$j");
            if (blocks[i-k][j].skillOn) {
              skill(blocks[i-k][j]);
            }
            animator.add(new Remover(blocks[i-k][j]));
            crush = true;
            /// count score
            if (!blocks[i-k][j].count) {
              crushBlocks++;
              blocks[i-k][j].count = true;
            }
          }
        }
        if (countBlocks[i][j].countRow >= 3) {
          for (int k = 0; k < countBlocks[i][j].countRow; k++) {
print("add remover ${i},${j-k}");
            if (blocks[i-k][j].skillOn) {
              skill(blocks[i-k][j]);
            }
            animator.add(new Remover(blocks[i][j-k]));
            crush = true;
            //count score
            if (!blocks[i][j-k].count) {
              crushBlocks++;
              blocks[i][j-k].count = true;
            }
          }
        }
      }
    }
    animator.add(new OpenSkillOn());
    stageManager.score +=  crushBlocks * cleanTimes * 100;
print('$crush');
    return crush;
  }

  void next(num time) {
    if (stageManager.stage == 0) {
      animator.add(new startor());
      stageManager.stage++;
    } //else if (end){
      //output
    //} else {
      //if (time >= 64000){
      //  query('#bigShield').classes.remove('disappear');
      //  //end = true;
      //} else if (time >= 48000){
      //  //shake
      //  if(shakeTimes > 3) {
      //    for(int i = 0; i < column; i++){
      //      for(int j = 0; j < row; j++){
      //        if(blocks[i][j].colorNum != null) {
      //          blocks[i][j]._block.classes.add('shake');
      //        }
      //      }
      //    }
      //    shakeTimes = 0;
      //  } else
      //    shakeTimes++;
      //}
    //}
    if (executing) {
      falling = true;
      controlFaller.findfall();
      executing = false;
    }
  }
}

class Changer implements Actor {
  static const int UP = 0;
  static const int LEFT = 1;
  Eye a;//which is up or left one
  Eye b;
  int wholeTime;
  int direction;
  double velocity;
  num firstCall;
  int changeTimes = 0;

  Changer(int milliseconds) {
    wholeTime = milliseconds;
    velocity = (size + border) / milliseconds;
  }

  void _pickEyes(Eye _a, Eye _b){
    if((_a.posX - _b.posX) > 0) { // a is right
      direction = LEFT;
      a = _b;
      b = _a;
    } else if ((_a.posX - _b.posX) < 0) { // a is left
      direction = LEFT;
      a = _a;
      b = _b;
    } else if ((_a.posY - _b.posY) > 0) { // a is down
      direction = UP;
      a = _b;
      b = _a;
    } else { // a is up
      direction = UP;
      a = _a;
      b = _b;
    }
  }
  void report(){
    if (!gameManager.controlremover()) {
      print('failed');
      if(changeTimes == 1){
        print('remove changer');
        animator.remove(this);
        return;
      }
      changeTimes++;
      _pickEyes(a, b);
      firstCall = null;
    } else {
      print('remove changer');
      animator.remove(this);
      gameManager.executing = true;
    }
  }
  void next(num time){
    if (firstCall == null){
      firstCall = time;
    }
    if (time - firstCall >= wholeTime) {
      if (direction == UP) {
        a._block.style.top = px(a.top + (border + size));
        b._block.style.top = px(b.top - (border + size));
      } else {
        a._block.style.left = px(a.left + (border + size));
        b._block.style.left = px(b.left - (border + size));
      }
      a.cancelClicked();
      b.cancelClicked();
print("swap $a, $b");
      a.swap(b);
      report();
      return;
    }
    if (direction == UP) {
      a._block.style.top = px(a.top + velocity * (time - firstCall));
      b._block.style.top = px(b.top - velocity * (time - firstCall));
    } else {
      a._block.style.left = px(a.left + velocity * (time - firstCall));
      b._block.style.left = px(b.left - velocity * (time - firstCall));
    }
  }

}

class Remover implements Actor {
  int callTimes = 0;
  Eye removed;
  
  Remover(this.removed) {
  }
  
  void next(num time){
    if (callTimes >= 8){
print("rm ${removed.status},${removed.runtimeType}");
      if (removed.status != Eye.NORMAL && removed.skillOn == false);
      else if (removed.colorNum != null) {
        removed.destory();
      }
      animator.remove(this);
    } 
    callTimes++;
  }
}

class Score implements Actor {
  int times = 0;
  DivElement showScore;
  Score(this.showScore){}
  void next(num time){
    if(times > 3){
      times = 0;
      showScore.text = "${stageManager.score}";
    }
    times++;
  }
}

class Faller implements Actor {//create and fall
  Eye falling;
  int startingPoint;
  int distance;
  num velocity;
  num firstCall;
  int wholeTime;
  int perTime = 200;

  Faller(Eye a, int fallNum, int top){
    falling = a;
    distance = fallNum * (border + size);
    wholeTime = perTime * fallNum;
    velocity = (border + size) / perTime;
    startingPoint = top;
  }

  void next(num time){
    if (firstCall == null) {
      firstCall = time;
    } else if (time - firstCall >= wholeTime){
      falling._block.style.top = px(falling.top);
      animator.remove(this);
    } else {
      falling._block.style.top = px(startingPoint + (velocity * (time - firstCall)).toInt());
    }
  }
}

class ControlFaller {
  void findfall(){
    int max = 0;
    for (int i = 0; i < column; i++){
      int top;
      int newDiv = 0;
      for (int j = row - 1; j >= 0; j--){
        int nullNum = 0;
        if (blocks[i][j].colorNum == null){
          for (int k = j; k >= 0; k--) {
            if (blocks[i][k].colorNum != null){
              break;
            }
            nullNum++;
          } 
          if (nullNum != 0){
print('2: ${i}, ${j}, nullNum: ${nullNum}, newDiv: ${newDiv}');
            if(j - nullNum < 0){
              newDiv++;
              int topOfEye = newDiv * size * (-1) - border * (newDiv - 1);
              int leftOfEye = border + (size + border) * i;
              Eye eye = new Eye(random.nextInt(5) + 11, leftOfEye, topOfEye);
              eye.create();
              blocks[i][j].equel(eye);
              top = topOfEye;
              nullNum = nullNum + newDiv - 1;           
            } else {
              blocks[i][j].swap(blocks[i][j - nullNum]);
              top = blocks[i][j - nullNum].top;
            }
            animator.add(new Faller(blocks[i][j], nullNum, top));
            if (nullNum > max) {
              max = nullNum;
            }
            gameManager.falling = false;
          }
        }
      }
    }
    if (max > 0) {
      animator.add(new Controlremover(max));
      gameManager.executing = false;
    }
  }
}

class Controlremover implements Actor {
  int maximum;
  num firstCall;

  Controlremover(int max) {
    maximum = max * 201;
  }

  void next(num time) {
    if (firstCall == null){
      firstCall = time;
    }
    if (time - firstCall > maximum && !gameManager.falling) {
      gameManager.controlremover();
      animator.remove(this);
      gameManager.executing = true;
   }
  }
}

class OpenSkillOn implements Actor {
  int times = 0;

  void next(num time) {
    print('in OpenSkillOn');
    if (times == 10) {
      print('already open');
      for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
          if (blocks[i][j].status != Eye.NORMAL) {
            blocks[i][j].skillOn = true;
          }
        }
      }
      gameManager.executing = true;
      animator.remove(this);
    }
    print('$times');
    times++;
  }
}

class startor implements Actor {
  DivElement show;
  next(num time) {
    if (time >= 4000) {
      query('#bigShield').classes.add('disappear');
      show.classes.add('disappear');
      animator.remove(this);
    } else if (time >= 3200) {
      show.text = 'START';
    } else if (time >= 2400) {
      show.text = '1';
    } else if (time >= 1600) {
      show.text = '2';
    } else if (time >= 800) {
      show = query('#num');
      show.text = '3';
    } else {
      query('#start').classes.add('disappear');
    }
  }
}