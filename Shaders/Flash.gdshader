shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec4 modulate = COLOR;
    color.rgb = mix(color.rgb * modulate.rgb, flash_color.rgb, flash_opacity);
    color.a *= modulate.a;
    COLOR = color;
}