shader_type canvas_item;

void fragment() {
  vec2 uv = UV;
  if (uv.y > 0.5) {
    discard; // Discards the pixel, effectively making it transparent
  }
  COLOR = texture(TEXTURE, uv);
}