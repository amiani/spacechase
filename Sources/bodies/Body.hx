package bodies;

import kha.netsync.Entity;
import kha.netsync.EntityBuilder;
import kha.graphics2.Graphics;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.*;

class Body extends Node implements Entity {
  var b2body : B2Body;
  var components : Array<components.Component>;

  public var position(get, never) : B2Vec2;
  public var velocity(get, never) : B2Vec2;

  public function new(
    position: B2Vec2,
    parent: Node,
    world : B2World,
    bodyType : box2D.dynamics.B2BodyType 
  ) {
    super(parent);
    var bodyDef = new B2BodyDef();
    bodyDef.type = bodyType;
    bodyDef.position.set(position.x, position.y);
    bodyDef.linearDamping = 1;
    bodyDef.angularDamping = 3;
    b2body = world.createBody(bodyDef);
    components = new Array<components.Component>();
  }

  override public function update(dt : Float, worldToScreen : B2Vec2 -> Array<Float>) {
    angle = -b2body.getAngle();
    var screenPos = worldToScreen(position);
    x = screenPos[0];
    y = screenPos[1];
    for (c in components) {
      c.update(this, worldToScreen);
    }
    super.update(dt, worldToScreen);
  }

  public function get_position() {
    return b2body.getPosition();
  }

  public function get_velocity() {
    return b2body.getLinearVelocity();
  }
}