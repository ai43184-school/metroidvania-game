shader_type canvas_item;

void fragment() {
	vec2 moved_uv = UV;
    moved_uv.y += TIME * 1.2;
    COLOR = texture(TEXTURE, moved_uv);
}
