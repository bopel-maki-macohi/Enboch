#pragma header

uniform float glitchThreshold;

void main()
{
	vec2 st = openfl_TextureCoordv.xy;  // Note, already normalized

	vec4 color = flixel_texture2D(bitmap, st);

	if (dot(color.rgb, vec3(0.2126, 0.7152, 0.0722)) > (glitchThreshold + rand(vec2(-10, 10)))) {
        gl_FragColor = color;
	} else {
        gl_FragColor = vec4(0.0);
	}
}

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

