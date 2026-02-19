shader_type canvas_item;

void fragment() {
	vec2 moved_uv = UV;
    moved_uv.y -= TIME * 0.5; // Adjust the multiplier (0.1) for speed
    COLOR = texture(TEXTURE, moved_uv);
}