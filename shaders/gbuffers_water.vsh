#version 450 compatibility

out VS_OUT {
    vec4 vertex_color_vs;
    vec3 normal_vs;
    vec2 texcoord_vs;
} vs_out;

void main() {
    vs_out.vertex_color_vs = gl_Color;
    vs_out.normal_vs = gl_Normal.xyz;
    vs_out.texcoord_vs = gl_MultiTexCoord0.st;

    gl_Position = ftransform();
}