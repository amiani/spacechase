import box2D.common.math.B2Vec2;

class Scene extends Node {
	@:s public var nodes(default, null) : Array<Node>;
	
	public function new() {
		super(null);
		nodes = new Array<Node>();
	}
	
  override public function update(dt:Float, worldToScreen:B2Vec2->Array<Float>) {
    for (child in children) {
      child.update(dt, worldToScreen);
    }
  }
}