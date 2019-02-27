package bodies;

import kha.Color;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2CircleShape;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

class Gate extends Body {
  var postHalfWidth = 2.5;
  var circleShape1 = new B2CircleShape(.25);
  var circleShape2 = new B2CircleShape(.25);

  override public function new(position, parent, world) {
    super(position, parent, world, STATIC_BODY);
    
    circleShape1.setLocalPosition(new B2Vec2(-postHalfWidth, 0));
    circleShape2.setLocalPosition(new B2Vec2(postHalfWidth, 0));
    b2body.createFixture2(circleShape1);
  }

  override public function draw(g:Graphics) {
    g.color = Color.Red;
    var circle1Position = b2body.getWorldPoint(circleShape1.getLocalPosition());
    var circle2Position = b2body.getWorldPoint(circleShape2.getLocalPosition());
    GraphicsExtension.fillCircle(g, circle1Position.x, circle1Position.y, .25*64);
    GraphicsExtension.fillCircle(g, circle2Position.x, circle2Position.y, .25*64);
    super.draw(g);
  }
}