import kha.Image;
import kha.math.FastMatrix3;
import kha.graphics2.Graphics;

class Sprite extends Node {
  public var image(default, null) : Image;
  public var width(default, null) : Int;
  public var height(default, null) : Int;
  public var originX = 0.;
  public var originY = 0.;
  public var sx(default, null) : Int;
  public var sy(default, null) : Int;
  var visible = true;

  public function new(image : Image, width: Int, height:Int, sx:Int=0, sy:Int=0, parent:Node) {
    super(parent);
    this.image = image;
    this.width = width;
    this.height = height;
    this.sx = sx;
    this.sy = sy;
  }

  override public function update(dt, worldToScreen) {
    super.update(dt, worldToScreen);
  }

	override public function draw(g: Graphics): Void {
		if (image != null && visible) {
			if (angle != 0) 
        g.pushTransformation(g.transformation
          .multmat(FastMatrix3.translation(x + originX, y + originY))
          .multmat(FastMatrix3.rotation(angle))
          .multmat(FastMatrix3.translation(-x - originX, -y - originY))
        );
      g.drawSubImage(image, x, y, sx, sy, width, height);
			if (angle != 0)
        g.popTransformation();
			//g.drawScaledSubImage(image, Std.int(animation.get() * w) % image.width, Math.floor(animation.get() * w / image.width) * h, w, h, Math.round(x - collider.x * scaleX), Math.round(y - collider.y * scaleY), width, height);
		}
    super.draw(g);
  }
}