class Scene {
  public var children(default, null) : Array<Node>;

  public function update(dt:Float) {
    for (child in children) {
      child.update(dt);
    }
  }
}