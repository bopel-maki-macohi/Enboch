// Base: https://github.com/47rooks/parasol/blob/main/parasol/shaders/ThresholdShader.hx

#pragma header

uniform float u_brightnessThreshold;

void main()
{
	vec2 st = openfl_TextureCoordv.xy;  // Note, already normalized

	vec4 color = flixel_texture2D(bitmap, st);

	if (dot(color.rgb, vec3(0.2126, 0.7152, 0.0722)) > u_brightnessThreshold) {
        gl_FragColor = color;
	} else {
        gl_FragColor = vec4(0.0);
	}
}