#version 450 compatibility

in GS_OUT {
    vec4 vertex_color;
    vec3 normal;
    vec4 coords;
} fs_in;

uniform vec3 shadowLightPosition;
uniform sampler2D lightmap;
uniform int worldTime;

uniform sampler2D texture;

layout(location = 0) out vec4 color_fs;

vec3 get_main_light_color() {
    if(worldTime >= 500 || worldTime <= 12500) {
        return vec3(1);

    } else if(worldTime < 500 || worldTime > 12500) {
        return vec3(0.1);
    }
}

void main() {
    vec4 texture_color = texture2D(texture, fs_in.coords.xy);
    vec3 color = texture_color.rgb * fs_in.vertex_color.rgb;
    float alpha = texture_color.a * fs_in.vertex_color.a;

    const vec3 main_light_vector = normalize(shadowLightPosition);
    const float main_light_strength = clamp(dot(fs_in.normal, main_light_vector), 0.0, 1.0);
    const vec3 main_light_color = get_main_light_color();
    const vec3 main_light = main_light_color * main_light_strength;

    const vec2 other_light_texcoord = fs_in.coords.zw / vec2(255.0, 2048);
    const vec3 other_light = texture2D(lightmap, other_light_texcoord).rgb;

    const vec3 incoming_diffuse = vec3(main_light + other_light);
    const vec3 reflected_diffuse = color * incoming_diffuse;

    const vec3 color_out = reflected_diffuse * 0.5; // Linear tonemapping, cause it's easy

    color_fs = vec4(color, alpha);
}
