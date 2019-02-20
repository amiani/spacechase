import box2D.common.math.B2Vec2;
import box2D.common.math.B2Math.dot;

class Screen {
  public var position(default, null) : B2Vec2;
  private var hVec : B2Vec2;
  private var major : Float;
  private var minor : Float;
  
  public function new(position : B2Vec2, screenWidth : Float, screenHeight : Float) {
    this.position = position;
    this.hVec = new B2Vec2(1, 0);
    calcAxes(screenWidth, screenHeight);
  }

  private function calcAxes(screenWidth : Float, screenHeight : Float) {
    var isWide = screenWidth > screenHeight;
    minor = (isWide ? screenHeight : screenWidth) / 6 / 64;
    major = (isWide ? screenWidth : screenHeight) / 6 / 64;
  }

  public function onResize(screenWidth : Float, screenHeight : Float) {
    calcAxes(screenWidth, screenHeight);
  }

  public function update(dt : Float, playerPosition : B2Vec2, playerVelocity : B2Vec2) {
    var target = new B2Vec2(playerVelocity.x, playerVelocity.y);
    var speed = target.normalize();
    var angle = Math.acos(dot(hVec, target.getNegative()));
    var radius = major*minor /
      Math.sqrt(major*major*Math.sin(angle)*Math.sin(angle)+minor*minor*Math.cos(angle)*Math.cos(angle));
    //TODO: normalize speed and use to scale radius
    target.multiply(radius);
    target.add(playerPosition);

    target.subtract(position);
    var dist = target.normalize();
    target.multiply(logistic(dist)*(1.1*speed)*dt);
    target.add(position);
    position = target;
  }

  private inline function logistic(x : Float) {
    return 1 / (1 + Math.exp(-8*(x-.5)));
  }
}