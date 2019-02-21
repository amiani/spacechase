let project = new Project('spacechase');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

project.localLibraryPath = 'libs';
project.addLibrary('box2d');
project.addLibrary('Kha2D');

//project.addParameter('-dce full');
resolve(project);