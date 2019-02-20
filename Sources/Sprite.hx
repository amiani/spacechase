import kha.Image;

class Sprite extends Node {
  public var image(default, null) : Image;

  override public function update() {

  }

	override public function draw(g: Graphics): Void {
		if (image != null && visible) {
			g.color = Color.White;
			if (angle != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(x + originX, y + originY)).multmat(FastMatrix3.rotation(angle)).multmat(FastMatrix3.translation(-x - originX, -y - originY)));
			g.drawScaledSubImage(image, Std.int(animation.get() * w) % image.width, Math.floor(animation.get() * w / image.width) * h, w, h, Math.round(x - collider.x * scaleX), Math.round(y - collider.y * scaleY), width, height);
			if (angle != 0) g.popTransformation();
		}
    super.draw();
  }
}