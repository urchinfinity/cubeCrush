part of eyeBurst;

StageManager stageManager = new StageManager();
DivElement pos;

//-------------start----------------------------------------
var subscription = null;
dataReceived(MessageEvent e) {
  var data = e.data;
  if (data["recipient"] != 'DART') {
    return;
  }
  stageManager.rank = data["rank"];
  var message = {'recipient': 'JSsecond'};
  window.postMessage(message, '*');
  subscription.cancel();
  stageManager.setOutput();
  
  if (stageManager.rank == 1) {
    query('#monster0').classes.remove('disappear');
  } else if (stageManager.rank >= 2 && stageManager.rank <= 5) {
    query('#monster4').classes.remove('disappear');
  } else if (stageManager.rank >= 6 && stageManager.rank <= 10) {
    query('#monster1').classes.remove('disappear');
  } else if (stageManager.rank >= 11 && stageManager.rank <= 50) {
    query('#monster3').classes.remove('disappear');
  } else if (stageManager.rank == 0) {
    query('#monster2').classes.remove('disappear');
  }
}
//--------------end-----------------------------------------------

class StageManager {
  bool sthClicked = false;
  Eye firstClicked, secondClicked;
  int stage = 0;
  int score = 0;
  int rank;
  String usrName;
  bool firstStart = true;

  bool onBorder(int x, int y) {
    if(x % 68 > 0 && x % 68 < 8)
      return true;
    if(y % 68 > 0 && y % 68 < 8)
      return true;
    return false;
  }
  
  void setStage() {    
    document.body.classes.remove('hide');
    query('.copyright').style.top = window.innerHeight - 110 >= 861? px(window.innerHeight - 110): px(861);
    query('#submitboard').style.height = window.innerHeight - 110 >= 861? px(window.innerHeight - 240): px(861-150);
    query('#sbmt').style.left = px((window.innerWidth - 540) / 2 + 430);
    query('#input').style.left = px((window.innerWidth - 540) / 2 + 140);
    query('#bloodSubmit').style.left = px((window.innerWidth - 540) / 2 + 430);
    query('#monsterShadow').style.left = px((window.innerWidth - 540) / 2);
  }

  void setOutput() {
    query('#output').style.height = window.innerHeight - 110 >= 861? px(window.innerHeight - 240): px(861-150);
    query('#rank').style.left = px((window.innerWidth - 910) / 2 + 500);
    for (int i = 0; i < 5; i++) {
      query('#monster$i').style.left = px((window.innerWidth - 930) / 2);
    }
    query('#re2').style.left = px((window.innerWidth - 910) / 2 + 565);
    query('#lastscore').style.left = px((window.innerWidth - 910) / 2 + 760);
    query('#scoreNum').style.left = px((window.innerWidth - 910) / 2 + 785);
    query('#scoreNum').text = "${stageManager.score}";
    setRestart();
  }
  
  void setGame() {
    query('#batShield').style.height = window.innerHeight - 110 >= 861? px(window.innerHeight - 240): px(861-150);
    query('#scoreShow').style.left = px((window.innerWidth - 420) / 2 );
    query('#score2').style.left = px((window.innerWidth - 420) / 2 + 60);
    query('#outBorder').style.left = px((window.innerWidth - 952) / 2);
    setTimer();
    parent = query("#frame");
    createBlocks();
  }

  void setRestart() {
    query('#re2').onClick.listen((MouseEvent evt){
      query('#output').classes.add('disappear');
      restart();
    });
  }

  void setEvent() {
    InputElement submit = query("#sbmt");
    //submit hover
    submit.onMouseOver.listen((MouseEvent evt) {
      submit.style.left = px((window.innerWidth - 540) / 2 + 433);
      submit.style.top = px(262);
      submit.style.width = px(104);
    });
    submit.onMouseOut.listen((MouseEvent evt) {
      submit.style.left = px((window.innerWidth - 540) / 2 + 430);
      submit.style.top = px(260);
      submit.style.width = px(110);
    });
    submit.onClick.listen((MouseEvent evt) {
      InputElement name = query('#input'); 
      if(name.value != "") {
      usrName = name.value;
      setGame();
      
      query('#submitboard').classes.add('disappear');

      query('#start').onClick.listen((MouseEvent event) {
        if(firstStart){
          firstStart = false;
          setEvent2();
        }
        animator.add(new Score(query('#score')));
        animator.add(gameManager);
        animator.start();
      });
      } else {
        query('#bloodSubmit').classes.remove('disappear');
        new Timer(new Duration(seconds: 1),(){
          query('#bloodSubmit').classes.add('disappear');
        });
      }
    });submit.onMouseOver.listen((MouseEvent evt) {
      submit.style.left = px((window.innerWidth - 540) / 2 + 433);
      submit.style.top = px(262);
      submit.style.width = px(104);
    });
    submit.onMouseOut.listen((MouseEvent evt) {
      submit.style.left = px((window.innerWidth - 540) / 2 + 430);
      submit.style.top = px(260);
      submit.style.width = px(110);
    });

    document.onKeyDown.listen((KeyboardEvent evt){
      if(evt.keyCode == 13){
        InputElement name = query('#input'); 
        if(name.value != "") {
          usrName = name.value;
          setGame();
        
          query('#submitboard').classes.add('disappear');
  
          query('#start').onClick.listen((MouseEvent event) {
            if(firstStart){
              firstStart = false;
              setEvent2();
            }
            animator.add(gameManager);            
            animator.add(new Score(query('#score')));
            animator.start();
          });
        } else {
          query('#bloodSubmit').classes.remove('disappear');
          new Timer(new Duration(seconds: 1),(){
            query('#bloodSubmit').classes.add('disappear');
          });
        }
      }
    });
  }

  void setEvent2() {
    pos = query('#outBorder');
    parent.onClick.listen((MouseEvent event) {
      int clickPosX, clickPosY;
      clickPosX = (event.page.x - pos.offsetLeft).toInt();
      clickPosY = (event.page.y - pos.offsetTop).toInt();
      if(onBorder(clickPosX, clickPosY))
          return;
      clickPosX = clickPosX ~/ (size + border);
      clickPosY = clickPosY ~/ (size + border);
      if(blocks[clickPosX][clickPosY]._block == null){
        return;
      }
      if (!sthClicked) {
        sthClicked = true;
        firstClicked = blocks[clickPosX][clickPosY];
        firstClicked.beClicked();
      } else {
        if (blocks[clickPosX][clickPosY] == firstClicked) { // click the same block
          sthClicked = false;
          firstClicked.cancelClicked();
          firstClicked = null;
        } else if (firstClicked.besideClicked(blocks[clickPosX][clickPosY])) {
          sthClicked = false;
          secondClicked = blocks[clickPosX][clickPosY];
          secondClicked.beClicked();
          Changer changer = new Changer(200);
          changer._pickEyes(firstClicked, secondClicked);
          sthClicked = false;
          animator.add(changer);
        } else {
          firstClicked.cancelClicked();
          firstClicked = blocks[clickPosX][clickPosY];
          firstClicked.beClicked();
        } 
      } 
    });
    query('#hint').onClick.listen((MouseEvent event) {
      if (!searchBox(checkOnly: false)) {
        searchLine(checkOnly: false);
      }
    });
    query('#restart').onClick.listen((MouseEvent event) {
      restart();
    }); 
  }

  void setTimer() {
    DivElement _parent = query('#outBorder');
    for(int i = 0; i < 10; i++){
      bats[i] = new Element.html('<div class="bat"></div>');
      bats[i].style.left = px(1 + i * 68);
      ImageElement img = new Element.html('<img src="static/bat00.png">');
      img.style.width = px(30);
      img.style.left = px(25);
      bats[i].nodes.add(img);
      _parent.nodes.add(bats[i]);
    }

    for(int i = 0; i < 10; i++){
      flyingbats[i] = new Element.html('<div class="batfly disappear"></div>');
      flyingbats[i].style.left = px(1 + i * 68 - 140);
      ImageElement img = new Element.html('<img src="static/batFly.gif">');
      flyingbats[i].nodes.add(img);
      _parent.nodes.add(flyingbats[i]);
    }
    animator.add(new Bat());
  }
//
//  void create() {
//    for (...)
//      anitmator.add(new Candy()..create());
//  }
//  void destroy() {
//    animator.stop();
//
//    for (final ActorX actor in animator.actors)
//      actor.destroy();
//  }  
}

//stage = new Stage()..create();
List<DivElement> bats = new List(10);
List<DivElement> flyingbats = new List(10);

class Bat implements Actor {
  int batNum = 0;

  void next(num time) {
    if (batNum == 0 && time >= 9800) {
      bats[9].remove();
      flyingbats[9].classes.remove('disappear');
      animator.add(new Fly(flyingbats[9], batNum));
      batNum++;
    } else if (batNum == 1 && time >= 15800) {
      bats[8].remove();
      flyingbats[8].classes.remove('disappear');
      animator.add(new Fly(flyingbats[8], batNum));
      batNum++;
    } else if (batNum == 2 && time >= 21800) {
      bats[7].remove();
      flyingbats[7].classes.remove('disappear');
      animator.add(new Fly(flyingbats[7], batNum));
      batNum++;    
    } else if (batNum == 3 && time >= 27800) {
      bats[6].remove();
      flyingbats[6].classes.remove('disappear');
      animator.add(new Fly(flyingbats[6], batNum));
      batNum++;
    } else if (batNum == 4 && time >= 33800) {
      bats[5].remove();
      flyingbats[5].classes.remove('disappear');
      animator.add(new Fly(flyingbats[5], batNum));
      batNum++;
    } else if (batNum == 5 && time >= 39800) {
      bats[4].remove();
      flyingbats[4].classes.remove('disappear');
      animator.add(new Fly(flyingbats[4], batNum));
      batNum++;
    } else if (batNum == 6 && time >= 45800) {
      bats[3].remove();
      flyingbats[3].classes.remove('disappear');
      animator.add(new Fly(flyingbats[3], batNum));
      batNum++;
    } else if (batNum == 7 && time >= 51800) {
      bats[2].remove();
      flyingbats[2].classes.remove('disappear');
      animator.add(new Fly(flyingbats[2], batNum));
      batNum++;
    } else if (batNum == 8 && time >= 57800) {
      bats[1].remove();
      flyingbats[1].classes.remove('disappear');
      animator.add(new Fly(flyingbats[1], batNum));
      batNum++;
    } else if (batNum == 9 && time >= 63800) {
      bats[0].remove();
      flyingbats[0].classes.remove('disappear');
      animator.add(new FlyEnd());
      animator.remove(this);
    }
  }
}

class Fly implements Actor {
  DivElement bat;
  num lastTime;
  num firstCall;
  int order;
  double top = 386.0;
  double left;

  Fly(this.bat, this.order){
    left = 1.0 + (9.0 - order) * 68.0 - 140.0;
  }
  
  void next(num time) {
    if (lastTime == null) {
      lastTime = time;
    }
    if (firstCall == null) {
      firstCall = time;
    }
    if(time - firstCall > 6000) {
      bat.remove();
      animator.remove(this);
    }
    if (time - firstCall < 2000 || time - firstCall > 4000) {
      top += (time - lastTime) * (200/2000);
    } else if (time - firstCall < 4000) {
      top -= (time - lastTime) * (100/1000);
    }

    left += (time - lastTime) * (400/2000);
    if (left >= (window.innerWidth - 952) / 2 + 925.0 - 100.0) {
      bat.remove();
      animator.remove(this);
    }

    bat.style.left = px(left);
    bat.style.top = px(top);

    lastTime = time;
  }
}

class FlyEnd implements Actor {
  double a;
  num firstCall;

  FlyEnd() {
    a = 0.17 / 3000;
  }

  void next(num time) {
    if(firstCall == null) {
      firstCall = time;
    }
    if (time - firstCall > 3000) {
      flyingbats[0].remove();
      animator.remove(this);
      return;
    }
    double top = 386.0 - aToDisplacement(a, time - firstCall);
    double left = 1.0 - 140.0 + (time - firstCall) * (360 / 3000);

    flyingbats[0].style.left = px(left);
    flyingbats[0].style.top = px(top);
  }
}