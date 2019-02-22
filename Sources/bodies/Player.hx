package bodies;

import kha.input.KeyCode;
import kha.Assets;
import kha.input.Keyboard;
import box2D.collision.shapes.B2MassData;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Math.dot;
import box2D.common.math.B2Vec2;

class Player extends Body {
  public var sprite : Sprite;
  //public var onTrack(default, null) : Bool;
  var keyboard : Keyboard;
  var gasDown = false;
  var boostDown = false;
  var brakeDown = false;
  var leftDown = false;
  var rightDown = false;
  var maxLateralImpulse = 1.;
  
  override public function new(position, parent, world) {
    super(position, parent, world, DYNAMIC_BODY);
    
    sprite = new Sprite(Assets.images.spaceships60, 64, 64, 512, 1056, this);
    sprite.originX = 32;
    sprite.originY = 32;

    var shape = new B2PolygonShape();
    shape.setAsBox(.5, .5);
    var fixtureDef = new B2FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.friction = .3;
    b2body.createFixture(fixtureDef);

    var massData = new B2MassData();
    massData.mass = 10;
    massData.I = 20/3;
    b2body.setMassData(massData);

    /*
    components.push(new components.TrailComponent(0xee855e01, new B2Vec2(-.14, -.5), parent));
    components.push(new components.TrailComponent(0xee855e01, new B2Vec2(.14, -.5), parent));
    */
    if (Keyboard.get() != null) Keyboard.get().notify(onKeyDown, onKeyUp);
  }

  function onKeyDown(key:KeyCode) {
    switch key {
      case KeyCode.W:
        gasDown = true;
      case KeyCode.A:
        leftDown = true;
      case KeyCode.S:
        brakeDown = true;
      case KeyCode.D:
        rightDown = true;
      case KeyCode.Shift:
        boostDown = true;
      default:
        null;
    }
  }

  function onKeyUp(key:KeyCode) {
    switch key {
      case KeyCode.W:
        gasDown = false;
      case KeyCode.A:
        leftDown = false;
      case KeyCode.S:
        brakeDown = false;
      case KeyCode.D:
        rightDown = false;
      case KeyCode.Shift:
        boostDown = false;
      default:
        null;
    }
  }

  override public function update(dt: Float, worldToScreen : B2Vec2 -> Array<Float>) {
    function velToForce(v : Float) return (-100/(v+1.5))+110;
    function velToForceTrack(v : Float) return (-500/((v/7)+1))+570;
    var forceFunc = velToForce;
    if (boostDown) forceFunc = velToForceTrack;
    var massCenter = b2body.getWorldCenter();
    var velocity = b2body.getWorldVector(new B2Vec2(0,1));
    if (gasDown || boostDown) {
      velocity.multiply(forceFunc(b2body.getLinearVelocity().length()));
    } else if (brakeDown) {
      velocity.multiply(-forceFunc(b2body.getLinearVelocity().length()));
    }
    b2body.applyForce(velocity, massCenter);
    if (leftDown) {
      b2body.applyTorque(40);
    } else if (rightDown) {
      b2body.applyTorque(-40);
    }

    var lateralVelocity = b2body.getWorldVector(new B2Vec2(1, 0));
    lateralVelocity.multiply(dot(lateralVelocity, b2body.getLinearVelocity()));
    var impulse = lateralVelocity.getNegative();
    impulse.multiply(b2body.getMass());
    if (impulse.length() > maxLateralImpulse) {
      impulse.multiply(maxLateralImpulse/impulse.length());
    }
    b2body.applyImpulse(impulse, massCenter);
    sprite.x = x;
    sprite.y = y;
    sprite.angle = angle;

    super.update(dt, worldToScreen);
  }
}