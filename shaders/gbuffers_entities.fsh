#version 450 compatibility

in vec4 vertex_color_gs;
in vec3 normal_gs;
in vec2 texcoord_gs;

uniform sampler2D texture;

layout(location = 0) out vec4 color_fs;

void main() {
    vec4 texture_color = texture2D(texture, texcoord_gs);
    vec3 color = texture_color.rgb * vertex_color_gs.rgb;
    float alpha = texture_color.a * vertex_color_gs.a;

    color_fs = vec4(color, alpha);
}
