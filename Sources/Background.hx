import kha.Image;
import kha.graphics2.Graphics;
import box2D.common.math.B2Vec2;

class Background {
	public var image : Image;

	public function new(image:Image, screenWidth:Int, screenHeight:Int) {
		this.image = image;
	}

	public function draw(g:Graphics, width, height, worldToScreen:B2Vec2->Vec2) {
		var cols = Math.floor(width / image.width)+2;
		var rows = Math.floor(height / image.height)+2;
		var origin = worldToScreen(new B2Vec2());
		var xStart = origin.x % image.width;
		var yStart = origin.y % image.height;
		g.color = 0xffffffff;
		for (i in -1...rows) for (j in 0...cols) {
			g.drawImage(image, xStart + j * image.width, yStart + i * image.height);
		}
	}
}