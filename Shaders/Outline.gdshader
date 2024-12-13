shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float pixel_size;

void fragment(){
//1px mérete texture koordinátában
	float pixel_size_x = pixel_size/float(textureSize(TEXTURE, 0).x);
	float pixel_size_y = pixel_size/float(textureSize(TEXTURE, 0).y);

//Sprite textúra
	vec4 sprite = texture(TEXTURE, UV);

	float alpha = -8.0 * sprite.a;

	alpha += texture(TEXTURE, UV + vec2(pixel_size_x, 0)).a;
	alpha += texture(TEXTURE, UV + vec2(-pixel_size_x, 0)).a;
	alpha += texture(TEXTURE, UV + vec2(0, pixel_size_y)).a;
	alpha += texture(TEXTURE, UV + vec2(0, -pixel_size_y)).a;

	alpha += texture(TEXTURE, UV + vec2(pixel_size_x, pixel_size_y)).a;
	alpha += texture(TEXTURE, UV + vec2(-pixel_size_x, pixel_size_y)).a;
	alpha += texture(TEXTURE, UV + vec2(-pixel_size_x, -pixel_size_y)).a;
	alpha += texture(TEXTURE, UV + vec2(pixel_size_x, -pixel_size_y)).a;

	vec4 final_color = mix(sprite, outline_color, clamp(alpha, 0.0, 1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite.a, 0.0, 1.0));
}