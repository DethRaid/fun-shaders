#version 450 compatibility

const int fur_noise_scale = 512;

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
    return step(pow(texture2D(noisetex, fs_in.texcoord * 15).r, 1.1), fs_in.normalized_offset);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    const vec2 texcoord_stepped = floor(fs_in.texcoord * fur_noise_scale) / fur_noise_scale;
    const vec2 texcoord_offset = vec2(
        rand(fs_in.texcoord * 37),
        rand(fs_in.texcoord * 11)
    ) / fur_noise_scale;

    const vec4 texture_color = texture2D(texture, fs_in.texcoord + texcoord_offset);

    const float fur_alpha = get_fur_alpha();

    color_fs = texture_color * vec4(1.0, 1.0, 1.0, fur_alpha);
    //color_fs = vec4(texcoord_offset, 0, 1);
}
