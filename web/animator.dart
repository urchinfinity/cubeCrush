library animator;

import "dart:html" show window;

class Animator {
  bool _running = false;
  num _whenStarted;
  RequestAnimationFrameCallback _callback;

  Animator() {
    _callback = (num now) {
      if (_whenStarted == null)
        _whenStarted = now;
      now -= _whenStarted;

      for (final Actor actor in new List.from(actors)) {
        actor.next(now);
      }

      if (_running)
        window.requestAnimationFrame(_callback);
    };
  }

  final List<Actor> actors = [];

  void add(Actor actor){
    actors.add(actor);
  }
  void remove(Actor actor) {
    actors.remove(actor);
  }

  void start() {
    if (!_running) {
      _running = true;
      window.requestAnimationFrame(_callback);
    }
  }
  void stop() {
    _running = false;
  }
}

abstract class Actor {
  ///time is milliseconds
  void next(int time);
}
