shader_type canvas_item;
uniform int num_colors: hint_range(1,200) = 8;
uniform sampler2D PALETTE_TEXTURE: hint_default_black;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 direction = vec2(0, 0);
uniform vec2 direction_overlay = vec2(0, 0);
uniform sampler2D noise: repeat_enable;
uniform sampler2D noise_overlay: repeat_enable;

uniform float width = 1152.0;
uniform float height = 648.0;

uniform vec2 world_position = vec2(0, 0);

vec3 palette_limiter (in vec3 albedo){
	float estimation_cutoff = 0.001;
	vec3 closest_color;
	float min_dist = 2.0;
	float n = float(num_colors);
	
	for (int i=0; i<num_colors; i++ ){
		float index = 1.000/(2.000*n)+float(i)/n;
		vec3 index_color = texture(PALETTE_TEXTURE, vec2(index,0.5)).rgb;
		float dist = length(index_color - albedo);
		if (dist < min_dist) {
			min_dist = dist;
			closest_color = index_color;
			if (min_dist < estimation_cutoff){
				return closest_color;
			}
		}
	}
	return closest_color;
}

void fragment() {
	
	vec2 mod_uv = vec2(floor(UV.x * width) / width, floor(UV.y * height) / height);
	mod_uv = UV;
	// image texture
	vec4 base = texture(screen_texture, SCREEN_UV);
	
	vec2 wposnew = vec2(0, 0);
	wposnew.x = world_position.x / width;
	wposnew.y = world_position.y / height;
	
	float color1 = texture(noise, mod_uv + ( direction * TIME) + wposnew * 0.8).r;
	float color2 = texture(noise_overlay, mod_uv + ( direction_overlay * TIME) + wposnew * 0.9).r;
	float energy = color1 * color2;
	
	COLOR.rgba = texture(screen_texture,UV);
	float adjusted_energy = energy * 0.6 + 0.4;
	if (adjusted_energy < 1.0) {
		COLOR = mix(COLOR, vec4(0, 0, 0, 1), adjusted_energy);
	} else {
		COLOR = mix(COLOR, vec4(0, 0, 0, 1), 1.0);
	}
	
	COLOR.rgb = palette_limiter(COLOR.rgb);
	
	
}