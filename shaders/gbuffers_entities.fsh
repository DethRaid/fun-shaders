#version 450 compatibility

const int noiseTextureResolution = 64;

in GS_OUT {
    vec3 normal;
    vec2 texcoord;
    flat int is_fur;
} fs_in;

uniform sampler2D texture;
uniform sampler2D noisetex;

layout(location = 0) out vec4 color_fs;
layout(location = 1) out vec4 normal_lighting_out;

float get_fur_alpha() {
    // We're brancing on a flat vertex attribute. This is gonna be so fucking coherent guys. Literally maximum coherency
    if(fs_in.is_fur == 1) {
        return step(texture2D(noisetex, fs_in.texcoord * 3.14159).r, 0.5);//pow(texture2D(noisetex, fs_in.texcoord * 1.61803).r, 2.0);
    } else {
        return 1.0;
    }
}

void main() {
    const vec4 texture_color = texture2D(texture, fs_in.texcoord);

    const float fur_alpha = get_fur_alpha();

    color_fs = texture_color * vec4(1.0, 1.0, 1.0, fur_alpha);
}
