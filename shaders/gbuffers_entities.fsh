#version 450 compatibility

const int noiseTextureResolution = 64;

in GS_OUT {
    vec3 normal;
    vec2 texcoord;
    float fur_length;
} fs_in;

uniform sampler2D texture;

layout(location = 0) out vec4 color_fs;
layout(location = 1) out vec4 normal_lighting_out;

void main() {
    const vec4 texture_color = texture2D(texture, fs_in.texcoord);

    color_fs = texture_color * vec4(1.0, 1.0, 1.0, fs_in.fur_length);
}
