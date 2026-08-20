shader_type canvas_item;

// Recreation of the "solving" state from thinking-orbs (orbs.jakubantalik.com)
// by Jakub Antalik — original is closed-source Canvas2D/TS, MIT licensed.
// This is a from-scratch behavioral rebuild, not a literal port: a dotted
// sphere made of latitude bands that scramble their rotation, then click
// back into alignment on a loop.

uniform vec4 dot_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // monochrome ink
uniform float sphere_radius : hint_range(0.3, 0.5) = 0.42;
uniform float dot_radius : hint_range(0.005, 0.04) = 0.016;
uniform float dot_edge : hint_range(0.001, 0.02) = 0.006;
uniform int band_count : hint_range(4, 20) = 9;
uniform float dot_spacing : hint_range(0.05, 0.3) = 0.14; // target arc spacing between dots in a band

// timing of one scramble -> click -> hold -> re-scramble cycle, in seconds
uniform float cycle_length : hint_range(0.5, 5.0) = 2.0;
uniform float scramble_amount : hint_range(0.0, 3.14) = 1.4; // radians of max rotational jitter
uniform float jitter_speed : hint_range(0.0, 10.0) = 3.0;

const float HALF_PI = 1.5707963;

float hash11(float p) {
	p = fract(p * 0.1031);
	p *= p + 33.33;
	p *= p + p;
	return fract(p);
}

// smooth back-out easing for the "click into place" snap
float ease_out_back(float t) {
	float c1 = 1.70158;
	float c3 = c1 + 1.0;
	float x = t - 1.0;
	return 1.0 + c3 * x * x * x + c1 * x * x;
}

void fragment() {
	vec2 p = UV * 2.0 - 1.0; // -1..1, centered
	float r2 = dot(p, p);
	vec4 outColor = vec4(0.0);

	if (r2 <= 1.0) {
		float x = p.x;
		float y = p.y;
		float z = sqrt(max(1.0 - x * x - y * y, 0.0)); // front hemisphere only

		float lat = asin(clamp(y, -1.0, 1.0));           // -HALF_PI..HALF_PI
		float lon = atan(x, z);                          // -PI..PI

		// which latitude band this pixel falls nearest to
		float band_f = (lat / HALF_PI) * 0.5 + 0.5;       // 0..1
		float band_idx = floor(band_f * float(band_count));
		band_idx = clamp(band_idx, 0.0, float(band_count - 1));
		float band_lat = ((band_idx + 0.5) / float(band_count) - 0.5) * PI;

		// --- animation cycle: scramble -> click -> hold -> repeat ---
		float t = mod(TIME, cycle_length) / cycle_length; // 0..1
		float scramble_end = 0.55;
		float click_end = 0.72;

		float seed = band_idx * 12.9898 + 3.1;
		float jitter = sin(TIME * jitter_speed + seed * 4.0) * hash11(seed);

		float rot_offset;
		if (t < scramble_end) {
			// actively scrambling: each band jitters independently
			float envelope = smoothstep(0.0, 0.12, t) * (1.0 - smoothstep(scramble_end - 0.12, scramble_end, t));
			rot_offset = jitter * scramble_amount * mix(0.5, 1.0, envelope);
		} else if (t < click_end) {
			// snapping back to zero with an overshoot "click"
			float k = (t - scramble_end) / (click_end - scramble_end);
			float eased = ease_out_back(k);
			float start_jitter = sin(scramble_end * cycle_length * jitter_speed / cycle_length + seed * 4.0) * hash11(seed) * scramble_amount;
			rot_offset = mix(start_jitter, 0.0, eased);
		} else {
			// solved and holding
			rot_offset = 0.0;
		}

		// dot count for this band, spaced roughly evenly along its circumference
		float band_circumference = 2.0 * PI * cos(band_lat);
		float dots_in_band = max(floor(band_circumference / dot_spacing), 3.0);
		float lon_step = 2.0 * PI / dots_in_band;

		float shifted_lon = lon - rot_offset;
		float nearest_k = floor(shifted_lon / lon_step + 0.5);
		float nearest_lon = nearest_k * lon_step + rot_offset;

		// reconstruct this dot's 3D position and project it
		float dx = cos(band_lat) * sin(nearest_lon);
		float dy = sin(band_lat);
		float dz = cos(band_lat) * cos(nearest_lon);

		if (dz > -0.05) {
			vec2 dot_pos = vec2(dx, dy);
			float dist = length(p - dot_pos);

			// foreshorten + fade dots near the silhouette edge
			float depth_scale = mix(0.5, 1.0, clamp(dz, 0.0, 1.0));
			float r = dot_radius * depth_scale;
			float mask = 1.0 - smoothstep(r - dot_edge, r + dot_edge, dist);

			float limb_fade = smoothstep(-0.05, 0.15, dz);

			// tiny bright flash right when a band clicks into place
			float click_flash = 0.0;
			if (t >= scramble_end && t < click_end) {
				float k2 = (t - scramble_end) / (click_end - scramble_end);
				click_flash = (1.0 - smoothstep(0.0, 0.3, k2)) * 0.5;
			}

			float alpha = mask * limb_fade * dot_color.a;
			outColor = vec4(dot_color.rgb + click_flash, alpha);
		}
	}

	COLOR = outColor;
}
