package bodies;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2CircleShape;

class Gate extends Body {
  override public function new(position, parent, world) {
    super(position, parent, world, STATIC_BODY);
    
    var postHalfWidth = 2.5;
    var circleShape1 = new B2CircleShape(.25);
    var circleShape2 = new B2CircleShape(.25);
    circleShape1.setLocalPosition(new B2Vec2(-postHalfWidth, 0));
    circleShape2.setLocalPosition(new B2Vec2(postHalfWidth, 0));
    b2body.createFixture2(circleShape1);
    b2body.createFixture2(circleShape2);

    /*
    var circles = new h2d.Graphics(object);
    circles.beginFill(0xee855e);
    circles.drawCircle(-postHalfWidth*64, 0, .25*64);
    circles.drawCircle(postHalfWidth*64, 0, .25*64);
    circles.endFill();
    object.addChild(circles);
    */
  }
}