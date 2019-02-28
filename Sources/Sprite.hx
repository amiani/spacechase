import kha.Image;
import kha.math.FastMatrix3;
import kha.graphics2.Graphics;
import box2D.common.math.B2Vec2;

class Sprite extends Node {
  public var image(default, null) : Image;
  public var width(default, null) : Int;
  public var height(default, null) : Int;
  public var origin : Vec2 = { x: 0., y: 0. };
  public var sx(default, null) : Int;
  public var sy(default, null) : Int;
  var visible = true;
  var scale : Float = 1;

  public function new(image : Image, width: Int, height:Int, sx:Int=0, sy:Int=0, scale:Float=1, parent:Node) {
    super(parent);
    this.image = image;
    this.width = width;
    this.height = height;
    this.sx = sx;
    this.sy = sy;
    this.scale = scale;
  }

  override public function update(dt) {
    super.update(dt);
  }

	override public function draw(g: Graphics, worldToScreen:B2Vec2->Vec2): Void {
		if (image != null && visible) {
      var screenPosition = worldToScreen(position);
      screenPosition.x -= origin.x;
      screenPosition.y -= origin.y;
			if (angle != 0) 
        g.pushTransformation(g.transformation
          .multmat(FastMatrix3.translation(screenPosition.x + origin.x, screenPosition.y + origin.y))
          .multmat(FastMatrix3.rotation(angle))
          .multmat(FastMatrix3.translation(-screenPosition.x - origin.x, -screenPosition.y - origin.y))
        );
      g.color = 0xffffffff;
      g.drawScaledSubImage(image, sx, sy, width, height, screenPosition.x, screenPosition.y, width*scale, height*scale);
			if (angle != 0)
        g.popTransformation();
			//g.drawScaledSubImage(image, Std.int(animation.get() * w) % image.width, Math.floor(animation.get() * w / image.width) * h, w, h, Math.round(x - collider.x * scaleX), Math.round(y - collider.y * scaleY), width, height);
		}
    super.draw(g, worldToScreen);
  }
}