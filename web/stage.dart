part of eyeBurst;

StageManager stageManager = new StageManager();
DivElement pos;

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
    query('.copyright').style.top = window.innerHeight - 110 >= 861? px(window.innerHeight - 110): px(861);
    query('#submitboard').style.height = window.innerHeight - 110 >= 861? px(window.innerHeight - 240): px(861-150);
    query('#batShield').style.height = window.innerHeight - 110 >= 861? px(window.innerHeight - 240): px(861-150);
    query('#scoreShow').style.left = px((window.innerWidth - 420) / 2 );
    query('#score2').style.left = px((window.innerWidth - 420) / 2 + 60);
    query('#monsterShadow').style.left = px((window.innerWidth - 540) / 2);
    query('#sbmt').style.left = px((window.innerWidth - 540) / 2 + 430);
    query('#bloodSubmit').style.left = px((window.innerWidth - 540) / 2 + 430);
    query('#input').style.left = px((window.innerWidth - 540) / 2 + 140);
    query('#outBorder').style.left = px((window.innerWidth - 952) / 2);
    setTimer();
    parent = query("#frame");
    createBlocks();
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
      
      query('#submitboard').classes.add('disappear');

      query('#start').onClick.listen((MouseEvent event) {
        animator.add(gameManager);
        animator.start();
        if(firstStart){
          firstStart = false;
          setEvent2();
        }
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
        
          query('#submitboard').classes.add('disappear');
  
          query('#start').onClick.listen((MouseEvent event) {
            animator.add(gameManager);
            animator.start();
            if(firstStart){
              firstStart = false;
              setEvent2();
            }
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
    animator.add(new Score(query('#score')));
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