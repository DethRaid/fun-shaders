#version 450 compatibility

layout(triangles) in;
layout(triangle_strip, max_vertices = 9) out;

in vec4 vertex_color_vs[];
in vec3 normal_vs[];
in vec2 texcoord_vs[];

out vec4 vertex_color_gs;
out vec3 normal_gs;
out vec2 texcoord_gs;

void emit_fur_layer(in float offset) {
    vertex_color_gs = vertex_color_vs[0];
    normal_gs = normal_vs[0];
    texcoord_gs = texcoord_vs[0];
    gl_Position = vec4(normal_gs, 0) * offset + gl_in[0].gl_Position;
    EmitVertex();
    
    vertex_color_gs = vertex_color_vs[1];
    normal_gs = normal_vs[1];
    texcoord_gs = texcoord_vs[1];
    gl_Position = vec4(normal_gs, 0) * offset + gl_in[1].gl_Position;
    EmitVertex();
    
    vertex_color_gs = vertex_color_vs[2];
    normal_gs = normal_vs[2];
    texcoord_gs = texcoord_vs[2];
    gl_Position = vec4(normal_gs, 0) * offset + gl_in[2].gl_Position;
    EmitVertex();
}

void main() {
    emit_fur_layer(0);

    emit_fur_layer(0.125);
    emit_fur_layer(0.25);

    EndPrimitive();
}