shader_type canvas_item;

void fragment() {
	vec2 moved_uv = UV;
    moved_uv.y += TIME * 0.5;
	moved_uv.x -= TIME * 0.5;
    COLOR = texture(TEXTURE, moved_uv);
}
