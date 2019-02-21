import kha.Image;
import kha.graphics2.Graphics;
import box2D.common.math.B2Vec2;

class Background {
	public var image : Image;
	var screenWidth : Int;
	var screenHeight : Int;
	var rows : Int;
	var cols : Int;

	public function new(image:Image, screenWidth:Int, screenHeight:Int) {
		this.image = image;
		this.screenHeight = screenHeight;
		this.screenWidth = screenWidth;
		this.cols = Math.floor(screenWidth / image.width)+2;
		this.rows = Math.floor(screenHeight / image.height)+2;
	}

	public function draw(g:Graphics, worldToScreen:B2Vec2->Array<Float>) {
		var origin = worldToScreen(new B2Vec2());
		var xStart = origin[0] % image.width;
		var yStart = origin[1] % image.height;
		for (i in 0...rows) for (j in -1...cols) {
			g.drawImage(image, xStart + i * image.width, yStart + j * image.height);
		}
	}
}