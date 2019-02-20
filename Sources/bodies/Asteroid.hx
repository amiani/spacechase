package bodies;

import kha.Assets;
import box2D.collision.shapes.B2MassData;
import box2D.dynamics.B2World;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2BodyDef;
import box2D.common.math.B2Vec2;

class Asteroid extends Body {
  public function new(
    position : B2Vec2,
    parent: Node,
    world : B2World) {
      super(position, parent, world, DYNAMIC_BODY);

      var asteroids = Assets.images.asteroids;
      var asteroidTile = asteroids.sub(67, 16, 33, 33);
      asteroidTile.dx = -Std.int(asteroidTile.width/2);
      asteroidTile.dy = -Std.int(asteroidTile.height/2);
      var asteroidSprite = new h2d.Bitmap(asteroidTile);

      var shape = new B2CircleShape((33/2)/64);
      var fixtureDef = new B2FixtureDef();
      fixtureDef.shape = shape;
      fixtureDef.friction = .3;
      b2body.createFixture(fixtureDef);
      b2body.setLinearDamping(.1);
      b2body.setAngularDamping(.1);

      var massData = new B2MassData();
      massData.mass = 10;
      massData.I = 20/3;
      b2body.setMassData(massData);
  }
}