shader_type spatial;

uniform vec3 color1 : source_color = vec3(0.8, 0.6, 0.4);
uniform vec3 color2 : source_color = vec3(0.5, 0.35, 0.25);
uniform vec3 color3 : source_color = vec3(0.3, 0.2, 0.15);
uniform float band_scale : hint_range(0.5, 10.0) = 3.0;
uniform float band_smoothness : hint_range(0.01, 0.5) = 0.15;
uniform float rim_strength : hint_range(0.0, 2.0) = 0.8;
uniform float spot_amount : hint_range(0.0, 1.0) = 0.3;
uniform float spot_size : hint_range(1.0, 20.0) = 5.0;
uniform float offset : hint_range(0.0, 100.0) = 0.0;
uniform float seed : hint_range(0.0, 1000.0) = 0.0;
uniform float rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool multiply_vertex_color = false;
uniform sampler2D noise_texture : repeat_enable;

// Simple hash function
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void fragment() {
    // Rotate UVs
    float angle = radians(rotation);
    vec2 centered_uv = UV - 0.5;
    vec2 rotated_uv = vec2(
        centered_uv.x * cos(angle) - centered_uv.y * sin(angle),
        centered_uv.x * sin(angle) + centered_uv.y * cos(angle)
    ) + 0.5;
    
    float random_offset = hash(seed) * 10.0;
    vec2 seeded_uv = rotated_uv + vec2((offset + random_offset) * 0.1);
    
    // Large gradient bands (vertical)
    float noise_val = texture(noise_texture, seeded_uv * 2.0).r;
    float bands = sin(seeded_uv.y * band_scale + noise_val * 0.5) * 0.5 + 0.5;
    
    // Posterize into distinct color regions
    float stepped = smoothstep(0.3 - band_smoothness, 0.3 + band_smoothness, bands);
    float stepped2 = smoothstep(0.6 - band_smoothness, 0.6 + band_smoothness, bands);
    
    // Mix three colors in large areas
    vec3 color = color3;
    color = mix(color, color2, stepped);
    color = mix(color, color1, stepped2);
    
    // Add color spots using noise
    float spot_noise = texture(noise_texture, seeded_uv * spot_size).r;
    float spots = smoothstep(0.6, 0.65, spot_noise);
    
    // Determine which adjacent color to use for spots
    vec3 spot_color = color2;
    if (stepped2 > 0.5) {
        spot_color = color2; // Light areas get mid spots
    } else if (stepped > 0.5) {
        spot_color = mix(color3, color1, 0.5); // Mid areas get mixed spots
    } else {
        spot_color = color2; // Dark areas get mid spots
    }
    
    color = mix(color, spot_color, spots * spot_amount);
    
	// multiply final color by vertex color set in script
    
	if (multiply_vertex_color) {
		ALBEDO = color * COLOR.rgb;
	} else {
		ALBEDO = color;
	}
    ROUGHNESS = 0.7;
}

void light() {
    // Simple cel-shaded lighting
    float NdotL = dot(NORMAL, LIGHT);
    float light_step = smoothstep(0.0, 0.01, NdotL);
    
    // Rim light
    float rim = 1.0 - dot(VIEW, NORMAL);
    rim = smoothstep(0.6, 1.0, rim);
    
    DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ATTENUATION * light_step;
    DIFFUSE_LIGHT += color1 * rim * rim_strength * LIGHT_COLOR;
}