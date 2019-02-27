import box2D.common.math.B2Vec2;
import net.StateUpdate;

class Scene extends Node {
	public var nodes(default, null) : Array<Node>;
	
	public function new() {
		super(null);
		nodes = new Array<Node>();
	}
	
  override public function update(dt:Float, worldToScreen:B2Vec2->Array<Float>) {
    for (child in children) {
      child.update(dt, worldToScreen);
    }
  }

	public function reset() {
		nodes = new Array<Node>();
	}

	public function getStateUpdate(frame:Int) {
		nodes.sort((a, b) -> a.accumulatedPriority - b.accumulatedPriority);
		var updateNodes = nodes.slice(0, 100);
		for (n in updateNodes) n.resetAccumulatedPriority();
		return new StateUpdate(frame, updateNodes);
	}

	public function applyStateUpdate(stateUpdate:StateUpdate) {
		trace('applying state update');
		for (node in stateUpdate.nodes) {
			//trace(node.id);
		}
	}
}