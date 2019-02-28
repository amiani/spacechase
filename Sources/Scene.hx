import box2D.common.math.B2Vec2;
import net.StateUpdate;

class Scene extends Node {
	var nodes : Map<Int, Node>;
	public var maxNodes(default, null) : Array<Node>;

	public function new() {
		super(null);
		nodes = new Map<Int, Node>();
	}
	
  override public function update(dt:Float) {
		maxNodes = new Array<Node>();
    for (child in children) {
      child.update(dt);
    }
  }

	public inline function addNode(node:Node) {
		nodes[node.id] = node;
	}

	public inline function removeNode(id:Int) {
		return nodes.remove(id);
	}

	public function getStateUpdate(frame:Int) {
		maxNodes.sort((a, b) -> a.accumulatedPriority - b.accumulatedPriority);
		var updateNodes = maxNodes.slice(0, 100);
		for (n in updateNodes) n.resetAccumulatedPriority();
		return new StateUpdate(frame, updateNodes);
	}

	public function applyStateUpdate(stateUpdate:StateUpdate) {
		for (node in stateUpdate.nodes) {
			nodes[node.id].applyState(node);
		}
	}
}