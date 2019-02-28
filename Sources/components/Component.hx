package components;

import box2D.common.math.B2Vec2;

interface Component {
  public function update(body : bodies.Body) : Void;
}