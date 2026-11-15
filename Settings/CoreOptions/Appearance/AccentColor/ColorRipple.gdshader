shader_type canvas_item;

// Put this on a ColorRect overlay that sits ABOVE the content (mouse_filter = Ignore).
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

// Ripple origin in UV space (0..1) of the overlay.
uniform vec2 origin = vec2(0.5, 0.5);
uniform vec4 ripple_color : source_color = vec4(0.04, 0.52, 1.0, 1.0);
// 0 = not started, 1 = finished. Drive with a LINEAR tween; easing is built in.
uniform float progress : hint_range(0.0, 1.0) = 0.0;
// Overlay size in pixels. Set from script; this keeps the ripple circular.
uniform vec2 rect_size = vec2(1280.0, 720.0);

// --- Size (pixels) ---
uniform float max_radius : hint_range(50.0, 1200.0) = 380.0;
uniform float wave_width : hint_range(6.0, 80.0) = 26.0;

// --- Glass lens ---
// How strongly the wave bends the content underneath (px).
uniform float lens_strength : hint_range(0.0, 40.0) = 16.0;
// Color fringing at the lens edges.
uniform float chroma : hint_range(0.0, 1.0) = 0.4;
// Light-aware highlight on the wave (light comes from the top-left).
uniform float shine_strength : hint_range(0.0, 1.5) = 0.8;
// Soft accent glow riding the wave.
uniform float glow_strength : hint_range(0.0, 1.0) = 0.3;
// Hue drift along the rim, for a less flat, more premium color.
uniform float iridescence : hint_range(0.0, 1.0) = 0.5;

// --- Accent wash ---
// Tint left behind the wave, as if the new color is flooding in.
uniform float wake_strength : hint_range(0.0, 0.6) = 0.16;
uniform float wake_length : hint_range(20.0, 500.0) = 150.0;

// --- Secondary wave ---
uniform float echo_strength : hint_range(0.0, 1.0) = 0.5;
uniform float echo_delay : hint_range(0.0, 0.5) = 0.14;

float ease_out(float x) {
	float u = 1.0 - clamp(x, 0.0, 1.0);
	return 1.0 - u * u * u;
}

// Quick fade in, long fade out.
float envelope(float p) {
	return smoothstep(0.0, 0.06, p) * (1.0 - smoothstep(0.35, 1.0, p));
}

// Rotates the hue of an RGB color around the gray axis.
vec3 hue_rotate(vec3 c, float a) {
	vec3 k = vec3(0.57735);
	float ca = cos(a);
	return c * ca + cross(k, c) * sin(a) + k * dot(k, c) * (1.0 - ca);
}

// One lens-shaped wave. The profile is a gaussian bump; its slope gives refraction and lighting.
void wave(float dist, float R, float w, float amp, vec2 dir, vec2 light,
		out vec2 shift, out float shine, out float glow, out float zone) {
	float x = (dist - R) / max(w, 0.001);
	float g = exp(-x * x);
	float slope = 2.0 * x * g; // signed, peaks around +-0.86

	shift = -dir * slope * lens_strength * amp;
	// Surface normal points outward on the outer flank and inward on the inner flank,
	// so highlights land on the top-left outside and the bottom-right inside.
	float ndotl = clamp(dot(dir * slope, light) / 0.86, 0.0, 1.0);
	shine = ndotl * ndotl * amp;
	glow = exp(-(x * x) / 2.56) * amp;
	zone = exp(-(x * x) * 0.25) * amp;
}

void fragment() {
	
	vec2 pos = UV * rect_size;
	vec2 delta = pos - origin * rect_size;
	float dist = length(delta);
	vec2 dir = delta / max(dist, 0.0001);
	float ang = atan(delta.y, delta.x);
	vec2 light = normalize(vec2(-0.55, -0.83));

	float p = progress;
	float e = ease_out(p);

	// Lead wave.
	float R1 = e * max_radius;
	float w1 = wave_width * mix(0.8, 1.9, e);
	float a1 = envelope(p);

	// Echo wave: delayed, smaller, softer.
	float pe = clamp((p - echo_delay) / (1.0 - echo_delay), 0.0, 1.0);
	float ee = ease_out(pe);
	float R2 = ee * max_radius * 0.68;
	float w2 = wave_width * 0.8 * mix(0.8, 1.9, ee);
	float a2 = envelope(pe) * echo_strength;

	vec2 s1; float sh1; float gl1; float z1;
	vec2 s2; float sh2; float gl2; float z2;
	wave(dist, R1, w1, a1, dir, light, s1, sh1, gl1, z1);
	wave(dist, R2, w2, a2, dir, light, s2, sh2, gl2, z2);

	// Accent wash behind the lead wave.
	float behind = R1 - dist;
	float wake = smoothstep(-w1, w1 * 0.5, behind) * exp(-max(behind, 0.0) / wake_length);
	wake *= wake_strength * ripple_color.a * smoothstep(0.0, 0.08, p) * (1.0 - smoothstep(0.2, 0.85, p));

	// Convert pixel shifts to screen UV, using derivatives so it also works with scaled stretch modes.
	vec2 screen_per_px = vec2(length(dFdx(SCREEN_UV)), length(dFdy(SCREEN_UV)))
			/ max(vec2(length(dFdx(pos)), length(dFdy(pos))), vec2(0.0001));
	vec2 shift = (s1 + s2) * screen_per_px;

	// Refracted sample with a slight chromatic split.
	float r = texture(screen_texture, SCREEN_UV + shift * (1.0 - chroma)).r;
	float g = texture(screen_texture, SCREEN_UV + shift).g;
	float b = texture(screen_texture, SCREEN_UV + shift * (1.0 + chroma)).b;
	vec3 col = vec3(r, g, b);

	vec3 accent = ripple_color.rgb;
	vec3 rim_col = hue_rotate(accent, iridescence * 0.7 * sin(ang + p * 4.0));
	vec3 hi_col = mix(rim_col, vec3(1.0), 0.65);

	col = mix(col, accent, wake);
	col += rim_col * (gl1 + gl2 * 0.6) * glow_strength * ripple_color.a;
	col += hi_col * (sh1 + sh2 * 0.6) * shine_strength * ripple_color.a;

	// Only cover pixels the effect actually touches; everything else stays untouched.
	float active_amt = max(max(z1, z2), wake * 6.0);
	COLOR = vec4(clamp(col, 0.0, 1.5), smoothstep(0.0, 0.04, active_amt));
}