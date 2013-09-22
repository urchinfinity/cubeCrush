part of eyeBurst;

GameManager gameManager = new GameManager();

class GameManager implements Actor {
  bool end = false;
  bool executing = false;
  bool falling = false;
  
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
            animator.add(new Remover(blocks[i-k][j]));
            crush = true;
            /// count score
            if (blocks[i-k][j].count == false) {
              crushBlocks++;
              blocks[i-k][j].count = true;
            }
          }
        }
        if (countBlocks[i][j].countRow >= 3) {
          for (int k = 0; k < countBlocks[i][j].countRow; k++) {
print("add remover ${i},${j-k}");
            animator.add(new Remover(blocks[i][j-k]));
            crush = true;
            //count score
            if (blocks[i][j-k].count == false) {
              crushBlocks++;
              blocks[i][j-k].count = true;
            }
          }
        }
      }
    }
    stageManager.score +=  crushBlocks * cleanTimes;
print('$crush');
    return crush;
  }

  void controlFall() {

  }
  
  //create eyes
  //make eyes fall
  //score
  //output

  //restart
  //destroy

  void next(int time) {
    if (stageManager.stage == 0) {
      animator.add(new startor());
      stageManager.stage++;
    } else if (end){
      //output
    } else if (time >= 64000){
      end = true;
    } else if (time >= 48000){
      //shake
    } else if (time >= 42000){
      //shakeB
    } else if (executing = true) {
      //ControlFaller controlFaller = new ControlFaller();
      //controlFaller.findfall();
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
    if(callTimes >= 8){
print("rm ${removed.status},${removed.runtimeType}");
      if(removed.status == Eye.NORMAL)
        removed.destory();
      animator.remove(this);
      gameManager.executing = true;
    }
    callTimes++;
  }
}

class Faller implements Actor {//create and fall
  faller(){}
  void next(num time){}
}
class score implements Actor {
  void next(num time){}
}
class ControlFaller {
  List<int> columns;

  controlFaller() {
    columns = new List();
    for (int i = 0; i < column; i++){
      columns.add(i);
    }
  }

  void findfall(){
    if (columns.length == 0)
      return;
    for (final int columId in columns){
      for (int j = row - 1; j >= 0; j--){
        if(j == 0){
          columns.remove(columId); 
        }
      }
    }
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