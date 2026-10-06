shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform vec2 direction = vec2(0,0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	float strength = texture(noise, UV + ( direction * TIME)).r;
	strength = strength * 90.0 - 35.0;
	
	COLOR = vec4(strength, strength, strength, COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
