shader_type canvas_item;

void fragment() {
	COLOR = vec4(0.0, 0.0, 0.0, 1.0 - UV.x);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
