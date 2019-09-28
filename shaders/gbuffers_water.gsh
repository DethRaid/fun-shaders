#version 450 compatibility

#extension GL_ARB_geometry_shader4 : enable

layout(triangles) in;
layout(triangle_strip, max_vertices = 7) out;

in VS_OUT {
    vec4 vertex_color_vs;
    vec3 normal_vs;
    vec2 texcoord_vs;
} gs_in[];

uniform float frameTimeCounter;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse; 
uniform mat4 gbufferProjectionInverse;

out vec4 vertex_color_gs;
out vec3 normal_gs;
out vec2 texcoord_gs;

/*!
 * \brief Applies waves to the current gl_Position
 */
void apply_waves() {
    vec4 world_pos = gbufferProjectionInverse * gl_Position;
    world_pos = gbufferModelViewInverse * world_pos;
    world_pos /= world_pos.w;
    world_pos.xyz += cameraPosition;

    const vec2 wave_direction = normalize(vec2(1, 1));
    const float wave_height = 0.125 * sin(dot(wave_direction, world_pos.xz * 2) * frameTimeCounter * 0.0025);
    vec4 wave_pos = world_pos + vec4(0, wave_height, 0, 0);

    wave_pos.xyz -= cameraPosition;
    wave_pos = gbufferModelView * wave_pos;
    wave_pos = gbufferProjection * wave_pos;
    wave_pos /= wave_pos.w;
    
    gl_Position = wave_pos;
}

void main() {
    vertex_color_gs = gs_in[0].vertex_color_vs;
    normal_gs = gs_in[0].normal_vs;
    texcoord_gs = gs_in[0].texcoord_vs;
    gl_Position = gl_in[0].gl_Position;

    apply_waves();

    EmitVertex();
    
    vertex_color_gs = gs_in[0].vertex_color_vs * 0.5 + gs_in[1].vertex_color_vs * 0.5;
    normal_gs = gs_in[0].normal_vs * 0.5 + gs_in[1].normal_vs * 0.5;
    texcoord_gs = gs_in[0].texcoord_vs * 0.5 + gs_in[1].texcoord_vs * 0.5;
    gl_Position = gl_in[0].gl_Position * 0.5 + gl_in[1].gl_Position * 0.5;

    apply_waves();

    EmitVertex();
    
    vertex_color_gs = gs_in[0].vertex_color_vs * 0.5 + gs_in[2].vertex_color_vs * 0.5;
    normal_gs = gs_in[0].normal_vs * 0.5 + gs_in[2].normal_vs * 0.5;
    texcoord_gs = gs_in[0].texcoord_vs * 0.5 + gs_in[2].texcoord_vs * 0.5;
    gl_Position = gl_in[0].gl_Position * 0.5 + gl_in[2].gl_Position * 0.5;

    apply_waves();

    EmitVertex();
    
    vertex_color_gs = gs_in[1].vertex_color_vs;
    normal_gs = gs_in[1].normal_vs;
    texcoord_gs = gs_in[1].texcoord_vs;
    gl_Position = gl_in[1].gl_Position;
    
    apply_waves();

    EmitVertex();
    
    vertex_color_gs = gs_in[1].vertex_color_vs * 0.5 + gs_in[2].vertex_color_vs * 0.5;
    normal_gs = gs_in[1].normal_vs * 0.5 + gs_in[2].normal_vs * 0.5;
    texcoord_gs = gs_in[1].texcoord_vs * 0.5 + gs_in[2].texcoord_vs * 0.5;
    gl_Position = gl_in[1].gl_Position * 0.5 + gl_in[2].gl_Position * 0.5;

    apply_waves();

    EmitVertex();
    
    vertex_color_gs = gs_in[2].vertex_color_vs;
    normal_gs = gs_in[2].normal_vs;
    texcoord_gs = gs_in[2].texcoord_vs;
    gl_Position = gl_in[2].gl_Position;
    
    apply_waves();

    EmitVertex();
    
    vertex_color_gs = gs_in[0].vertex_color_vs * 0.5 + gs_in[2].vertex_color_vs * 0.5;
    normal_gs = gs_in[0].normal_vs * 0.5 + gs_in[2].normal_vs * 0.5;
    texcoord_gs = gs_in[0].texcoord_vs * 0.5 + gs_in[2].texcoord_vs * 0.5;
    gl_Position = gl_in[0].gl_Position * 0.5 + gl_in[2].gl_Position * 0.5;

    apply_waves();

    EmitVertex();

    EndPrimitive();
}