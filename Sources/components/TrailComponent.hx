package components;

import box2D.common.math.B2Vec2;

class TrailComponent implements Component {
  var color : Int;
  var r : Float;
  var g : Float;
  var b : Float;
  var a : Float;
  var trail : h2d.Graphics;
  var vertices : Array<B2Vec2>;
  var offset : B2Vec2;

  public function new(color : Int, offset : B2Vec2, parent : h2d.Layers) {
    this.r = color >>> 24 & 0xff;
    this.g = color >>> 16 & 0xff;
    this.b = color >>> 8 & 0xff;
    this.a = color & 0xff;
    this.offset = offset;
    vertices = new Array<B2Vec2>();
    trail = new h2d.Graphics();
    parent.add(trail, 2);
  }

  public function update(body : bodies.Body, worldToScreen) {
    var exhaust = new B2Vec2(
      body.position.x + (offset.x*Math.cos(body.angle) - offset.y*Math.sin(body.angle)),
      body.position.y + (offset.x*Math.sin(body.angle) + offset.y*Math.cos(body.angle))
    );
    vertices.push(exhaust);
    var start = vertices.length > 30 ? vertices.length - 30 : 0;
    var end = vertices.length < 30 ? vertices.length : start+30;
    trail.clear();
    trail.lineStyle(5, body.velocity.length() > 15 ? 0xffffff : 0xee855e);
    for (i in start...end) {
      var p = worldToScreen(vertices[i]);
      trail.addVertex(p[0], p[1], 0, 0, 0, 1);
    }
  }
}