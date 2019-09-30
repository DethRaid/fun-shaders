#version 450 compatibility

#extension GL_ARB_geometry_shader4 : enable

#define SUBDIVISION_LEVEL 1

const int num_vertices_long_side = int(pow(2, SUBDIVISION_LEVEL));
const int num_vertices_short_side = num_vertices_long_side / 2;
const int num_vertices = num_vertices_long_side * num_vertices_short_side;

layout(triangles) in;
layout(triangle_strip, max_vertices = num_vertices) out;

in VS_OUT {
    vec4 vertex_color;
    vec3 normal;
    vec4 coords;
} gs_in[];

uniform float frameTimeCounter;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse; 
uniform mat4 gbufferProjectionInverse;

out GS_OUT {
    vec4 vertex_color;
    vec3 normal;
    vec4 coords;
} gs_out;

/*!
 * \brief Applies waves to the current gl_Position
 */
void apply_waves() {
    vec4 world_pos = gbufferModelViewInverse * gbufferProjectionInverse * gl_Position;
    world_pos.xyz += cameraPosition;

    const vec2 wave_direction = normalize(vec2(1, 1));
    const float wave_height = 0.125 * sin(dot(wave_direction, world_pos.xz * 2) * frameTimeCounter * 0.0025);
    vec4 wave_pos = world_pos + vec4(0, wave_height, 0, 0);

    wave_pos.xyz -= cameraPosition;
    wave_pos = gbufferProjection * gbufferModelView * wave_pos;
    
    gl_Position = wave_pos;
}

#define EMIT_VERTEX(s, t)                                                   \
gs_out.vertex_color = vertex_color_delta_1_0 * s + vertex_color_delta_1_2 * t + gs_in[1].vertex_color;   \
gs_out.normal = normal_delta_1_0 * s + normal_delta_1_2 * t + gs_in[1].normal;  \
gs_out.coords = coords_delta_1_0 * s + coords_delta_1_2 * t + gs_in[1].coords;  \
gl_Position = position_delta_1_0 * s + position_delta_1_0 * t + gl_in[1].gl_Position;   \
apply_waves();                                                               \
EmitVertex();

void main() {    
    const vec4 vertex_color_delta_1_0 = gs_in[0].vertex_color - gs_in[1].vertex_color;
    const vec3 normal_delta_1_0 = gs_in[0].normal - gs_in[1].normal;
    const vec4 coords_delta_1_0 = gs_in[0].coords - gs_in[1].coords;
    const vec4 position_delta_1_0 = gl_in[0].gl_Position - gl_in[1].gl_Position;

    const vec4 vertex_color_delta_1_2 = gs_in[2].vertex_color - gs_in[1].vertex_color;
    const vec3 normal_delta_1_2 = gs_in[2].normal - gs_in[1].normal;
    const vec4 coords_delta_1_2 = gs_in[2].coords - gs_in[1].coords;
    const vec4 position_delta_1_2 = gl_in[2].gl_Position - gl_in[1].gl_Position;

    const vec2 st_step = vec2(1.0 / num_vertices_long_side, 1.0 / num_vertices_short_side);

    for(int y = 0; y < num_vertices_short_side; y++) {
        const float t = st_step.t * y;

        for(int x = 0; x < num_vertices_long_side; x++) {
            const float s = st_step.s * x;

            EMIT_VERTEX(s, t);
            EMIT_VERTEX(s, t + st_step.t);
        }

        EndPrimitive();
    }
}