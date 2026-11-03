shader_type canvas_item;

// The image to transition to. Assumed to match the node's texture dimensions.
uniform sampler2D target_image : source_color, filter_linear;

// 0.0 = node's original texture, 1.0 = target_image.
uniform float fade : hint_range(0.0, 1.0) = 0.0;

// Carries the node's modulate / self_modulate (vertex COLOR) into fragment().
varying vec4 tint;

void vertex() {
	tint = COLOR;
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec4 img = texture(target_image, UV);

	// Per-pixel colour transition; alpha always comes from the node's own texture.
	vec3 rgb = mix(base.rgb, img.rgb, fade);

	// Apply modulate to the blended result.
	COLOR = vec4(rgb * tint.rgb, base.a * tint.a);
}
