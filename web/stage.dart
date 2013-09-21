part of eyeBurst;

abstract class ActorX extends Actor {
  void create();
  void destroy();
}
class Stage {
  int stage = 1;
}

Stage stage = new Stage();
StageManager stageManager = new StageManager();

class StageManager {
  setStage(){    
    query('.copyright').style.top = "${window.innerHeight - 120}px";
    query('#outBorder').style.left = "${(window.innerWidth - 952) / 2}px";
    query('.output').style.height = "${window.innerHeight - 240}px";
    parent = query("#frame");
    createBlocks();
  }
  setEvent(){    
    query('#start').onClick.listen((MouseEvent event) {
      query('#start').classes.add('disappear');
      query('#bigShield').classes.add('disappear');
    });
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