#version 450 compatibility

out VS_OUT {
    vec4 vertex_color;
    vec3 normal;
    vec4 coords;
} vs_out;

void main() {
    vs_out.vertex_color = gl_Color;
    vs_out.normal = gl_NormalMatrix * gl_Normal.xyz;
    vs_out.coords.st = gl_MultiTexCoord0.st;
    vs_out.coords.pq = gl_MultiTexCoord1.st;

    gl_Position = ftransform();
}