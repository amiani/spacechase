import kha.graphics2.Graphics;
import box2D.common.math.B2Vec2;
import hxbit.Serializable;

class Node implements Serializable {
  public var children(default, null) : Array<Node>;
  public var parent(default, set) : Node;
  public var x : Float;
  public var y : Float;
  public var angle : Float;

  public function new(parent:Node) {
    this.children = new Array<Node>();
    this.parent = parent;
  }

  public function set_parent(node:Node):Node {
    if (parent != null) {
      var index = parent.children.indexOf(this);
      if (index != -1)
        parent.children.splice(index, 1);
    }
    if (node != null) node.children.push(this);
    return parent = node;
  }

  public function update(dt:Float, worldToScreen:B2Vec2->Array<Float>) {
    for (child in children) {
      child.update(dt, worldToScreen);
    }
    Spacechase.scene.nodes.push(this);
  }

  public function draw(g:Graphics) {
    for (child in children) {
      child.draw(g);
    }
  }
}