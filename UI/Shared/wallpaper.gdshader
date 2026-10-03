shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.012, 0.027, 0.086, 1.0);
uniform vec4 glow_color : source_color = vec4(0.06, 0.3, 0.82, 1.0);
uniform vec4 core_color : source_color = vec4(0.45, 0.72, 1.0, 1.0);
uniform vec2 center = vec2(0.5, 0.6);
uniform float radius = 0.65;

void fragment() {
	vec2 p = (SCREEN_UV - center) * vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
	float d = length(p) / radius;
	vec3 col = mix(base_color.rgb, glow_color.rgb, smoothstep(1.0, 0.0, d));
	col = mix(col, core_color.rgb, smoothstep(0.35, 0.0, d) * 0.5);
	col += (fract(sin(dot(FRAGCOORD.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) / 255.0;
	COLOR = vec4(col, 1.0);
}
