shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 replace_color : source_color = vec4(0.0, 0.4, 1.0, 1.0);
uniform float tolerance : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    // Distance entre le pixel et la couleur cible (en ignorant l'alpha)
    float dist = distance(current_color.rgb, target_color.rgb);
    
    if (dist < tolerance) {
        // 1. Calcule la différence (delta) entre le pixel et la couleur rouge cible
        vec3 delta = current_color.rgb - target_color.rgb;
        
        // 2. Applique cette différence sur la couleur bleue de remplacement
        vec3 final_rgb = replace_color.rgb + delta;
        
        // 3. Empêche les valeurs de dépasser [0.0, 1.0] et conserve l'alpha
        COLOR = vec4(clamp(final_rgb, 0.0, 1.0), current_color.a);
    } else {
        COLOR = current_color;
    }
}