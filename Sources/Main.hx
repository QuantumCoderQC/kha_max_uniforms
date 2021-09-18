package;

import kha.graphics4.ConstantLocation;
import kha.arrays.Float32Array;
import kha.System;
import kha.Framebuffer;
import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;

class Main {

	public static function main() {
		System.start({title: "Empty", width: 640, height: 480}, init);
	}

	static function init(_) {
		var game = new Empty();
		System.notifyOnFrames(function (frames) { game.render(frames); });
	}
}

class Empty {

	// An array of 3 vectors representing 3 vertices to form a triangle
	static var vertices:Array<Float> = [
	   -1.0, -1.0, 0.0, // Bottom-left
	    1.0, -1.0, 0.0, // Bottom-right
	    0.0,  1.0, 0.0  // Top
	];
	// Indices for our triangle, these will point to vertices above
	static var indices:Array<Int> = [
		0, // Bottom-left
		1, // Bottom-right
		2  // Top
	];

	// Test uniform
	var testUniform: Float32Array;

	// (Krom and Windows)4096 -> No error, 4097 -> Error
	// (Android Native) 1024 -> No error, 1025 -> Error
	var elemetsCount = 4097*4;
	var testID:ConstantLocation;

	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	public function new() {
		// Define vertex structure
		var structure = new VertexStructure();
        structure.add("pos", VertexData.Float3);
	
		// Compile pipeline state
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.compile();

		// Get test uniform location
		testID = pipeline.getConstantLocation("testUniform");

		// Create vertex buffer
		vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
			structure, // Vertex structure
			Usage.StaticUsage // Vertex data will stay the same
		);
		
		// Copy vertices to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, vertices[i]);
		}
		vertexBuffer.unlock();

		// Create index buffer
		indexBuffer = new IndexBuffer(
			indices.length, // 3 indices for our triangle
			Usage.StaticUsage // Index data will stay the same
		);
		
		// Copy indices to index buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();

		// Init uniform
		testUniform = new Float32Array(elemetsCount);
		for(i in 0...testUniform.length){
			testUniform.set(i, 1.0);
		}
    }

	public function render(frame:Array<Framebuffer>) {
		// A graphics object which lets us perform 3D operations
		var g = frame[0].g4;

		// Begin rendering
        g.begin();

        // Clear screen to black
		g.clear(Color.Black);

		// Bind state we want to draw with
		g.setPipeline(pipeline);

		// Bind data we want to draw
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		//set test uniform
		g.setFloats(testID, testUniform);

		// Draw!
		g.drawIndexedVertices();

		// End rendering
		g.end();
    }

}
