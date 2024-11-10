shader_type canvas_item;

render_mode unshaded;

uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float density: hint_range(0.0, 1.0) = 0.25;
uniform float threshold: hint_range(0.0, 2.0) = 0.5;
uniform vec2 speed = vec2(0.02, 0.01);
uniform float fluffiness : hint_range(0.0, 2.0) = 0.1;




void fragment() {

	 vec2 uv = UV + speed * TIME;

	vec4 noise1 = texture(noise_texture, mod(uv + TIME * 2.5 * speed, 1.0));
	vec4 noise2 = texture(noise_texture, mod(uv + TIME * (2.5 + fluffiness * 3.0) * speed, 1.0));
	float combinedNoise = noise1.r + noise2.r;

	 if (combinedNoise > threshold) {
        COLOR.a *= density;
    } else {
        COLOR.a *= 0.0;
    }

}
