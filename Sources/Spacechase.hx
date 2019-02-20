class Spacechase {
  public function update() {
    world.step(TIMESTEP, 8, 3);
    world.clearForces();
    scene.update(TIMESTEP);
  }

  public function draw() {

  }
}