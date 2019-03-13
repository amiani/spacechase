import kha.input.Mouse;
import kha.graphics2.Graphics;

class Menu {
	public var visible = true;
	var resetScene : Int -> Void;
	var connect : Void -> Void;

	public function new(resetScene:Int->Void, connect:Void->Void) {
		this.resetScene = resetScene;
		this.connect = connect;
		if (Mouse.get() != null) Mouse.get().notify(null, handleUp, null, null);
	}

	function handleUp(button:Int, x:Int, y:Int) {
		if (x >= 10 && x <= 100) {
			if (y >= 10 && y <= 40) {
				resetScene(0);
				visible = false;
			} else if (y >= 41 && y <= 70) {
				connect();
				trace('network');
				visible = false;
			}
		}
	}

	public function draw(g:Graphics, width:Int, height:Int) {
		if (visible) {
			g.color = 0xffffffff;
			g.fillRect(10, 10, 100, 30);
			g.fillRect(10, 40, 100, 30);
			g.color = kha.Color.Black;
			g.font = kha.Assets.fonts.Kingthings_Calligraphica_2;
			g.fontSize = 32;
			g.drawString('local', 12, 12);
			g.drawString('network', 12, 42);
			g.color = 0xffffffff;
		}
	}
}