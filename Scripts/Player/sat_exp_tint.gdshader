shader_type canvas_item;

// Uniforms to control the color adjustments from the Inspector or code
group_uniforms ColorAdjustments;
uniform float exposure : hint_range(0.0, 5.0) = 1.0;
uniform float saturation : hint_range(0.0, 3.0) = 1.0;
uniform vec4 tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    // 1. Sample the texture color
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 2. Apply Exposure (multiplies brightness)
    vec3 color = tex_color.rgb * exposure;
    
    // 3. Apply Saturation
    // Using standard luminance weights to convert to grayscale
    float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(luminance), color, saturation);
    
    // 4. Apply Tint
    color *= tint.rgb;
    
    // Output final color while preserving original alpha
    COLOR = vec4(color, tex_color.a * tint.a);
}