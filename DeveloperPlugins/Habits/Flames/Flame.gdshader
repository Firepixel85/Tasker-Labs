shader_type canvas_item;

// Procedural flame for Godot 4.
// Apply to a ColorRect or Sprite2D (a roughly square or tall rect works best).
// The flame is anchored at base_position and grows upward.

group_uniforms colors;
uniform vec4 outer_color : source_color = vec4(0.85, 0.08, 0.02, 1.0); // red outer layer
uniform vec4 mid_color   : source_color = vec4(1.0, 0.45, 0.04, 1.0);  // orange middle layer
uniform vec4 core_color  : source_color = vec4(1.0, 0.88, 0.30, 1.0);  // yellow core
uniform float brightness : hint_range(0.0, 3.0, 0.01) = 1.0;
uniform float glow       : hint_range(0.0, 1.0, 0.01) = 0.25;          // soft halo around the flame

group_uniforms size;
uniform float flame_size   : hint_range(0.1, 3.0, 0.01) = 1.0;   // overall scale
uniform float flame_width  : hint_range(0.05, 0.6, 0.01) = 0.28; // half-width of the body
uniform float flame_height : hint_range(0.2, 1.5, 0.01) = 0.85;  // height of the flame
uniform vec2  base_position = vec2(0.5, 0.92);                   // UV position of the flame base

group_uniforms animation;
uniform float speed      : hint_range(0.0, 5.0, 0.01) = 1.0;   // animation speed
uniform float sway       : hint_range(0.0, 0.3, 0.005) = 0.05; // gentle side-to-side motion
uniform float turbulence : hint_range(0.0, 0.5, 0.005) = 0.12; // wobble of the edges
uniform float flicker    : hint_range(0.0, 1.0, 0.01) = 0.15;  // brightness and height flicker
uniform float edge_softness : hint_range(0.005, 0.3, 0.005) = 0.08;
uniform float corner_softness : hint_range(0.0, 1.0, 0.01) = 0.3; // extra rounding of corners and the tip

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		v += a * vnoise(p);
		p = p * 2.03 + vec2(17.1, 9.7);
		a *= 0.5;
	}
	return v;
}

// Teardrop-shaped flame mask: round bulb at the bottom, curved tip at the top.
float flame_shape(vec2 q, float t, float w, float hgt, float soft, float seed) {
	float h = q.y / hgt;

	float x = q.x;
	// Sway grows toward the tip so the base stays put
	x -= sway * sin(t * 2.0 + h * 2.5 + seed) * h * h;
	// Noise wobble rising upward
	float n = fbm(vec2(q.x * 4.0 + seed, h * 2.5 - t * 1.6));
	x += (n - 0.5) * turbulence * 2.0 * clamp(h, 0.0, 1.0);

	// Width profile: one continuous curve (round base, widest low down,
	// tapering smoothly to the tip) so there are no kinks where pieces meet
	float u = clamp((h + 0.06) / 1.06, 0.0, 1.0);
	float profile = max(sin(PI * pow(u, 0.55)), 0.0);
	float width = w * pow(profile, 1.1);

	// Softer edge toward the tip so the point fades out instead of cutting off
	float s = soft * (1.0 + 1.5 * clamp(h, 0.0, 1.0)) * (1.0 + corner_softness * 3.0);
	float edge = width - abs(x);
	return smoothstep(0.0, s, edge);
}

void fragment() {
	float t = TIME * speed;

	// Flicker: slight height and brightness variation over time
	float fl = vnoise(vec2(t * 2.5, 1.7)) - 0.5;
	float hgt = flame_height * (1.0 + flicker * 0.3 * fl * 2.0);
	float lum = 1.0 + flicker * fl * 2.0;

	// Local flame space: origin at the base, +y is up, scaled by flame_size
	vec2 q = (UV - base_position) / flame_size;
	q.y = -q.y;

	float outer = flame_shape(q, t, flame_width,        hgt,        edge_softness,       0.0);
	float mid   = flame_shape(q, t, flame_width * 0.78, hgt * 0.82, edge_softness * 1.3, 1.3);
	float core  = flame_shape(q, t, flame_width * 0.5,  hgt * 0.55, edge_softness * 1.8, 3.7);

	// Soft halo
	float halo = flame_shape(q, t, flame_width * 1.7, hgt * 1.15, 0.35, 0.0) * glow * 0.5;

	vec3 col = outer_color.rgb;
	col = mix(col, mid_color.rgb, mid);
	col = mix(col, core_color.rgb, core);
	col *= brightness * lum;

	float alpha = max(outer, halo * (1.0 - outer));
	vec3 halo_col = outer_color.rgb * brightness;
	col = mix(halo_col, col, outer);

	COLOR = vec4(col, alpha);
}
