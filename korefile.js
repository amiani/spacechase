let fs = require('fs');
let path = require('path');
let project = new Project('spacechase');
project.addDefine('HXCPP_API_LEVEL=332');
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/linux');
await project.addProject('build/linux-build');
await project.addProject('/opt/kodestudio/resources/app/kodeExtensions/kha/Kha');
if (fs.existsSync(path.join('libs/box2d', 'korefile.js'))) {
	await project.addProject('libs/box2d');
}
if (fs.existsSync(path.join('libs/hxbit', 'korefile.js'))) {
	await project.addProject('libs/hxbit');
}
resolve(project);
