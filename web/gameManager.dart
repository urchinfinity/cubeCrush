part of eyeBurst;

GameManager gameManager = new GameManager();

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
    cleanTimes++;
    List<List<CountBlock>> countBlocks = findBlocks();
    //put bomb
    //findBomb(countBlocks);
    //put thunder and colocClean
    //findCross(countBlocks);
    for (int i = column - 1; i >= 0 ; i--) {
      for (int j = row - 1; j >= 0; j--) {
        if (countBlocks[i][j].countColumn >= 3) {
          for (int k = 0; k < countBlocks[i][j].countColumn; k++) {
//            if (blocks[i-k][j].skillOn == true) {//!!!!!!!!!!!!!!!!!!!!!!
//              skill(blocks[i-k][j]);
//print("boooooooooooooooooon");
//              break;
//            }
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
//            if (blocks[i][j-k].skillOn == true) {//!!!!!!!!!!!!!!!!!!!!
//              skill(blocks[i][j-k]);
//print('booooooooooooooooooon');
//                break;
//            }
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
    //animator.add(new OpenSkillOn());
    stageManager.score +=  crushBlocks * cleanTimes * 100;
    return crush;
  }

  void next(num time) {
    if (stageManager.stage == 0) {
      animator.add(new Startor());
      stageManager.stage++;
    } else if (end){
      animator.add(new ControlEnder());
      animator.remove(this);
    } else {
      if (time >= 63800) {
        query('#bigShield').classes.remove('disappear');
        end = true;
      } else if (time >= 63700){
        //shake
        if(shakeTimes > 3) {
          for(int i = 0; i < column; i++){
            for(int j = 0; j < row; j++){
              if(blocks[i][j].colorNum != null) {
                blocks[i][j]._block.classes.add('shake');
              }
            }
          }
          shakeTimes = 0;
        } else
          shakeTimes++;
      }
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
    if (a.status == Eye.COLORCLEAN ){
      animator.add(new CleanColor(b.colorNum, a));
      animator.remove(this);
      animator.add(new ControlFaller());
      return;
    } else if (b.status == Eye.COLORCLEAN) {
      animator.add(new CleanColor(a.colorNum, b));
      animator.remove(this);
      animator.add(new ControlFaller());
      return;
    }
    bool boolA = removeChanger(a);
    bool boolB = removeChanger(b);
    if (!(boolA || boolB)) {
      if(changeTimes == 1){
        animator.remove(this);
        return;
      }
      changeTimes++;
      _pickEyes(a, b);
      firstCall = null;
    } else {
      animator.remove(this);
      animator.add(new ControlFaller());
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
    if (callTimes >= 10){
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
    a.falling = true;
  }

  void next(num time){
    if(falling.colorNum == null){
      falling.falling = false;
      animator.remove(this);
      return;
    }
    if (firstCall == null) {
      firstCall = time;
    } else if (time - firstCall >= wholeTime){
      falling._block.style.top = px(falling.top);
      falling.falling = false;
      animator.remove(this);

    } else {
      falling._block.style.top = px(startingPoint + (velocity * (time - firstCall)).toInt());
    }
  }
}

class ControlFaller implements Actor {
  int times = 0;
  void next(num time){
    if (times == 0) {
      times++;
      return;
    }
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
      animator.remove(this);
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
      animator.add(new ControlFaller());
   }
  }
}

class OpenSkillOn implements Actor {
  int times = 0;

  void next(num time) {
    if (times == 12) {
      for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
          if (blocks[i][j].status == Eye.BOMB || blocks[i][j].status == Eye.THUNDER) {
            blocks[i][j].skillOn = true;
print('($i, $j): skillOn, ${blocks[i][j].status}, ${blocks[i][j].skillOn}');
          } else {
            blocks[i][j].skillOn = false;
          }
        }
      }
      gameManager.executing = true;
      animator.remove(this);
    }
    times++;
  }
}

class Startor implements Actor {
  double displacement;
  double a1;
  double a2;
  double a3;
  double a4;
  double dis;
  double dis2;
  double vMax;
  double _vMax;

  Startor() {
    a1 = 1.44 / 800;
    a2 = 1.44 / 1700;
    dis = (14 * 1.44);
    _vMax = dis / (120 + 16);
    a3 = _vMax / 16;
    a4 = _vMax / 120;
    vMax = 1.44;
  }
  next(num time) {
    if (time >= 3800) {
      query('#start').classes.remove('rotate');
      query('#start').classes.add('disappear');
      query('#numS').classes.add('disappear');
      query('#bigShield').classes.add('disappear'); 
      animator.remove(this);
      return;
    } else if (time >= 2600) {
      query('#numS').classes.remove('disappear');
      query('#num1').classes.add('disappear');
    } else if (time >= 1800) {
      query('#num1').classes.remove('disappear');
      query('#num2').classes.add('disappear');
    } else if (time >= 1000) {
      query('#num2').classes.remove('disappear');
      query('#num3').classes.add('disappear');
    } else if (time >= 200) {
      query('#start').classes.add('rotate');
      query('#num3').classes.remove('disappear');
    }
  }
}

class ControlEnder implements Actor {
  num firstCall;
  int stage = 0;

  void next(num time) {
    if (firstCall == null) {
      firstCall = time;
      //bat turn to front
    } else if (stage == 0 && time - firstCall >= 3000) {
      query("#score2").text = "${stageManager.score}";
      query("#score2").classes.remove('disappear');
      query("#scoreShow").classes.remove('disappear');
      stage++;
    } else if (stage == 1 && time - firstCall >= 6000) {
      query("#scoreShow").classes.add('scoreShow2');
      query("#score2").classes.add('score3');
      stage++;
    } else if (stage == 2 && time - firstCall >= 8000) {
      query("#batShield").classes.remove('disappear');
      query("#scoreShow").classes.remove('scoreShow2');
      query("#score2").classes.remove('score3');
      query('#score2').classes.add('disappear');
      query('#scoreShow').classes.add('disappear');
      stage++;
    } else if(stage == 3 && time - firstCall >= 12000) {
      
      
      
      //------------------strat---------------------------------------------------------------
      var message = {'recipient': 'JSfirst', 'name': stageManager.usrName, 'score': stageManager.score};
      window.postMessage(message, '*');
      subscription = window.onMessage.listen(dataReceived);
      //-------------------end-----------------------------------------------------------------
      
      
      //stageManager.setOutput();
      query('#output').classes.remove('disappear');
      stage++;
    } else if(stage == 4 && time - firstCall >= 14000) {
      query("#batShield").classes.add('disappear');
      stage++;
      animator.remove(this);
    }
  }
}

double aToDisplacement(double a, num t) {
  return (a * t * t)/2;
}
