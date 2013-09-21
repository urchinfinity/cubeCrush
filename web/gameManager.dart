part of eyeBurst;

GameManager gameManager = new GameManager();

class GameManager implements Actor {
  bool end = false;
  bool executing = false;
  bool falling = false;

  //check
  bool controlremover() {
    return true;
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
    if (end){
      //output
    }
    if (time >= 64000){
      //end game
      end = true;
    } else if (time >= 48000){
      //shake
    } else if (time >= 42000){
      //shakeB
    } else if (executing = true) {
      ControlFaller controlFaller = new ControlFaller();
      controlFaller.findfall();
      executing = false;
    }
  }
}

class changer implements Actor {
  static const int UP = 0;
  static const int LEFT = 1;
  bool executing = false;
  Eye a;//which is up or left one
  Eye b;
  int wholeTime;
  int direction;
  double velocity;
  num firstCall;

  changer(int milliseconds) {
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
      _pickEyes(a, b);
      firstCall = null;
    } else {
      executing == false;
      gameManager.executing = true;
    }
  }
  void next(num time){
    if(executing) {
      if (firstCall == null)
        firstCall = time;
      if ((a._block.style.top == a.top + 68) || (a._block.style.left == a.left + 68)) {
        swap(a, b);
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

}

class remover implements Actor {
  int special;
  int callTimes = 0;
  Eye removed;
  
  remover(this.removed, {int put}) {
    if (put != null)
      special = put;
  }
  
  void next(num time){
    if(callTimes >= 8){
      if(special == null)
        removed.destory();
      else
        removed.status = special;
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