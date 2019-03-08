package bodies;

import kha.Assets;
import box2D.collision.shapes.B2MassData;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Math.dot;
import box2D.common.math.B2Vec2;

class Player extends Body {
  public var sprite : Sprite;
  //public var onTrack(default, null) : Bool;
  var gasDown = false;
  var boostDown = false;
  var brakeDown = false;
  var leftDown = false;
  var rightDown = false;
  var controller : control.Controller;
  var maxLateralImpulse = 1.;
  
  override public function new(position, parent, world, controller) {
    super(position, parent, world, DYNAMIC_BODY);
    this.controller = controller;
    
    sprite = new Sprite(Assets.images.spaceships60, 64, 64, 512, 1056, this);
    sprite.origin.x = 32;
    sprite.origin.y = 32;

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
  }

  override public function update(dt: Float) {
    function velToForce(v : Float) return (-100/(v+1.5))+110;
    function velToForceTrack(v : Float) return (-500/((v/7)+1))+570;
    var forceFunc = velToForce;
    if (controller.input.boost) forceFunc = velToForceTrack;
    var massCenter = b2body.getWorldCenter();
    var velocity = b2body.getWorldVector(new B2Vec2(0,1));
    if (controller.input.up || controller.input.boost) {
      velocity.multiply(forceFunc(b2body.getLinearVelocity().length()));
    } else if (controller.input.down) {
      velocity.multiply(-forceFunc(b2body.getLinearVelocity().length()));
    }
    b2body.applyForce(velocity, massCenter);
    if (controller.input.left) {
      b2body.applyTorque(40);
    } else if (controller.input.right) {
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
    sprite.position = position;
    sprite.angle = -angle;

    super.update(dt);
  }
}