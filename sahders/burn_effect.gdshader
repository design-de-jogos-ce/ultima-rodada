shader_type canvas_item;

uniform float burn_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 burn_color : source_color = vec4(1.0, 0.5, 0.0, 1.0); // cor do fogo

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float burn = smoothstep(burn_progress - 0.1, burn_progress, UV.y);
    vec4 fire = mix(burn_color, tex, burn);
    COLOR = fire * tex.a;
}
