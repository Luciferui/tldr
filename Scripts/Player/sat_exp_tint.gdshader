// Shader d'ajustement colorimétrique : exposition, saturation et teinte (utilisé notamment pour griser/activer les icônes de sorts selon les combos).
shader_type canvas_item;

// Paramètres de contrôle des ajustements de couleur
group_uniforms ColorAdjustments;
uniform float exposure : hint_range(0.0, 5.0) = 1.0;
uniform float saturation : hint_range(0.0, 3.0) = 1.0;
uniform vec4 tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    // 1. Échantillonnage de la texture d'origine
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 2. Application de l'exposition (multiplication de la luminosité)
    vec3 color = tex_color.rgb * exposure;
    
    // 3. Application de la saturation
    // Utilisation des poids standards de luminance pour la conversion en niveaux de gris
    float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(luminance), color, saturation);
    
    // 4. Application de la teinte
    color *= tint.rgb;
    
    // Rendu final en conservant la transparence d'origine
    COLOR = vec4(color, tex_color.a * tint.a);
}