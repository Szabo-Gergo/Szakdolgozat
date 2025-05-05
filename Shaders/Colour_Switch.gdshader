shader_type canvas_item;
uniform int number_of_colors : hint_range(0, 12, 1);
uniform vec4 target_color[12] : source_color;
uniform vec4 replace_color[21] : source_color;
uniform float tolerance : hint_range(0, 1);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

	for (int i = 0; i < number_of_colors; i++){
 	   float dist = distance(tex_color.rgb, target_color[i].rgb);
    	if (dist < tolerance) {
        	tex_color.rgb = replace_color[i].rgb;
    	}
		COLOR = tex_color;
 	}
}