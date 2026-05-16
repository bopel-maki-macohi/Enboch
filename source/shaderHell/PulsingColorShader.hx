package shaderHell;

import flixel.graphics.tile.FlxGraphicsShader;

class PulsingColorShader extends FlxGraphicsShader
{
	@:glFragmentSource('
        #pragma header
    
        uniform float u_time;
    
        vec3 colorA = vec3(0.149,0.141,0.912);
        vec3 colorB = vec3(1.000,0.833,0.224);
    
        void main() {
            vec3 color = vec3(0.0);
                
    
            float pct = sin(u_time) + 0.5;
    
            // Mix uses pct (a value from 0-1) to
            // mix the two colors
            color = mix(colorA, colorB, pct);
    
            gl_FragColor = vec4(color,1.0);
        }
    ')
	public function new()
	{
		super();
		// Create u_time variable to supply the uniform the shader needs
		this.u_time.value = [0.0];
	}

	/**
	 * Update shader variables as needed
	 * @param elapsed the time since the last update
	 */
	public function update(elapsed:Float)
	{
		this.u_time.value[0] += elapsed;
	}
}
