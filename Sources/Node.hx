import hxbit.Serializer;
import kha.graphics2.Graphics;
import box2D.common.math.B2Vec2;
import hxbit.Serializable;

class Node implements Serializable {
  static var lastId = 0;
  @:s public var id(default, null) : Int;
  public var children(default, null) : Array<Node>;
  public var parent(default, set) : Node;

  @:isVar public var position(get, set) : B2Vec2;
  @:isVar public var linearVelocity(get, set) : B2Vec2;
  @:s @:isVar public var angularVelocity(get, set) : Float;
  @:s @:isVar public var angle(get, set) : Float;
  public var x : Float;
  public var y : Float;

  public var priority(default, null) : Int;
  public var accumulatedPriority(default, null) : Int;

  public function new(parent:Node, ?priority: Int) {
    this.id = ++lastId;
    this.children = new Array<Node>();
    this.parent = parent;
    this.priority = priority == null ? 1 : priority;
    this.accumulatedPriority = priority;
    initPhysicalVariables();
    if (parent != null) Spacechase.activeScene.addNode(this);
  }

  function initPhysicalVariables() {
    position = new B2Vec2();
    linearVelocity = new B2Vec2();
    angularVelocity = 0;
    angle = 0;
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
    var screenPosition = worldToScreen(position);
    x = screenPosition[0];
    y = screenPosition[1];
    for (child in children) {
      child.update(dt, worldToScreen);
    }
    accumulatedPriority += priority;
    Spacechase.activeScene.maxNodes.push(this);
  }

  public function draw(g:Graphics) {
    for (child in children) {
      child.draw(g);
    }
  }
  
  public function applyState(node:Node) {
    return;
  }

  public inline function resetAccumulatedPriority() {
    accumulatedPriority = priority;
  }

  public function get_position() {
    return position;
  }
  function set_position(p:B2Vec2) {
    return position = p;
  }

  public function get_linearVelocity() {
    return linearVelocity;
  }
  function set_linearVelocity(v:B2Vec2) {
    return linearVelocity = v;
  }

  function get_angularVelocity() {
    return angularVelocity;
  }
  function set_angularVelocity(o:Float) {
    return angularVelocity = o;
  }

  function get_angle() {
    return angle;
  }
  function set_angle(a:Float) {
    return angle = a;
  }

  public function check():Bool {
    var av :Null<Float> = angularVelocity;
    var an : Null<Float> = angle;
    if (position == null || linearVelocity == null || av == null || an == null)
      return false;
    return true;
  }

  @:keep
  public function customSerialize(ctx:Serializer) {
    ctx.addFloat(position.x);
    ctx.addFloat(position.y);
    ctx.addFloat(linearVelocity.x);
    ctx.addFloat(linearVelocity.y);
  }

  @:keep
  public function customUnserialize(ctx:Serializer) {
    position = new B2Vec2(ctx.getFloat(), ctx.getFloat());
    linearVelocity = new B2Vec2(ctx.getFloat(), ctx.getFloat());
  }
}