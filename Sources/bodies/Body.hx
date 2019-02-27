package bodies;

import kha.graphics2.Graphics;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.*;

class Body extends Node {
  var b2body : B2Body;
  var components : Array<components.Component>;

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

  override function initPhysicalVariables() {}

  override public function update(dt : Float, worldToScreen : B2Vec2 -> Array<Float>) {
    for (c in components) {
      c.update(this, worldToScreen);
    }
    super.update(dt, worldToScreen);
  }

  override function get_position() {
    if (b2body == null)
      return super.get_position();
    else {
      return b2body.getPosition();
    }
  }
  override function set_position(p:B2Vec2):B2Vec2 {
    if (b2body == null)
      super.set_position(p);
    else
      b2body.setPosition(p);
    return p;
  }

  override function get_linearVelocity() {
    if (b2body == null)
      return super.get_linearVelocity();
    else
      return b2body.getLinearVelocity();
  }
  override function set_linearVelocity(v:B2Vec2):B2Vec2 {
    if (b2body == null)
      super.set_linearVelocity(v);
    else
      b2body.setLinearVelocity(v);
    return v;
  }

  override function get_angularVelocity() {
    if (b2body == null)
      return super.get_angularVelocity();
    else
      return b2body.getAngularVelocity();
  }
  override function set_angularVelocity(o:Float) {
    if (b2body == null)
      super.set_angularVelocity(o);
    else
      b2body.setAngularVelocity(o);
    return o;
  }

  override function get_angle() {
    if (b2body == null)
      return super.get_angle();
    else
      return b2body.getAngle();
  }
  override function set_angle(a:Float) {
    if (b2body == null)
      super.set_angle(a);
    else
      b2body.setAngle(a);
    return a;
  }
}