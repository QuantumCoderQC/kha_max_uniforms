#version 450

// Input vertex data, different for all executions of this shader
in vec3 pos;

// Test uniform
// (HTML5, Krom and Windows)4096 -> No error, 4097 -> Error
// (Android Native) 1024 -> No error, 1025 -> Error
const int maxVecs = 4097;
uniform vec4 testUniform[maxVecs];

void main() {
	// Just output position
	vec3 spos = pos * testUniform[0].xyz;
	gl_Position = vec4(spos, 1.0);
}
