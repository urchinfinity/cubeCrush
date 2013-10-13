library animator;

import "dart:html";

class Animator {
  bool _running = false;
  num _whenStarted;
  RequestAnimationFrameCallback _callback;

  Animator() {
    _callback = (num now) {
      if (!_running)
        return;
      if (_whenStarted == null) {
        _whenStarted = now;
      }
      now -= _whenStarted;

      for (final Actor actor in new List.from(actors)) {
        if (!_running)
          return;
        actor.next(now);
      }

      window.requestAnimationFrame(_callback);
    };
  }

  List<Actor> actors = [];

  void add(Actor actor){
print(">>add $actor");
    actors.add(actor);
  }
  void remove(Actor actor) {
    actors.remove(actor);
  }

  void start() {
    if (!_running) {
      _running = true;
      _whenStarted = null;
      window.requestAnimationFrame(_callback);
    }
  }
  void stop() {
    _running = false;
    _whenStarted = null;
    actors = [];
  }
}

abstract class Actor {
  ///time is milliseconds
  void next(int time);
}
