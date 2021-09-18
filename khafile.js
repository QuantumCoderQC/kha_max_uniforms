let project = new Project('Max Uniforms Test');

project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

resolve(project);
