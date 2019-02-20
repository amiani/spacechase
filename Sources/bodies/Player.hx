package bodies;

import kha.Assets;
import kha2d.Sprite;
import box2D.collision.shapes.B2MassData;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Math.dot;
import box2D.common.math.B2Vec2;

class Player extends Body {
  public var sprite : Sprite;
  //public var onTrack(default, null) : Bool;
  //var exhaust : h2d.Particles;
  var maxLateralImpulse = 1.;
  
  override public function new(position, parent, world) {
    super(position, parent, world, DYNAMIC_BODY);

    
    var spaceships60 = Assets.images.spaceships60;
    var playerTile = spaceships60.sub(512, 1056, 64, 64);
    playerTile.dx = -Std.int(playerTile.width/2);
    playerTile.dy = -Std.int(playerTile.height/2);
    sprite = new h2d.Bitmap(playerTile);
    object.addChild(sprite);

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

    //exhaust = new h2d.Particles(object);
    //var exhaustGroup = new h2d.Particles.ParticleGroup(exhaust);
    //exhaust.addGroup(exhaustGroup);
    //exhaustGroup.texture = h3d.mat.Texture.fromColor(0xee855e);
    //exhaustGroup.emitMode = Direction;
    //exhaustGroup.emitAngle = -1;

    var box = new h2d.Graphics();
    box.beginFill(0xee855e, .5);
    box.drawRect(-32, -32, 64, 64);
    box.endFill();
    //object.addChild(box);

    components.push(new components.TrailComponent(0xee855e01, new B2Vec2(-.14, -.5), parent));
    components.push(new components.TrailComponent(0xee855e01, new B2Vec2(.14, -.5), parent));
  }

  override public function update(dt: Float, worldToScreen : B2Vec2 -> Array<Float>) {
    function velToForce(v : Float) return (-100/(v+1.5))+110;
    function velToForceTrack(v : Float) return (-500/((v/7)+.01))+570;
    var forceFunc = velToForce;
    if (Key.isDown(Key.SHIFT)) forceFunc = velToForceTrack;
    var massCenter = b2body.getWorldCenter();
    var velocity = b2body.getWorldVector(new B2Vec2(0,1));
    if (Key.isDown(Key.W)) {
      velocity.multiply(forceFunc(b2body.getLinearVelocity().length()));
      b2body.applyForce(velocity, massCenter);
    } else if (Key.isDown(Key.S)) {
      velocity.multiply(-forceFunc(b2body.getLinearVelocity().length()));
      b2body.applyForce(velocity, massCenter);
    }
    if (Key.isDown(Key.A)) {
      b2body.applyTorque(40);
    } else if (Key.isDown(Key.D)) {
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

    super.update(dt, worldToScreen);
  }
}