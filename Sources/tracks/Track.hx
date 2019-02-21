package tracks;

import kha.graphics2.Graphics;
import box2D.common.math.B2Vec2;
import kha2d.Tile;
import kha.Image;

class Track extends Node {
  var tile : Tile;
  //var mask : hxd.Pixels;
  public var position(default, null) : B2Vec2;
  public var image : Image;

  public function new(image : Image, position: B2Vec2, parent:Node) {
    super(parent);
    //this.mask = hxd.Res.testtrackmask.getPixels();
    this.position = position;
    this.image = image;
  }

  override public function update(dt : Float, worldToScreen : B2Vec2 -> Array<Float>) {
    var screenPos = worldToScreen(position);
    x = screenPos[0];
    y = screenPos[1];
    super.update(dt, worldToScreen);
  }

  override public function draw(g:Graphics) {
    super.draw(g);
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