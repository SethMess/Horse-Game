shader_type canvas_item;

uniform float blend : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Define two colors for the gradient:
    vec3 top_color = vec3(1.0, 0.5, 0.0);   // bright orange (sunset)
    vec3 bottom_color = vec3(0.1, 0.0, 0.3);  // deep purple
    // Mix the colors based solely on the blend uniform:
    vec3 col = mix(bottom_color, top_color, blend);
    COLOR = vec4(col, 0.1);
}
