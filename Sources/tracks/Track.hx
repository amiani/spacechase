package tracks;

import box2D.common.math.B2Vec2;
import kha.Image;

class Track extends Node {
  //var mask : hxd.Pixels;
  public var image : Image;
  var sprite : Sprite;

  public function new(image : Image, position: B2Vec2, parent:Node) {
    super(parent);
    //this.mask = hxd.Res.testtrackmask.getPixels();
    this.position = position;
    this.image = image;
    sprite = new Sprite(image, image.width, image.height, 0, 0, 3.5, this);
  }

  override public function update(dt : Float, worldToScreen : B2Vec2 -> Array<Float>) {
    var screenPos = worldToScreen(position);
    x = screenPos[0];
    y = screenPos[1];
    sprite.x = x;
    sprite.y = y;
    super.update(dt, worldToScreen);
  }

/*
  public function checkOnTrack(bounds : h2d.col.Bounds) {
    if (bounds.x >= 0 && bounds.y >= 0) {
      for (dx in 0...Std.int(bounds.width))
      for (dy in 0...Std.int(bounds.height)) {
        var pixelX = Std.int(bounds.x+dx);
        var pixelY = Std.int(bounds.y+dy);
        if (pixelX <= mask.width && pixelY <= mask.height) {
          var pixel = mask.getPixel(pixelX, pixelY);
          if (pixel >>> 8 & 0xff == 255) {
            return true;
          }
        }
      }
    }
    return false;
  }
  */
}