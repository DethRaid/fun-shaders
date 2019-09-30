#version 450 compatibility

const int noiseTextureResolution = 64;

in GS_OUT {
    vec3 normal;
    vec2 texcoord;
    float normalized_offset;
} fs_in;

uniform sampler2D texture;
uniform sampler2D noisetex;

layout(location = 0) out vec4 color_fs;
layout(location = 1) out vec4 normal_lighting_out;

float get_fur_alpha() {
    return step(fs_in.normalized_offset, texture2D(noisetex, fs_in.texcoord * 18).r);
}

void main() {
    const vec4 texture_color = texture2D(texture, fs_in.texcoord);

    const float fur_alpha = get_fur_alpha();

    color_fs = texture_color * vec4(1.0, 1.0, 1.0, fur_alpha);
}
