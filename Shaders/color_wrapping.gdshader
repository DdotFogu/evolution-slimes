shader_type canvas_item;

uniform vec4 shade_one : source_color;
uniform vec4 new_one : source_color;
uniform vec4 shade_two : source_color;
uniform vec4 new_two : source_color;
uniform vec4 shade_three : source_color;
uniform vec4 new_three : source_color;

const float threshold = 0.05; // Tolerance for color comparison

bool is_similar(vec4 a, vec4 b) {
	return distance(a, b) < threshold;
}

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	
	if (is_similar(current_pixel, shade_one)) {
		COLOR = new_one;
	} else if (is_similar(current_pixel, shade_two)) {
		COLOR = new_two;
	} else if (is_similar(current_pixel, shade_three)) {
		COLOR = new_three;
	} else {
		COLOR = current_pixel;
	}
}
