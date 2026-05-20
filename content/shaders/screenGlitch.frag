#pragma header

uniform float glitchThreshold;

uniform float thresholdOffset;

void main()
{
	vec2 st = openfl_TextureCoordv.xy;  // Note, already normalized

	vec4 color = flixel_texture2D(bitmap, st);

	if (dot(color.rgb, vec3(0.2126, 0.7152, 0.0722)) > (glitchThreshold - thresholdOffset)) {
        gl_FragColor = color;
	} else {
        gl_FragColor = vec4(0.0);
	}
}
