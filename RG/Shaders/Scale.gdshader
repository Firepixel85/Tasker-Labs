shader_type canvas_item;

uniform float scale : hint_range(0.0, 1.0) = 1.0;
uniform vec2 pivot = vec2(0.5, 0.5);

void fragment() {
    vec2 uv = UV;

    // Offset UV so pivot is at origin, scale, then shift back
    uv = (uv - pivot) / scale + pivot;

    // Sample texture with transformed UV
    COLOR = texture(TEXTURE, uv);
}
