shader_type canvas_item;

uniform vec2 direction = vec2(0, 0);
uniform vec2 direction_overlay = vec2(0, 0);
uniform sampler2D noise: repeat_enable;
uniform sampler2D noise_overlay: repeat_enable;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment()
{
	// image texture
	vec4 base = texture(screen_texture, SCREEN_UV);
	
	float color1 = texture(noise, UV + ( direction * TIME)).r;
	float color2 = texture(noise_overlay, UV + ( direction_overlay * TIME)).r;
	float energy = color1 * color2;
	
	COLOR = vec4(energy, energy, energy, 1); //overlay(base, blend);
}