shader_type canvas_item;

uniform vec2 dir = vec2(0.0, 0.0);
uniform int quality = 4;

// Bounding box in original-sprite UV space: (min x, min y, max x, max y)
uniform vec4 mask_rect = vec4(0.0, 0.0, 1.0, 1.0);

void vertex() {
	vec2 size = 1.0 / TEXTURE_PIXEL_SIZE; // quad size in pixels

	vec2 lo = min(dir, vec2(0.0));
	vec2 hi = vec2(1.0) + max(dir, vec2(0.0));
	vec2 newUV = mix(lo, hi, UV);

	VERTEX += (newUV - UV) * size;
	UV = newUV;
}

float insideRect(vec2 v, vec2 lo, vec2 hi) {
	vec2 s = step(lo, v) - step(hi, v);
	return s.x * s.y;
}

void fragment() {
	vec4 sum = vec4(0.0);
	float numSamples = 0.0;
	int q = max(quality, 1);

	for (int i = 0; i <= q; i++) {
		vec2 uv = UV - dir * (float(i) / float(q));
		float inSquare = insideRect(uv, vec2(0.0), vec2(1.0));
		numSamples += inSquare;
		sum += texture(TEXTURE, uv) * inSquare;
	}

	COLOR = sum;
	COLOR.rgb /= max(numSamples, 1.0);
	COLOR.a /= float(q) + 1.0;

	// Mask: discard anything outside the bounding box
	COLOR *= insideRect(UV, mask_rect.xy, mask_rect.zw);
}